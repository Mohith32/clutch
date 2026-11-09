// Renders the Clutch app icon with dart:ui so it stays sharp at every size.
// Run: flutter test tool/icon_gen_test.dart  -> writes assets/icon/*.png
// Style: flat sticker, chunky ink outlines, tilted stacked cards (the app's own
// emergency card), one red plus badge.
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const bg = Color(0xFF1C1C21);
const ink = Color(0xFF141416);
const lime = Color(0xFFCFDCC8); // sage
const pink = Color(0xFFEDD3D8); // rose
const red = Color(0xFFC8413B);
const white = Color(0xFFFFFFFF);

/// [s] canvas size, [k] mark scale (smaller for Android's adaptive safe zone),
/// [mono] draws a single-colour silhouette for Android 13 themed icons.
void paintMark(Canvas c, double s, {double k = 1, Color? mono}) {
  final u = s / 1024 * k; // design units on a 1024 grid
  c.save();
  c.translate(s / 2, s / 2);

  void card(Offset at, double angle, Color fill, {bool front = false}) {
    c.save();
    c.translate(at.dx * u, at.dy * u);
    c.rotate(angle);
    final r = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 600 * u, height: 420 * u), Radius.circular(78 * u));
    final outline = Paint()
      ..color = mono == null ? (front ? ink : ink) : bg
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30 * u;
    c.drawRRect(r, Paint()..color = mono ?? fill);
    c.drawRRect(r.deflate(15 * u), outline);
    if (front) {
      // red plus badge
      final b = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(-150 * u, -60 * u), width: 170 * u, height: 170 * u), Radius.circular(48 * u));
      c.drawRRect(b, Paint()..color = mono == null ? red : bg);
      if (mono == null) c.drawRRect(b, outline..strokeWidth = 22 * u);
      final p = Paint()..color = mono ?? white;
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(-150 * u, -60 * u), width: 96 * u, height: 30 * u), Radius.circular(15 * u)), p);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(-150 * u, -60 * u), width: 30 * u, height: 96 * u), Radius.circular(15 * u)), p);
      // "text" lines
      final line = Paint()..color = mono == null ? ink : bg;
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-5 * u, -110 * u, 190 * u, 40 * u), Radius.circular(20 * u)), line);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-5 * u, -40 * u, 130 * u, 40 * u), Radius.circular(20 * u)), line);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-235 * u, 70 * u, 420 * u, 40 * u), Radius.circular(20 * u)), line);
    }
    c.restore();
  }

  card(const Offset(40, -60), 12 * pi / 180, pink);
  card(const Offset(-20, 70), -9 * pi / 180, lime, front: true);
  c.restore();
}

Future<void> save(String path, double s, void Function(Canvas) draw) async {
  final rec = ui.PictureRecorder();
  draw(Canvas(rec));
  final img = await rec.endRecording().toImage(s.toInt(), s.toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  test('generate icons', () async {
    const s = 1024.0;
    final full = Offset.zero & const Size(s, s);
    await save('assets/icon/icon.png', s, (c) {
      c.drawRect(full, Paint()..color = bg);
      paintMark(c, s, k: .92);
    });
    // Android adaptive layers: keep the mark inside the 66/108 safe circle.
    await save('assets/icon/foreground.png', s, (c) => paintMark(c, s, k: .66));
    await save('assets/icon/monochrome.png', s, (c) => paintMark(c, s, k: .66, mono: white));
    // Rounded preview, as a launcher would show it.
    await save('assets/icon/preview.png', 512, (c) {
      c.scale(.5);
      c.clipRRect(RRect.fromRectAndRadius(full, const Radius.circular(s * .3)));
      c.drawRect(full, Paint()..color = bg);
      paintMark(c, s, k: .92);
    });
  });
}
