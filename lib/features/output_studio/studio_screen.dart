import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/effects.dart';
import '../../core/theme.dart';
import '../../domain/profile.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import 'outputs.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key, required this.profileId});
  final String profileId;
  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  int _tab = 0;
  bool _busy = false;
  bool _nfc = false;

  Profile? get p => store.profiles.where((x) => x.id == widget.profileId).firstOrNull;

  void _changed() => setState(() {});

  @override
  void initState() {
    super.initState();
    store.addListener(_changed);
    Native.nfcAvailable().then((v) => mounted ? setState(() => _nfc = v) : null).catchError((_) {});
  }

  @override
  void dispose() {
    store.removeListener(_changed);
    super.dispose();
  }

  /// Every export goes through here: edit lock (F13), busy state, friendly errors.
  Future<void> _run(Future<void> Function() job) async {
    final l = context.l;
    if (_busy || !await Lock.check(store, l.unlockReason)) return;
    setState(() => _busy = true);
    try {
      await job();
    } catch (e) {
      debugPrint('clutch: export failed: $e');
      if (mounted) toast(context, l.somethingWrong, bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share(List<(Uint8List, String, String)> files) => SharePlus.instance.share(ShareParams(
        files: [for (final f in files) XFile.fromData(f.$1, mimeType: f.$3, name: f.$2)],
        fileNameOverrides: [for (final f in files) f.$2],
      ));

  Future<Uint8List> _wallpaperPng(Profile p) async {
    final size = MediaQuery.sizeOf(context);
    final ratio = MediaQuery.devicePixelRatioOf(context);
    // Decode the photo first, or the off-screen capture paints before it loads.
    final photo = wallpaperPhoto(p);
    if (photo != null) await precacheImage(FileImage(photo), context);
    if (!mounted) throw StateError('studio closed');
    return capture(context, WallpaperArt(p: p, sos: store.sos), size, ratio);
  }

  Future<void> _applyWallpaper(Profile p) => _run(() async {
        final l = context.l;
        final png = await _wallpaperPng(p);
        if (isAndroid) {
          await Native.setLockWallpaper(png);
          if (mounted) toast(context, l.wpDone);
        } else {
          await Gal.putImageBytes(png, name: 'clutch-wallpaper');
          if (mounted) _iosSteps(l);
        }
      });

  void _iosSteps(AppLocalizations l) => showModalBottomSheet<void>(
        context: context,
        builder: (c) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(l.savedToPhotos, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(l.iosStepsTitle, style: Theme.of(c).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(l.iosSteps, style: const TextStyle(fontSize: 16, height: 1.7)),
              const SizedBox(height: 20),
              NeoButton(label: l.done, onPressed: () => Navigator.pop(c)),
            ]),
          ),
        ),
      );

  Future<(Uint8List, Uint8List)> _cardPngs(Profile p) async {
    final front = await capture(context, CardFront(p: p, sos: store.sos), cardSize, cardPixelRatio);
    if (!mounted) throw StateError('studio closed');
    return (front, await capture(context, CardBack(p: p, sos: store.sos), cardSize, cardPixelRatio));
  }

  /// A4 sheet (F5): front and back side by side so each pair folds down the
  /// middle; five pairs per page; thin cut lines.
  Future<void> _pdf(List<Profile> ps) => _run(() async {
        final cards = [for (final p in ps) await _cardPngs(p)];
        const mm = PdfPageFormat.mm;
        const w = 85.6 * mm, h = 53.98 * mm;
        final doc = pw.Document(title: 'Clutch cards', creator: 'Clutch');
        for (var i = 0; i < cards.length; i += 5) {
          doc.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.symmetric(horizontal: 12 * mm, vertical: 8 * mm),
            build: (_) => pw.Column(children: [
              for (final (front, back) in cards.skip(i).take(5))
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 2 * mm),
                  child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                    for (final img in [front, back])
                      pw.Container(
                        width: w,
                        height: h,
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: .4)),
                        child: pw.Image(pw.MemoryImage(img), width: w, height: h, fit: pw.BoxFit.fill),
                      ),
                  ]),
                ),
            ]),
          ));
        }
        final bytes = await doc.save();
        await Printing.layoutPdf(onLayout: (_) async => bytes, name: 'clutch-cards.pdf');
      });

  void _pdfChooser(Profile p) {
    final l = context.l;
    if (store.profiles.length < 2) {
      _pdf([p]);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l.exportPdf, style: Theme.of(c).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(l.pdfHint),
            const SizedBox(height: 20),
            NeoButton(
                label: l.thisCard,
                icon: Icons.person_rounded,
                color: vibe(p.vibe),
                onPressed: () {
                  Navigator.pop(c);
                  _pdf([p]);
                }),
            const SizedBox(height: 14),
            NeoButton(
                label: l.wholeFam(store.profiles.length),
                icon: Icons.groups_rounded,
                color: C.butter,
                onPressed: () {
                  Navigator.pop(c);
                  _pdf(List.of(store.profiles));
                }),
          ]),
        ),
      ),
    );
  }

  Future<void> _writeNfc(Profile p) async {
    final l = context.l;
    if (!await Lock.check(store, l.unlockReason) || !mounted) return;
    var open = true;
    final sheet = showModalBottomSheet<void>(
      context: context,
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Icon(Icons.nfc_rounded, size: 56),
            const SizedBox(height: 12),
            Text(l.nfcHold, textAlign: TextAlign.center, style: Theme.of(c).textTheme.titleMedium),
            const SizedBox(height: 20),
            NeoButton(label: l.cancel, color: C.white, onPressed: () => Navigator.pop(c)),
          ]),
        ),
      ),
    );
    sheet.whenComplete(() {
      if (open) Native.nfcCancel();
      open = false;
    });
    try {
      await Native.nfcWrite(qrPayload(p, sos: store.sos));
      if (!mounted) return;
      toast(context, l.nfcDone);
    } on PlatformException catch (e) {
      if (e.code != 'cancelled' && mounted) toast(context, l.nfcFail(e.message ?? e.code), bad: true);
    } finally {
      if (open && mounted) {
        open = false;
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = this.p;
    if (p == null) return const Scaffold(); // deleted underneath us
    final l = context.l;
    final tabs = [l.tabWallpaper, l.tabCard, l.tabQr];
    return Scaffold(
      body: DotGrid(
        child: SafeArea(
          child: Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(children: [
                  NeoIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                      onPressed: () => Navigator.of(context).maybePop()),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(p.displayName,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Neo(
                  radius: 16,
                  shadow: 3,
                  padding: const EdgeInsets.all(4),
                  child: Row(children: [
                    for (var i = 0; i < tabs.length; i++)
                      Expanded(
                        child: Semantics(
                          button: true,
                          selected: _tab == i,
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _tab = i);
                            },
                            child: AnimatedContainer(
                              duration: context.ms(160),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _tab == i ? [C.sage, C.rose, C.sky][i] : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: null,
                              ),
                              child: Text(tabs[i],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: display,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: _tab == i ? C.ink : context.line)),
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
              Expanded(
                child: ListView(
                  key: ValueKey(_tab), // each tab starts at the top
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: switch (_tab) {
                    0 => _wallpaperTab(context, p),
                    1 => _cardTab(context, p),
                    _ => _qrTab(context, p),
                  },
                ),
              ),
            ]),
            if (_busy)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Neo(
                      color: C.sage,
                      padding: const EdgeInsets.all(20),
                      child: const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 4, color: C.ink)),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _visibility(BuildContext context, Profile p, Output o) {
    final l = context.l;
    final labels = {
      Field.name: l.vName,
      Field.blood: l.vBlood,
      Field.allergies: l.vAllergies,
      Field.conditions: l.vConditions,
      Field.meds: l.vMeds,
      Field.contacts: l.vContacts,
      Field.doctor: l.vDoctor,
      Field.donor: l.vDonor,
      Field.notes: l.vNotes,
      Field.sos: l.vSos,
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionLabel(l.whatShows),
      Wrap(spacing: 8, runSpacing: 10, children: [
        for (final f in Field.values)
          NeoChip(
            label: labels[f]!,
            selected: p.shows(o, f),
            color: [C.sage, C.rose, C.sky][o.index],
            onTap: () {
              final set = p.visibility[o]!;
              set.contains(f) ? set.remove(f) : set.add(f);
              store.upsert(p, touch: false);
            },
          ),
      ]),
    ]);
  }

  Future<void> _pickPhoto(Profile p) async {
    final path = await Native.pickImage();
    if (path == null) return;
    p.wpPhoto = path;
    await store.upsert(p, touch: false);
  }

  Future<void> _addWidget() async {
    final l = context.l;
    if (!await Native.pinWidget() && mounted) toast(context, l.widgetManual);
  }

  Future<void> _toggleNowBar(bool on) async {
    final l = context.l;
    if (on) await Effects.askNotificationPermission();
    store.nowBar = on;
    await store.save();
    if (!on) return;
    // save() re-posts the pill; check the system actually allows promotion.
    final allowed = await Native.nowBar(on: true, title: l.passTitle, body: l.passBody, chip: l.passChip, channel: l.passChannel);
    if (!mounted) return;
    if (allowed) {
      toast(context, l.nowBarOn);
    } else {
      toast(context, l.nowBarBlocked, bad: true);
      await Native.openPromotionSettings();
    }
  }

  Future<void> _addTile() async {
    final l = context.l;
    if (await Native.addTile(l.tileLabel) == -1 && mounted) toast(context, l.tileManual);
  }

  List<Widget> _wallpaperTab(BuildContext context, Profile p) {
    final l = context.l;
    final screen = MediaQuery.sizeOf(context);
    final styles = [l.styleLight, l.styleDark, l.styleSage, l.styleRose, l.styleSky];
    final hasPhoto = wallpaperPhoto(p) != null;
    final details = p.wpLayout == wpDetails;
    void update(void Function() change) {
      change();
      store.upsert(p, touch: false);
    }

    return [
      Center(
        child: SizedBox(
          width: 240,
          child: AspectRatio(
            aspectRatio: screen.aspectRatio,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: context.dark ? const Color(0xFF3A3A41) : C.ink, width: 5),
                boxShadow: soft(context, 1.4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FittedBox(child: SizedBox.fromSize(size: screen, child: WallpaperArt(p: p, sos: store.sos, preview: true))),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 28),
      SectionLabel(l.wpLayout),
      Wrap(spacing: 8, runSpacing: 10, children: [
        NeoChip(label: l.layoutQr, selected: !details, onTap: () => update(() => p.wpLayout = wpQrOnly)),
        NeoChip(label: l.layoutDetails, selected: details, color: C.butter, onTap: () => update(() => p.wpLayout = wpDetails)),
      ]),
      const SizedBox(height: 12),
      details
          ? Neo(
              color: C.butter,
              radius: 16,
              shadow: 0,
              padding: const EdgeInsets.all(14),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.visibility_outlined, color: C.ink, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(l.wpWarning, style: const TextStyle(color: C.ink, fontWeight: FontWeight.w500, height: 1.4))),
              ]),
            )
          : Text(l.layoutQrHint, style: TextStyle(color: context.muted, height: 1.4)),
      const SizedBox(height: 24),
      SectionLabel(l.wpBackground),
      Wrap(spacing: 8, runSpacing: 10, children: [
        if (isAndroid) NeoChip(label: l.stylePhoto, selected: hasPhoto, color: C.lavender, onTap: () => _pickPhoto(p)),
        for (var i = 0; i < styles.length; i++)
          NeoChip(
            label: styles[i],
            selected: !hasPhoto && p.wpStyle == i,
            onTap: () => update(() {
              p.wpPhoto = null;
              p.wpStyle = i;
            }),
          ),
      ]),
      const SizedBox(height: 24),
      SectionLabel(l.wpOffset),
      Slider(
        value: p.wpOffset,
        label: l.wpOffset,
        onChanged: (v) => setState(() => p.wpOffset = v),
        onChangeEnd: (_) => store.upsert(p, touch: false),
      ),
      if (details) ...[const SizedBox(height: 12), _visibility(context, p, Output.wallpaper)],
      const SizedBox(height: 28),
      NeoButton(
        label: isAndroid ? l.setLock : l.saveToPhotos,
        icon: isAndroid ? Icons.wallpaper_rounded : Icons.download_rounded,
        onPressed: () => _applyWallpaper(p),
      ),
      const SizedBox(height: 12),
      NeoButton(
        label: l.sharePng,
        icon: Icons.ios_share_rounded,
        color: C.white,
        onPressed: () => _run(() async => _share([(await _wallpaperPng(p), 'clutch-wallpaper.png', 'image/png')])),
      ),
      if (isAndroid) ...[
        const SizedBox(height: 28),
        Neo(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: C.rose, shape: BoxShape.circle),
                child: const Icon(Icons.widgets_outlined, color: C.ink, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.widgetTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 3),
                  Text(l.widgetSub, style: TextStyle(color: context.muted, fontSize: 13, height: 1.4)),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            NeoButton(label: l.addWidget, icon: Icons.add_rounded, small: true, onPressed: _addWidget),
            const SizedBox(height: 10),
            Text(l.widgetLockHint, style: TextStyle(color: context.muted, fontSize: 13, height: 1.4)),
            const SizedBox(height: 16),
            Divider(color: context.edge, height: 1),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.nowBarTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(l.nowBarSub, style: TextStyle(color: context.muted, fontSize: 13, height: 1.4)),
                ]),
              ),
              const SizedBox(width: 12),
              NeoSwitch(value: store.nowBar, onChanged: _toggleNowBar, label: l.nowBarTitle),
            ]),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addTile,
                icon: Icon(Icons.grid_view_rounded, size: 18, color: context.line),
                label: Text(l.addTile, style: TextStyle(color: context.line, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ],
    ];
  }

  List<Widget> _cardTab(BuildContext context, Profile p) {
    final l = context.l;
    Widget card(Widget w, double angle) => Transform.rotate(
          angle: context.calm ? 0 : angle,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: soft(context),
            ),
            child: AspectRatio(aspectRatio: cardSize.aspectRatio, child: FittedBox(child: SizedBox.fromSize(size: cardSize, child: w))),
          ),
        );
    return [
      SectionLabel(l.front),
      card(CardFront(p: p, sos: store.sos), -.015),
      const SizedBox(height: 22),
      SectionLabel(l.backSide),
      card(CardBack(p: p, sos: store.sos), .015),
      const SizedBox(height: 14),
      Text('85.6 × 53.98 mm · ${l.pdfHint}', style: TextStyle(color: context.line.withValues(alpha: .7), fontSize: 13)),
      const SizedBox(height: 18),
      _visibility(context, p, Output.card),
      const SizedBox(height: 28),
      NeoButton(label: l.exportPdf, icon: Icons.print_rounded, color: C.rose, onPressed: () => _pdfChooser(p)),
      const SizedBox(height: 14),
      NeoButton(
        label: l.sharePng,
        icon: Icons.ios_share_rounded,
        color: C.white,
        onPressed: () => _run(() async {
          final (front, back) = await _cardPngs(p);
          await _share([(front, 'clutch-card-front.png', 'image/png'), (back, 'clutch-card-back.png', 'image/png')]);
        }),
      ),
    ];
  }

  List<Widget> _qrTab(BuildContext context, Profile p) {
    final l = context.l;
    final data = qrData(p, sos: store.sos);
    void mode(bool link) {
      p.qrLink = link;
      store.upsert(p, touch: false);
    }

    return [
      Center(
        child: Stack(clipBehavior: Clip.none, children: [
          Neo(
            color: C.white,
            radius: 24,
            shadow: 8,
            padding: const EdgeInsets.all(18),
            child: QrArt(data: data, size: 240),
          ),
          Positioned(right: -14, top: -16, child: Sticker(l.qrCount(data.length), color: C.sage, angle: .08)),
        ]),
      ),
      const SizedBox(height: 22),
      SectionLabel(l.qrOpensAs),
      Wrap(spacing: 8, runSpacing: 10, children: [
        NeoChip(label: l.qrModeLink, selected: p.qrLink, onTap: () => mode(true)),
        NeoChip(label: l.qrModeText, selected: !p.qrLink, color: C.butter, onTap: () => mode(false)),
      ]),
      const SizedBox(height: 10),
      Text(p.qrLink ? l.qrModeLinkHint : l.qrModeTextHint, style: TextStyle(color: context.muted, height: 1.4)),
      if (!p.qrLink) ...[
        const SizedBox(height: 14),
        Neo(
          radius: 14,
          shadow: 0,
          padding: const EdgeInsets.all(14),
          child: SelectableText(data, style: const TextStyle(fontSize: 13, height: 1.5)),
        ),
      ],
      const SizedBox(height: 18),
      _visibility(context, p, Output.qr),
      const SizedBox(height: 28),
      NeoButton(
        label: l.shareQr,
        icon: Icons.qr_code_2_rounded,
        color: C.sky,
        onPressed: () => _run(() async =>
            _share([(await capture(context, Center(child: QrBadge(p: p, sos: store.sos)), QrBadge.exportSize, 3), 'clutch-qr.png', 'image/png')])),
      ),
      if (_nfc) ...[
        const SizedBox(height: 14),
        NeoButton(label: l.writeNfc, icon: Icons.nfc_rounded, color: C.white, onPressed: () => _writeNfc(p)),
      ],
    ];
  }
}
