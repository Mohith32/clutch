import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme.dart';
import '../../domain/profile.dart';
import '../../l10n/app_localizations.dart';

/// Outputs are read by strangers and paramedics: plain language, big type,
/// high contrast. They render in the profile's own language, not the app's.
AppLocalizations outL10n(Profile p) => lookupAppLocalizations(Locale(p.language));

/// Wallet card: 85.6 x 53.98 mm, laid out at 4 logical px per mm.
const cardSize = Size(342.4, 215.92);

/// 300 dpi export: 85.6 mm = 1011 px.
const cardPixelRatio = 1011 / 342.4;

class WpStyle {
  const WpStyle(this.bg, this.ink);
  final Color bg, ink;
}

const wpStyles = [
  WpStyle(C.paper, C.ink), // light
  WpStyle(C.night, C.snow), // dark
  WpStyle(C.sage, C.ink),
  WpStyle(C.rose, C.ink),
  WpStyle(C.sky, C.ink),
];

/// Wallpaper layouts: 0 = only "In case of emergency" + QR (default, private),
/// 1 = details card for people who want them readable at a glance.
const wpQrOnly = 0, wpDetails = 1;

File? wallpaperPhoto(Profile p) {
  final path = p.wpPhoto;
  if (path == null) return null;
  final f = File(path);
  return f.existsSync() ? f : null;
}

/// Lock-screen wallpaper. The top [clockZone] fraction is left clear for the
/// system clock; the emergency block floats between it and the bottom shortcuts.
class WallpaperArt extends StatelessWidget {
  const WallpaperArt({super.key, required this.p, required this.sos, this.preview = false});
  final Profile p;
  final String sos;
  final bool preview;

  static const clockZone = 0.36;
  static const bottomZone = 0.1;

  @override
  Widget build(BuildContext context) {
    final s = wpStyles[p.wpStyle.clamp(0, wpStyles.length - 1)];
    final photo = wallpaperPhoto(p);
    final hint = photo != null ? C.white : s.ink;
    return LayoutBuilder(builder: (context, box) {
      final w = box.maxWidth, h = box.maxHeight;
      final top = h * clockZone, usable = h * (1 - clockZone - bottomZone);
      final qrOnly = p.wpLayout == wpQrOnly;
      return Container(
        color: s.bg,
        child: Stack(children: [
          if (photo != null)
            Positioned.fill(child: Image.file(photo, fit: BoxFit.cover))
          else
            Positioned.fill(child: CustomPaint(painter: _Rings(s.ink.withValues(alpha: .06)))),
          if (preview)
            Positioned(
              left: w * .1,
              right: w * .1,
              top: h * .08,
              height: top - h * .11,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: hint.withValues(alpha: .35), width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('9:41',
                        style: TextStyle(fontFamily: display, fontSize: w * .18, fontWeight: FontWeight.w700, color: hint.withValues(alpha: .5))),
                    Text(context.l.clockZone.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: w * .035, letterSpacing: 1, color: hint.withValues(alpha: .6))),
                  ]),
                ),
              ),
            ),
          Positioned(
            left: w * .07,
            right: w * .07,
            top: top,
            height: usable,
            child: Align(
              alignment: Alignment(0, p.wpOffset * 2 - 1),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: qrOnly
                    ? SizedBox(width: 300, child: QrBadge(p: p, sos: sos))
                    : SizedBox(width: 360, child: _DetailsCard(p: p, l: outL10n(p), sos: sos, dark: s.bg == C.night && photo == null)),
              ),
            ),
          ),
        ]),
      );
    });
  }
}

/// "In case of emergency" + QR, nothing else on display. Scanning reveals the
/// details the user chose for the QR. Used on the wallpaper, the lock-screen
/// pass and the shared QR image.
class QrBadge extends StatelessWidget {
  const QrBadge({super.key, required this.p, required this.sos});
  final Profile p;
  final String sos;
  static const exportSize = Size(300, 380);

