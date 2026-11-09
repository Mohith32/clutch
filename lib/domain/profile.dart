import 'dart:convert';
import 'dart:math';

/// The three things Clutch generates from a profile.
enum Output { wallpaper, card, qr }

/// Fields a user can show or hide separately on each [Output].
enum Field { name, blood, allergies, conditions, meds, contacts, doctor, donor, notes, sos }

const bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'unknown'];

/// Languages an output (wallpaper, card) can be printed in.
const outputLanguages = {'en': 'English', 'hi': 'हिन्दी', 'te': 'తెలుగు'};

const maxContacts = 3;
const maxNotes = 140;
const qrMax = 300;

/// Static page that renders a scanned QR in Clutch's style (docs/index.html,
/// served by GitHub Pages). Details travel in the URL fragment, which browsers
/// never send to the server.
const cardHost = 'https://mohith32.github.io/clutch/';

class Med {
  String name, dose;
  Med({this.name = '', this.dose = ''});
  Map<String, dynamic> toJson() => {'name': name, 'dose': dose};
  factory Med.fromJson(Map j) => Med(name: j['name'] ?? '', dose: j['dose'] ?? '');
  String get label => [name.trim(), dose.trim()].where((s) => s.isNotEmpty).join(' ');
}

class Contact {
  String name, relation, phone;
  Contact({this.name = '', this.relation = '', this.phone = ''});
  Map<String, dynamic> toJson() => {'name': name, 'relation': relation, 'phone': phone};
  factory Contact.fromJson(Map j) =>
      Contact(name: j['name'] ?? '', relation: j['relation'] ?? '', phone: j['phone'] ?? '');
  bool get isEmpty => name.trim().isEmpty && phone.trim().isEmpty;
  String get who => relation.trim().isEmpty ? name.trim() : '${name.trim()} (${relation.trim()})';
}

/// One person's emergency details. Mutable on purpose: the editor writes into it directly.
class Profile {
  String id;
  String displayName;
  String bloodGroup;
  List<String> allergies, conditions;
  List<Med> meds;
  List<Contact> contacts;
  String doctorName, doctorPhone;
  bool? organDonor;
  String notes;
  String language;
  Map<Output, Set<Field>> visibility;
  DateTime updatedAt;
  int vibe; // index into the app's vibe palette, used for card colour
  int wpStyle; // wallpaper background style
  double wpOffset; // 0 = top of the safe zone, 1 = bottom
  int wpLayout; // 0 = QR only (default), 1 = details
  bool qrLink; // QR opens the Clutch page (true) or plain text (false)
  String? wpPhoto; // user's own photo behind the QR, stored in app files

  Profile({
    String? id,
    this.displayName = '',
    this.bloodGroup = 'unknown',
    List<String>? allergies,
    List<String>? conditions,
    List<Med>? meds,
    List<Contact>? contacts,
    this.doctorName = '',
    this.doctorPhone = '',
    this.organDonor,
    this.notes = '',
    this.language = 'en',
    Map<Output, Set<Field>>? visibility,
    DateTime? updatedAt,
    this.vibe = 0,
    this.wpStyle = 0,
    this.wpOffset = 0.7,
    this.wpLayout = 0,
    this.qrLink = true,
    this.wpPhoto,
  })  : id = id ?? newId(),
        allergies = allergies ?? [],
        conditions = conditions ?? [],
        meds = meds ?? [],
        contacts = contacts ?? [],
        visibility = visibility ?? defaultVisibility(),
        updatedAt = updatedAt ?? DateTime.now();

  static Map<Output, Set<Field>> defaultVisibility() => {
        Output.wallpaper: {Field.name, Field.blood, Field.allergies, Field.contacts, Field.sos},
        Output.card: Field.values.toSet(),
        Output.qr: Field.values.toSet(),
      };

  bool shows(Output o, Field f) => visibility[o]!.contains(f);

