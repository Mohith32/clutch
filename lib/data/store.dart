import 'dart:convert';
import 'dart:ui';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/effects.dart';
import '../domain/profile.dart';
import '../l10n/app_localizations.dart';

/// App-wide state. One encrypted JSON blob in the platform keystore/keychain
/// (Android Keystore / iOS Keychain), so data is encrypted at rest without a DB.
// ponytail: whole-blob storage, fine for a handful of family cards; move to an
// encrypted DB if profiles ever carry photos or history.
class AppStore extends ChangeNotifier {
  AppStore({FlutterSecureStorage? storage}) : _ss = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _ss;
  static const _key = 'clutch.v1';

  List<Profile> profiles = [];
  int current = 0;
  bool onboarded = false;
  String themeMode = 'system'; // system | light | dark
  String? localeCode; // null = system; en | hi | hi_Latn | te
  bool reminders = true;
  bool lock = false;
  String? sosOverride;
  bool askedNotifications = false;
  bool nowBar = false; // emergency pill in the Now Bar (Android 16 Live Update)

  Profile? get selected => profiles.isEmpty ? null : profiles[current.clamp(0, profiles.length - 1)];
  String get defaultSos => sosFor(PlatformDispatcher.instance.locale.countryCode);
  String get sos => (sosOverride?.trim().isNotEmpty ?? false) ? sosOverride!.trim() : defaultSos;

  Locale? get locale {
    final c = localeCode;
    if (c == null) return null;
    final p = c.split('_');
    return Locale.fromSubtags(languageCode: p[0], scriptCode: p.length > 1 ? p[1] : null);
  }

  /// Strings for code that runs without a BuildContext (notifications, widget).
  AppLocalizations get l10n {
    final l = locale ?? PlatformDispatcher.instance.locale;
    for (final c in [l, Locale(l.languageCode), const Locale('en')]) {
      try {
        return lookupAppLocalizations(c);
      } catch (_) {}
    }
    return lookupAppLocalizations(const Locale('en'));
  }

  Future<void> load() async {
    try {
      final raw = await _ss.read(key: _key);
      if (raw != null) _fromJson(jsonDecode(raw));
    } catch (e) {
      debugPrint('clutch: could not read store: $e');
    }
  }

  Map<String, dynamic> _toJson() => {
        'profiles': profiles.map((p) => p.toJson()).toList(),
        'current': current,
        'onboarded': onboarded,
        'themeMode': themeMode,
        'locale': localeCode,
        'reminders': reminders,
        'lock': lock,
        'sos': sosOverride,
        'askedNotifications': askedNotifications,
        'nowBar': nowBar,
      };

  void _fromJson(Map j) {
    profiles = [for (final p in (j['profiles'] ?? const []) as List) Profile.fromJson(p)];
    current = (j['current'] as int?) ?? 0;
    onboarded = j['onboarded'] ?? false;
    themeMode = j['themeMode'] ?? 'system';
    localeCode = j['locale'];
    reminders = j['reminders'] ?? true;
    lock = j['lock'] ?? false;
    sosOverride = j['sos'];
    askedNotifications = j['askedNotifications'] ?? false;
    nowBar = j['nowBar'] ?? false;
  }

  Future<void> save() async {
    notifyListeners();
    await _ss.write(key: _key, value: jsonEncode(_toJson()));
    await Effects.sync(this);
  }

  /// Insert or replace by id. [touch] bumps the "last updated" date printed on outputs.
  Future<void> upsert(Profile p, {bool touch = true}) {
    if (touch) p.updatedAt = DateTime.now();
    final i = profiles.indexWhere((x) => x.id == p.id);
    if (i >= 0) {
      profiles[i] = p;
    } else {
      profiles.add(p);
      current = profiles.length - 1;
    }
    return save();
  }

  Future<void> duplicate(Profile p) {
    final c = p.copy()
      ..id = newId()
      ..displayName = '${p.displayName} 2'
      ..vibe = (p.vibe + 1) % 7;
    return upsert(c);
  }

  Future<void> delete(Profile p) {
    profiles.removeWhere((x) => x.id == p.id);
    current = current.clamp(0, profiles.isEmpty ? 0 : profiles.length - 1);
    return save();
  }

  void select(int i) {
    if (i == current) return;
    current = i;
    save();
  }

  // ---- Backup (F11) ----

  Future<String> backup({String passphrase = ''}) =>
      encodeBackup([for (final p in profiles) p.toJson()], passphrase);

  /// Returns how many profiles were imported. Same id replaces, new id appends.
  Future<int> restore(String file, {String passphrase = ''}) async {
    final list = await decodeBackup(file, passphrase);
    for (final j in list) {
      final p = Profile.fromJson(j);
      final i = profiles.indexWhere((x) => x.id == p.id);
      i >= 0 ? profiles[i] = p : profiles.add(p);
    }
    await save();
    return list.length;
  }
}

class WrongPassphrase implements Exception {}

class NeedsPassphrase implements Exception {}

final _kdf = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 120000, bits: 256);
final _aes = AesGcm.with256bits();

Future<String> encodeBackup(List<Map<String, dynamic>> profiles, String passphrase) async {
  final plain = jsonEncode({'profiles': profiles});
  if (passphrase.isEmpty) return jsonEncode({'clutch': 1, 'profiles': profiles});
  final salt = SecretKeyData.random(length: 16).bytes;
  final key = await _kdf.deriveKeyFromPassword(password: passphrase, nonce: salt);
  final box = await _aes.encrypt(utf8.encode(plain), secretKey: key);
  return jsonEncode({
    'clutch': 1,
    'enc': 'pbkdf2-sha256-120k+aes-256-gcm',
    'salt': base64Encode(salt),
    'nonce': base64Encode(box.nonce),
    'mac': base64Encode(box.mac.bytes),
    'data': base64Encode(box.cipherText),
  });
}

Future<List<Map>> decodeBackup(String file, String passphrase) async {
  final j = jsonDecode(file) as Map;
  if (j['clutch'] != 1) throw const FormatException('not a clutch backup');
  if (j['enc'] == null) return List<Map>.from(j['profiles'] as List);
  if (passphrase.isEmpty) throw NeedsPassphrase();
  final key = await _kdf.deriveKeyFromPassword(password: passphrase, nonce: base64Decode(j['salt']));
  try {
    final plain = await _aes.decrypt(
      SecretBox(base64Decode(j['data']), nonce: base64Decode(j['nonce']), mac: Mac(base64Decode(j['mac']))),
      secretKey: key,
    );
    return List<Map>.from((jsonDecode(utf8.decode(plain)) as Map)['profiles'] as List);
  } on SecretBoxAuthenticationError {
    throw WrongPassphrase();
  }
}
