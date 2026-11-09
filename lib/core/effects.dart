import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Center;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_widget/home_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/store.dart';
import '../features/output_studio/outputs.dart';
import '../main.dart';
import 'theme.dart';

bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isIOS => !kIsWeb && Platform.isIOS;

/// Android-only bits Flutter has no API for (see MainActivity.kt).
class Native {
  static const _c = MethodChannel('clutch/native');

  static Future<void> setLockWallpaper(Uint8List png) => _c.invokeMethod('setLockWallpaper', png);
  static Future<void> setSecure(bool on) async {
    if (isAndroid) await _c.invokeMethod('setSecure', on);
  }

  static Future<({String name, String phone})?> pickContact() async {
    final m = await _c.invokeMapMethod<String, String>('pickContact');
    return m == null ? null : (name: m['name'] ?? '', phone: m['phone'] ?? '');
  }

  static Future<String?> openTextFile() => _c.invokeMethod<String>('openDocument');
  static Future<bool> nfcAvailable() async =>
      isAndroid && (await _c.invokeMethod<bool>('nfcAvailable') ?? false);

  /// Completes once a tag has been written; throws PlatformException on failure.
  static Future<void> nfcWrite(String text) => _c.invokeMethod('nfcWrite', text);
  static Future<void> nfcCancel() => _c.invokeMethod('nfcCancel');

  /// System photo picker (no storage permission). Copies the image into app
  /// files and returns its path, or null if cancelled.
  static Future<String?> pickImage() => _c.invokeMethod<String>('pickImage');

  /// Lock-screen button: saves [png] for EmergencyActivity (showWhenLocked) and
  /// enables the "Clutch SOS" entry that can be set as a lock-screen shortcut.
  static Future<void> syncPass(Uint8List? png, {required bool shortcut}) =>
      _c.invokeMethod('syncPass', {'png': png, 'shortcut': shortcut});
  static Future<bool> openLockSettings() async => await _c.invokeMethod<bool>('openLockSettings') ?? false;

  /// Android 13+ system prompt to add the "Emergency QR" Quick Settings tile.
  /// Returns -1 when the prompt isn't available on this Android version.
  static Future<int> addTile(String label) async => await _c.invokeMethod<int>('addTile', label) ?? -1;
}

/// Keeps reminders (F12) and the home-screen widget (F14) in step with the store.
class Effects {
  static final _n = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      await _n.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
      _ready = true;
    } catch (e) {
      debugPrint('clutch: notifications unavailable: $e');
    }
  }

  static Future<void> askNotificationPermission() async {
    if (!_ready) return;
    await _n.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _n.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, sound: true);
  }

  static Future<void> sync(AppStore s) async {
    await _reminders(s).catchError((e) => debugPrint('clutch: reminders: $e'));
    await _widget(s).catchError((e) => debugPrint('clutch: widget: $e'));
    await _pass(s).catchError((e) => debugPrint('clutch: pass: $e'));
  }

  /// Keeps the lock-screen QR (EmergencyActivity, widget, tile) current. The QR
  /// image always reflects the selected card; the toggle only adds the
  /// "Clutch SOS" shortcut entry.
  static Future<void> _pass(AppStore s) async {
    if (!isAndroid) return;
    final p = s.selected;
    final overlay = navKey.currentState?.overlay;
    if (p == null || overlay == null) return Native.syncPass(null, shortcut: false);
    final png = await capture(overlay.context, Center(child: QrBadge(p: p, sos: s.sos)), QrBadge.exportSize, 3, overlay: overlay);
    await Native.syncPass(png, shortcut: s.lockPass);
  }


  static Future<void> _reminders(AppStore s) async {
    if (!_ready) return;
    await _n.cancelAll();
    if (!s.reminders) return;
    final l = s.l10n;
    final now = DateTime.now();
    for (var i = 0; i < s.profiles.length; i++) {
      final p = s.profiles[i];
      var when = p.updatedAt.add(const Duration(days: 182));
      if (when.isBefore(now)) when = now.add(const Duration(days: 1));
      await _n.zonedSchedule(
        id: i,
        scheduledDate: tz.TZDateTime.from(when, tz.UTC),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails('checkin', l.remChannel),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: l.remTitle,
        body: l.remBody(p.displayName),
      );
    }
  }

  static Future<void> _widget(AppStore s) async {
    if (!isAndroid) return;
    final p = s.selected;
    final c = p?.realContacts.firstOrNull;
    await HomeWidget.saveWidgetData('name', p?.displayName ?? 'Clutch');
    await HomeWidget.saveWidgetData('blood', p == null || p.bloodGroup == 'unknown' ? '–' : p.bloodGroup);
    await HomeWidget.saveWidgetData('contact', c == null ? '' : '${c.who}  ${c.phone}');
    await HomeWidget.saveWidgetData('sos', 'SOS ${s.sos}');
    await HomeWidget.updateWidget(qualifiedAndroidName: 'app.clutch.clutch.ClutchWidgetProvider');
  }
}

/// Edit lock (F13): biometric or device PIN before editing or exporting.
class Lock {
  static final _auth = LocalAuthentication();
  static DateTime _until = DateTime(0);

  static Future<bool> supported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// One unlock covers two minutes so a single edit session doesn't nag.
  static Future<bool> check(AppStore s, String reason) async {
    if (!s.lock || DateTime.now().isBefore(_until)) return true;
    try {
      final ok = await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
      if (ok) _until = DateTime.now().add(const Duration(minutes: 2));
      return ok;
    } catch (e) {
      debugPrint('clutch: auth: $e');
      return false;
    }
  }
}