  List<Contact> get realContacts => contacts.where((c) => !c.isEmpty).toList();
  List<Med> get realMeds => meds.where((m) => m.label.isNotEmpty).toList();
  bool get hasDoctor => doctorName.trim().isNotEmpty || doctorPhone.trim().isNotEmpty;
  bool get isStale => DateTime.now().difference(updatedAt).inDays >= 182;
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((s) => String.fromCharCode(s.runes.first)).join().toUpperCase();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'bloodGroup': bloodGroup,
        'allergies': allergies,
        'conditions': conditions,
        'medications': meds.map((m) => m.toJson()).toList(),
        'contacts': contacts.map((c) => c.toJson()).toList(),
        'doctor': {'name': doctorName, 'phone': doctorPhone},
        'organDonor': organDonor,
        'notes': notes,
        'language': language,
        'visibility': {for (final e in visibility.entries) e.key.name: e.value.map((f) => f.name).toList()},
        'updatedAt': updatedAt.toIso8601String(),
        'vibe': vibe,
        'wpStyle': wpStyle,
        'wpOffset': wpOffset,
        'wpLayout': wpLayout,
        'qrLink': qrLink,
        'wpPhoto': wpPhoto,
      };

  factory Profile.fromJson(Map j) {
    final vis = defaultVisibility();
    final rawVis = j['visibility'];
    if (rawVis is Map) {
      for (final o in Output.values) {
        final list = rawVis[o.name];
        if (list is List) vis[o] = Field.values.where((f) => list.contains(f.name)).toSet();
      }
    }
    final doc = (j['doctor'] as Map?) ?? const {};
    return Profile(
      id: j['id'] as String?,
      displayName: j['displayName'] ?? '',
      bloodGroup: bloodGroups.contains(j['bloodGroup']) ? j['bloodGroup'] : 'unknown',
      allergies: List<String>.from(j['allergies'] ?? const []),
      conditions: List<String>.from(j['conditions'] ?? const []),
      meds: [for (final m in (j['medications'] ?? const []) as List) Med.fromJson(m)],
      contacts: [for (final c in (j['contacts'] ?? const []) as List) Contact.fromJson(c)].take(maxContacts).toList(),
      doctorName: doc['name'] ?? '',
      doctorPhone: doc['phone'] ?? '',
      organDonor: j['organDonor'] as bool?,
      notes: j['notes'] ?? '',
      language: outputLanguages.containsKey(j['language']) ? j['language'] : 'en',
      visibility: vis,
      updatedAt: DateTime.tryParse(j['updatedAt'] ?? '') ?? DateTime.now(),
      vibe: (j['vibe'] as num?)?.toInt() ?? 0,
      wpStyle: (j['wpStyle'] as num?)?.toInt() ?? 0,
      wpOffset: (j['wpOffset'] as num?)?.toDouble() ?? 0.7,
      wpLayout: (j['wpLayout'] as num?)?.toInt() ?? 0,
      qrLink: j['qrLink'] as bool? ?? true,
      wpPhoto: j['wpPhoto'] as String?,
    );
  }

  Profile copy() => Profile.fromJson(toJson());
}

String newId() {
  final r = Random.secure();
  final b = List<int>.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40; // UUID v4
  b[8] = (b[8] & 0x3f) | 0x80;
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
}