  @override
  Widget build(BuildContext context) {
    final l = outL10n(p);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .18), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.emergency_rounded, color: C.red, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(l.outIce,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 14, color: C.red, letterSpacing: .3)),
          ),
        ]),
        const SizedBox(height: 16),
        QrArt(data: qrData(p, sos: sos), size: 240),
        const SizedBox(height: 12),
        Text(l.outScan, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B6B72))),
      ]),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.p, required this.l, required this.sos, required this.dark});
  final Profile p;
  final AppLocalizations l;
  final String sos;
  final bool dark;

  bool show(Field f) => p.shows(Output.wallpaper, f);

  @override
  Widget build(BuildContext context) {
    final ink = dark ? C.snow : C.ink;
    final surface = dark ? C.nightCard : C.white;
    final red = dark ? C.redDark : C.red;
    final contacts = show(Field.contacts) ? p.realContacts : <Contact>[];
    final hasBlood = show(Field.blood) && p.bloodGroup != 'unknown';
    TextStyle label() => TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 1, color: ink.withValues(alpha: .6));
    TextStyle value([Color? c]) => TextStyle(fontWeight: FontWeight.w700, fontSize: 19, height: 1.25, color: c ?? ink);

    Widget row(String k, String v, {Color? c}) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(k.toUpperCase(), style: label()),
            const SizedBox(height: 2),
            Text(v, style: value(c), maxLines: 3, overflow: TextOverflow.ellipsis),
          ]),
        );

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .18), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Icon(Icons.emergency_rounded, color: red, size: 18),
          const SizedBox(width: 6),
          Text(l.outIce, style: TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 13, color: red, letterSpacing: .3)),
        ]),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: show(Field.name)
                ? Text(p.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 26, height: 1.15, color: ink))
                : const SizedBox(),
          ),
          if (hasBlood) _BloodBadge(group: p.bloodGroup, label: l.outBlood, color: red, size: 66),
        ]),
        if (show(Field.allergies) && p.allergies.isNotEmpty) row(l.outAllergies, p.allergies.join(', '), c: red),
        if (show(Field.conditions) && p.conditions.isNotEmpty) row(l.outConditions, p.conditions.join(', ')),
        if (show(Field.meds) && p.realMeds.isNotEmpty) row(l.outMeds, p.realMeds.map((m) => m.label).join(', ')),
        for (final c in contacts)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: dark ? Colors.white.withValues(alpha: .06) : vibe(p.vibe),
            ),
            child: Row(children: [
              Icon(Icons.call_rounded, color: ink, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${l.outCall} ${c.who}',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: ink)),
                  Text(c.phone, style: TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 19, color: ink)),
                ]),
              ),
            ]),
          ),
        if (show(Field.doctor) && p.hasDoctor) row(l.outDoctor, '${p.doctorName} ${p.doctorPhone}'.trim()),
        if (show(Field.donor) && p.organDonor == true) row(l.outDonor, l.yes),
        if (show(Field.notes) && p.notes.trim().isNotEmpty) row(l.outNotes, p.notes.trim()),
        const SizedBox(height: 14),
        Row(children: [
          if (show(Field.sos))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(999)),
              child: Text('${l.outSos} $sos', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: surface)),
            ),
          const Spacer(),
          Text('${l.outUpdated} ${ymd(p.updatedAt)}', style: TextStyle(fontSize: 11, color: ink.withValues(alpha: .55))),
        ]),
      ]),
    );
  }
}

class _BloodBadge extends StatelessWidget {
  const _BloodBadge({required this.group, required this.label, required this.color, required this.size});
  final String group, label;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size * .3)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(group,
              style: TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: size * .32, color: Colors.white, height: 1)),
          SizedBox(height: size * .05),
          Text(label.toUpperCase(),
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: size * .13, color: Colors.white, letterSpacing: .5)),
        ]),
      );
}

/// Faint concentric rings: texture without noise.
class _Rings extends CustomPainter {
  _Rings(this.line);
  final Color line;
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * .008;
    for (final r in [.3, .45, .6]) {
      canvas.drawCircle(Offset(w * .95, size.height * .92), w * r, stroke);
    }
    canvas.drawCircle(Offset(w * .05, size.height * .06), w * .3, stroke);
    canvas.drawCircle(Offset(w * .05, size.height * .06), w * .2, stroke);
  }

  @override
  bool shouldRepaint(_Rings old) => old.line != line;
}

/// Shrinks [child] (laid out at [width]) to fit, instead of overflowing.
class _Fit extends StatelessWidget {
  const _Fit({required this.width, required this.child});
  final double width;
  final Widget child;
  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      );
}

class CardFront extends StatelessWidget {
  const CardFront({super.key, required this.p, required this.sos});
  final Profile p;
  final String sos;

  bool show(Field f) => p.shows(Output.card, f);

