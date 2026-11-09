import 'dart:ui' show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

/// Design tokens. Calm and soft: warm neutrals, muted pastels, thin outlines,
/// soft shadows. Red is reserved for emergency accents.
class C {
  static const ink = Color(0xFF1C1C21);
  static const paper = Color(0xFFF5F3EE);
  static const white = Color(0xFFFFFFFF);
  static const sage = Color(0xFFCFDCC8);
  static const rose = Color(0xFFEDD3D8);
  static const sky = Color(0xFFD3E1EE);
  static const butter = Color(0xFFF1E7C3);
  static const peach = Color(0xFFF2D9C9);
  static const lavender = Color(0xFFDDD7EE);
  static const mint = Color(0xFFCDE5DC);
  static const red = Color(0xFFC8413B);
  static const redDark = Color(0xFFEE7B74);
  static const night = Color(0xFF141416);
  static const nightCard = Color(0xFF1F1F23);
  static const snow = Color(0xFFECEBE6);
}

/// Card colours. All take [C.ink] text well above WCAG AA.
const vibes = [C.sage, C.rose, C.sky, C.butter, C.peach, C.lavender, C.mint];
Color vibe(int i) => vibes[i % vibes.length];

const display = 'Unbounded';
const grotesk = 'Grotesk';

extension Ctx on BuildContext {
  bool get dark => Theme.of(this).brightness == Brightness.dark;

  /// Text and icon colour on the page background.
  Color get line => dark ? C.snow : C.ink;

  /// Hairline outline colour.
  Color get edge => dark ? const Color(0xFF3A3A41) : const Color(0xFFDAD6CC);
  Color get muted => line.withValues(alpha: .62);
  Color get bg => dark ? C.night : C.paper;
  Color get card => dark ? C.nightCard : C.white;
  Color get emergency => dark ? C.redDark : C.red;
  bool get calm => MediaQuery.of(this).disableAnimations;
  Duration ms(int n) => calm ? Duration.zero : Duration(milliseconds: n);
  AppLocalizations get l => AppLocalizations.of(this);
}

/// Soft, low shadow used instead of hard offsets.
List<BoxShadow> soft(BuildContext context, [double lift = 1]) => [
      BoxShadow(
        color: Colors.black.withValues(alpha: context.dark ? .35 : .07),
        blurRadius: 18 * lift,
        offset: Offset(0, 6 * lift),
      ),
    ];

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final ink = dark ? C.snow : C.ink;
  final bg = dark ? C.night : C.paper;
  final surf = dark ? C.nightCard : C.white;
  final edge = dark ? const Color(0xFF3A3A41) : const Color(0xFFDAD6CC);
  final red = dark ? C.redDark : C.red;
  final base = (dark ? Typography.material2021().white : Typography.material2021().black)
      .apply(fontFamily: grotesk, bodyColor: ink, displayColor: ink);
  TextStyle disp(double size, [double? h]) =>
      TextStyle(fontFamily: display, fontSize: size, fontWeight: FontWeight.w700, height: h, color: ink, letterSpacing: -0.6);
  final text = base.copyWith(
    displayLarge: disp(40, 1.08),
    displayMedium: disp(34, 1.1),
    displaySmall: disp(28, 36 / 28),
    headlineSmall: disp(22, 1.2),
    titleLarge: disp(18, 1.25),
    titleMedium: base.titleMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    bodyLarge: base.bodyLarge!.copyWith(fontSize: 16, height: 1.45),
    bodyMedium: base.bodyMedium!.copyWith(fontSize: 14, height: 1.45),
    labelSmall: base.labelSmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1, color: ink.withValues(alpha: .6)),
  );
  OutlineInputBorder border(Color c, double w) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c, width: w));
  return ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: ColorScheme(
      brightness: b,
      primary: ink,
      onPrimary: bg,
      secondary: C.sage,
      onSecondary: C.ink,
      error: red,
      onError: dark ? C.ink : C.white,
      surface: bg,
      onSurface: ink,
      surfaceContainer: surf,
      surfaceContainerHigh: surf,
      outline: edge,
    ),
    scaffoldBackgroundColor: bg,
    textTheme: text,
    textSelectionTheme: TextSelectionThemeData(cursorColor: ink, selectionColor: C.sage.withValues(alpha: .8)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surf,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(edge, 1.2),
      enabledBorder: border(edge, 1.2),
      focusedBorder: border(ink, 1.6),
      errorBorder: border(red, 1.2),
      focusedErrorBorder: border(red, 1.6),
      labelStyle: TextStyle(color: ink.withValues(alpha: .7), fontWeight: FontWeight.w500),
      floatingLabelStyle: TextStyle(color: ink, fontWeight: FontWeight.w700),
      hintStyle: TextStyle(color: ink.withValues(alpha: .45)),
      errorStyle: TextStyle(color: red, fontWeight: FontWeight.w600),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: ink,
      inactiveTrackColor: ink.withValues(alpha: .12),
      thumbColor: ink,
      overlayColor: ink.withValues(alpha: .08),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 0),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surf,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: text.titleLarge,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bg,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

/// A soft surface: hairline outline, rounded, gentle shadow.
class Neo extends StatelessWidget {
  const Neo({
    super.key,
    required this.child,
    this.color,
    this.radius = 22,
    this.shadow = 1,
    this.padding = const EdgeInsets.all(16),
    this.border = 1.2,
  });
  final Widget child;
  final Color? color;
  final double radius, shadow, border;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? context.card,
          borderRadius: BorderRadius.circular(radius),
          border: border == 0 || color != null ? null : Border.all(color: context.edge, width: border),
          boxShadow: shadow == 0 ? null : soft(context, shadow > 4 ? 1.4 : 1),
        ),
        child: child,
      );
}