String ymd(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Empty is valid (every field but the name is optional). Otherwise 6-15 digits,
/// an optional leading +, and spaces, dashes or brackets between.
bool validPhone(String s) {
  final t = s.trim();
  if (t.isEmpty) return true;
  if (!RegExp(r'^\+?[0-9(][0-9 ()\-]*$').hasMatch(t)) return false;
  final digits = t.replaceAll(RegExp(r'\D'), '').length;
  return digits >= 6 && digits <= 15;
}

const _sosByCountry = {
  'IN': '112', 'US': '911', 'CA': '911', 'MX': '911', 'GB': '999', 'IE': '112', 'AU': '000',
  'NZ': '111', 'JP': '119', 'KR': '119', 'CN': '120', 'BR': '192', 'ZA': '10111', 'AE': '999',
  'SA': '997', 'SG': '995', 'MY': '999', 'PK': '1122', 'BD': '999', 'LK': '1990', 'NP': '102',
  'PH': '911', 'ID': '112', 'TH': '1669',
};

/// Regional emergency number; 112 also works on most GSM networks worldwide.
String sosFor(String? countryCode) => _sosByCountry[countryCode?.toUpperCase()] ?? '112';

/// Compact plain-text summary any camera app can read offline. Segments go in
/// priority order; anything that would push the payload past [max] is shortened
/// (if there is room for something useful) or dropped. Labels stay in English on
/// purpose so any responder can read the scan.
String qrPayload(Profile p, {String? sos, int max = qrMax}) {
  bool show(Field f) => p.shows(Output.qr, f);
  final contacts = p.realContacts;
  final optional = <String>[
    if (show(Field.blood) && p.bloodGroup != 'unknown') 'Blood ${p.bloodGroup}',
    if (show(Field.allergies) && p.allergies.isNotEmpty) 'Allergy: ${p.allergies.join(', ')}',
    if (show(Field.contacts) && contacts.isNotEmpty) 'Call: ${contacts.first.who} ${contacts.first.phone.trim()}',
    if (show(Field.meds) && p.realMeds.isNotEmpty) 'Meds: ${p.realMeds.map((m) => m.label).join(', ')}',
    if (show(Field.conditions) && p.conditions.isNotEmpty) 'Conditions: ${p.conditions.join(', ')}',
    if (show(Field.sos) && sos != null && sos.isNotEmpty) 'SOS $sos',
    if (show(Field.contacts) && contacts.length > 1)
      'Also: ${contacts.skip(1).map((c) => '${c.who} ${c.phone.trim()}').join(', ')}',
    if (show(Field.doctor) && p.hasDoctor) 'Doctor: ${p.doctorName.trim()} ${p.doctorPhone.trim()}'.trim(),
    if (show(Field.donor) && p.organDonor == true) 'Organ donor',
    if (show(Field.notes) && p.notes.trim().isNotEmpty) 'Note: ${p.notes.trim()}',
  ];
  final parts = <String>[
    'EMERGENCY',
    if (show(Field.name) && p.displayName.trim().isNotEmpty) _cut(p.displayName.trim(), 40),
  ];
  final tail = 'Updated ${ymd(p.updatedAt)}';
  const sep = ' | ';
  int len(List<String> xs) => [...xs, tail].join(sep).length;
  for (final s in optional) {
    final room = max - len(parts) - sep.length;
    if (s.length <= room) {
      parts.add(s);
    } else if (room >= 16) {
      parts.add(_cut(s, room));
    }
  }
  return [...parts, tail].join(sep);
}

String _cut(String s, int n) => s.length <= n ? s : '${s.substring(0, n - 1).trimRight()}…';

/// What the QR actually encodes, per the profile's choice.
String qrData(Profile p, {String? sos}) => p.qrLink ? qrUrl(p, sos: sos) : qrPayload(p, sos: sos);

/// Link to the Clutch page with the payload in the fragment. The text is
/// shortened until the whole URL fits in [max] characters.
String qrUrl(Profile p, {String? sos, int max = qrMax}) {
  var budget = max - cardHost.length - 1;
  while (true) {
    final url = '$cardHost#${encodeQrFragment(qrPayload(p, sos: sos, max: budget))}';
    if (url.length <= max || budget <= 40) return url;
    budget -= 10;
  }
}

final _plain = RegExp(r"[A-Za-z0-9\-.,:()']");

/// Compact, URL-safe form of [qrPayload]: segments joined by "~", spaces as
/// "_", everything else percent-encoded. docs/index.html reverses it.
String encodeQrFragment(String text) => text.split(' | ').map((seg) {
      final b = StringBuffer();
      for (final r in seg.runes) {
        final ch = String.fromCharCode(r);
        if (ch == ' ') {
          b.write('_');
        } else if (_plain.hasMatch(ch)) {
          b.write(ch);
        } else {
          for (final byte in utf8.encode(ch)) {
            b.write('%${byte.toRadixString(16).toUpperCase().padLeft(2, '0')}');
          }
        }
      }
      return b.toString();
    }).join('~');

String decodeQrFragment(String f) =>
    f.split('~').map((s) => Uri.decodeComponent(s.replaceAll('_', ' '))).join(' | ');