  @override
  Widget build(BuildContext context) {
    final l = outL10n(p);
    final c = show(Field.contacts) ? p.realContacts.firstOrNull : null;
    final hasBlood = show(Field.blood) && p.bloodGroup != 'unknown';
    return _CardShell(
      color: vibe(p.vibe),
      header: l.outIce,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: _Fit(
                width: hasBlood ? 240 : 300,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  if (show(Field.name))
                    Text(p.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 18, height: 1.15, color: C.ink)),
                  if (show(Field.allergies) && p.allergies.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _kv(l.outAllergies, p.allergies.join(', '), C.red),
                  ],
                  if (show(Field.conditions) && p.conditions.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _kv(l.outConditions, p.conditions.join(', '), C.ink),
                  ],
                ]),
              ),
            ),
            if (hasBlood) ...[
              const SizedBox(width: 8),
              _BloodBadge(group: p.bloodGroup, label: l.outBlood, color: C.red, size: 56),
            ],
          ]),
        ),
        if (c != null)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: vibe(p.vibe), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.call_rounded, size: 15, color: C.ink),
              const SizedBox(width: 6),
              Expanded(
                child: Text('${l.outCall} ${c.who}',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: C.ink)),
              ),
              Text(c.phone, style: const TextStyle(fontFamily: display, fontSize: 12, fontWeight: FontWeight.w700, color: C.ink)),
            ]),
          ),
        const SizedBox(height: 5),
        Row(children: [
          if (show(Field.sos))
            Text('${l.outSos} $sos', style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: C.ink)),
          const Spacer(),
          Text('${l.outUpdated} ${ymd(p.updatedAt)}', style: const TextStyle(fontSize: 8, color: Color(0xFF6B6B72))),
        ]),
      ]),
    );
  }
}

Widget _kv(String k, String v, Color c) => Text.rich(
      TextSpan(children: [
        TextSpan(text: '${k.toUpperCase()}  ', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .6, color: Color(0xFF6B6B72))),
        TextSpan(text: v, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c, height: 1.25)),
      ]),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );

class CardBack extends StatelessWidget {
  const CardBack({super.key, required this.p, required this.sos});
  final Profile p;
  final String sos;

  bool show(Field f) => p.shows(Output.card, f);

  @override
  Widget build(BuildContext context) {
    final l = outL10n(p);
    final more = show(Field.contacts) ? p.realContacts.skip(1).toList() : <Contact>[];
    return _CardShell(
      color: vibe(p.vibe),
      header: l.outMoreInfo,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: _Fit(
            width: 200,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              if (show(Field.meds) && p.realMeds.isNotEmpty) _kv(l.outMeds, p.realMeds.map((m) => m.label).join(', '), C.ink),
              for (final c in more) ...[const SizedBox(height: 4), _kv(l.outCall, '${c.who} ${c.phone}', C.ink)],
              if (show(Field.doctor) && p.hasDoctor) ...[
                const SizedBox(height: 4),
                _kv(l.outDoctor, '${p.doctorName} ${p.doctorPhone}'.trim(), C.ink),
              ],
              if (show(Field.donor) && p.organDonor == true) ...[const SizedBox(height: 4), _kv(l.outDonor, l.yes, C.ink)],
              if (show(Field.notes) && p.notes.trim().isNotEmpty) ...[const SizedBox(height: 4), _kv(l.outNotes, p.notes.trim(), C.ink)],
              const SizedBox(height: 6),
              Text(l.outDisclaimer, style: const TextStyle(fontSize: 7, color: Color(0xFF6B6B72), height: 1.3)),
            ]),
          ),
        ),
        const SizedBox(width: 8),
        Column(children: [
          QrArt(data: qrData(p, sos: sos), size: 112),
          const SizedBox(height: 4),
          Text(l.outScan.toUpperCase(), style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700, letterSpacing: .5, color: C.ink)),
        ]),
      ]),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.color, required this.header, required this.child});
  final Color color;
  final String header;
  final Widget child;
  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: cardSize,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: C.white,
            border: Border.all(color: const Color(0xFFDAD6CC), width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              height: 24,
              color: color,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                const Icon(Icons.emergency_rounded, size: 13, color: C.red),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(header,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 8.5, color: C.ink, letterSpacing: .4)),
                ),
                const Text('clutch', style: TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 8.5, color: C.ink)),
              ]),
            ),
            Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 6), child: child)),
          ]),
        ),
      );
}

/// QR with medium error correction (F6): dense enough for 300 chars, still easy to scan.
class QrArt extends StatelessWidget {
  const QrArt({super.key, required this.data, required this.size});
  final String data;
  final double size;
  @override
  Widget build(BuildContext context) => QrImageView(
        data: data,
        size: size,
        padding: EdgeInsets.zero,
        backgroundColor: C.white,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
        eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: C.ink),
        dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: C.ink),
        semanticsLabel: data,
      );
}