/// Pill button. No colour = primary (ink); [C.white] = quiet secondary;
/// a pastel = tinted button with ink text.
class NeoButton extends StatefulWidget {
  const NeoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.expand = true,
    this.small = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool expand, small;

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final on = widget.onPressed != null;
    final primary = widget.color == null;
    final secondary = widget.color == C.white;
    final fill = primary ? context.line : (secondary ? context.card : widget.color!);
    final fg = primary ? context.bg : (secondary ? context.line : C.ink);
    return Semantics(
      button: true,
      enabled: on,
      child: GestureDetector(
        onTapDown: on ? (_) => setState(() => _down = true) : null,
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: on
            ? () {
                HapticFeedback.lightImpact();
                widget.onPressed!();
              }
            : null,
        child: AnimatedScale(
          scale: _down ? .97 : 1,
          duration: context.ms(110),
          child: AnimatedOpacity(
            opacity: on ? 1 : .45,
            duration: context.ms(150),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: widget.small
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 11)
                  : const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(999),
                border: secondary ? Border.all(color: context.edge, width: 1.2) : null,
              ),
              child: Row(
                mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: fg, size: widget.small ? 18 : 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: widget.small ? 14 : 16, color: fg, height: 1.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NeoIconButton extends StatelessWidget {
  const NeoIconButton({super.key, required this.icon, required this.tooltip, this.onPressed, this.color});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: Semantics(
          button: true,
          label: tooltip,
          child: GestureDetector(
            onTap: onPressed == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onPressed!();
                  },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color ?? context.card,
                shape: BoxShape.circle,
                border: color == null ? Border.all(color: context.edge, width: 1.2) : null,
              ),
              child: Icon(icon, color: color == null ? context.line : C.ink, size: 21),
            ),
          ),
        ),
      );
}

/// Soft toggle chip.
class NeoChip extends StatelessWidget {
  const NeoChip({super.key, required this.label, this.selected = false, this.onTap, this.onDelete, this.color});
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? C.ink : context.line;
    return Semantics(
      button: onTap != null,
      selected: selected,
      child: GestureDetector(
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap!();
              },
        child: AnimatedContainer(
          duration: context.ms(160),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 40),
          padding: EdgeInsets.only(left: 14, right: onDelete == null ? 14 : 6, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: selected ? (color ?? C.sage) : context.card,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? Colors.transparent : context.edge, width: 1.2),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (selected && onDelete == null) ...[Icon(Icons.check_rounded, size: 16, color: fg), const SizedBox(width: 4)],
            Flexible(
              child: Text(label,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: fg), overflow: TextOverflow.ellipsis),
            ),
            if (onDelete != null)
              Semantics(
                button: true,
                label: MaterialLocalizations.of(context).deleteButtonTooltip,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.close_rounded, size: 17, color: fg),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class NeoSwitch extends StatelessWidget {
  const NeoSwitch({super.key, required this.value, required this.onChanged, required this.label});
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
        toggled: value,
        label: label,
        enabled: onChanged != null,
        child: GestureDetector(
          onTap: onChanged == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onChanged!(!value);
                },
          child: AnimatedOpacity(
            opacity: onChanged == null ? .45 : 1,
            duration: context.ms(150),
            child: AnimatedContainer(
              duration: context.ms(180),
              width: 52,
              height: 32,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? context.line : context.edge,
                borderRadius: BorderRadius.circular(999),
              ),
              child: AnimatedAlign(
                duration: context.ms(180),
                curve: Curves.easeOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(color: value ? context.bg : C.white, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ),
      );
}

/// Small, slightly tilted label.
class Sticker extends StatelessWidget {
  const Sticker(this.text, {super.key, this.color = C.butter, this.angle = -0.04});
  final String text;
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: C.ink)),
        ),
      );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
      );
}

/// Page background. Kept as a hook for texture; plain for now to stay calm.
class DotGrid extends StatelessWidget {
  const DotGrid({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}

void toast(BuildContext context, String msg, {bool bad = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      padding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: bad ? C.redDark : C.ink,
          borderRadius: BorderRadius.circular(16),
          boxShadow: soft(context),
        ),
        child: Text(msg, style: TextStyle(color: bad ? C.ink : C.white, fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    ));
  SemanticsService.sendAnnouncement(View.of(context), msg, Directionality.of(context));
}

/// Renders [child] off-screen at [size] logical pixels and returns a PNG at
/// [pixelRatio]. Used for every export so outputs never depend on preview size.
/// Pass [overlay] when calling from outside the widget tree.
Future<Uint8List> capture(BuildContext context, Widget child, Size size, double pixelRatio, {OverlayState? overlay}) async {
  final key = GlobalKey();
  final media = MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling, size: size);
  final entry = OverlayEntry(
    builder: (_) => Positioned(
      left: -size.width - 200,
      top: 0,
      width: size.width,
      height: size.height,
      child: MediaQuery(
        data: media,
        // Overlay entries have no Material ancestor: without this, exported text
        // falls back to the debug style (yellow underlines, wrong font).
        child: Material(
          type: MaterialType.transparency,
          child: DefaultTextStyle(
            style: const TextStyle(fontFamily: grotesk, color: C.ink, decoration: TextDecoration.none),
            child: RepaintBoundary(key: key, child: child),
          ),
        ),
      ),
    ),
  );
  (overlay ?? Overlay.of(context, rootOverlay: true)).insert(entry);
  try {
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final img = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await img.toByteData(format: ImageByteFormat.png);
    img.dispose();
    return data!.buffer.asUint8List();
  } finally {
    entry.remove();
  }
}
