import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/effects.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _pass = TextEditingController();
  bool _lockSupported = false;
  bool _busy = false;

  void _changed() => setState(() {});

  @override
  void initState() {
    super.initState();
    store.addListener(_changed);
    Lock.supported().then((v) => mounted ? setState(() => _lockSupported = v) : null);
  }

  @override
  void dispose() {
    store.removeListener(_changed);
    _pass.dispose();
    super.dispose();
  }

  Future<void> _export() async {
    if (_busy || !await Lock.check(store, context.l.unlockReason)) return;
    setState(() => _busy = true);
    try {
      final json = await store.backup(passphrase: _pass.text);
      await SharePlus.instance.share(ShareParams(
        files: [XFile.fromData(utf8.encode(json), mimeType: 'application/json', name: 'clutch-backup.json')],
        fileNameOverrides: ['clutch-backup.json'],
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final l = context.l;
    if (_busy) return;
    final file = await Native.openTextFile();
    if (file == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final n = await store.restore(file, passphrase: _pass.text);
      if (mounted) toast(context, l.importDone(n));
    } on NeedsPassphrase {
      if (mounted) toast(context, l.needPass, bad: true);
    } on WrongPassphrase {
      if (mounted) toast(context, l.wrongPass, bad: true);
    } catch (e) {
      debugPrint('clutch: import failed: $e');
      if (mounted) toast(context, l.importFail, bad: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final langs = [(null, l.system), ('en', 'English'), ('hi', 'हिन्दी'), ('hi_Latn', 'Hinglish'), ('te', 'తెలుగు')];
    final themes = [('system', l.system), ('light', l.themeLight), ('dark', l.themeDark)];

    Widget section(String title, Color color, List<Widget> children) => Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Neo(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: context.edge, width: 1.2))),
                const SizedBox(width: 10),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ]),
              const SizedBox(height: 16),
              ...children,
            ]),
          ),
        );

    Widget toggle(String title, String sub, bool value, ValueChanged<bool>? onChanged) => Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 2),
              Text(sub, style: TextStyle(color: context.line.withValues(alpha: .7), fontSize: 13)),
            ]),
          ),
          const SizedBox(width: 12),
          NeoSwitch(value: value, onChanged: onChanged, label: title),
        ]);

    return Scaffold(
      body: DotGrid(
        child: SafeArea(
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 32), children: [
            Row(children: [
              NeoIconButton(
                  icon: Icons.arrow_back_rounded,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => Navigator.of(context).maybePop()),
              const SizedBox(width: 14),
              Text(l.settings, style: Theme.of(context).textTheme.headlineSmall),
            ]),
            const SizedBox(height: 24),
            section(l.sLanguage, C.sky, [
              Wrap(spacing: 8, runSpacing: 10, children: [
                for (final (code, name) in langs)
                  NeoChip(
                    label: name,
                    selected: store.localeCode == code,
                    color: C.sky,
                    onTap: () {
                      store.localeCode = code;
                      store.save();
                    },
                  ),
              ]),
            ]),
            section(l.sTheme, C.lavender, [
              Wrap(spacing: 8, runSpacing: 10, children: [
                for (final (code, name) in themes)
                  NeoChip(
                    label: name,
                    selected: store.themeMode == code,
                    color: C.lavender,
                    onTap: () {
                      store.themeMode = code;
                      store.save();
                    },
                  ),
              ]),
            ]),
            section(l.sSos, C.redDark, [
              TextFormField(
                initialValue: store.sosOverride,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: store.defaultSos, prefixIcon: const Icon(Icons.emergency_rounded)),
                onChanged: (v) => store.sosOverride = v,
                onFieldSubmitted: (_) => store.save(),
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                  store.save();
                },
              ),
              const SizedBox(height: 8),
              Text(l.sSosSub(store.defaultSos), style: TextStyle(color: context.line.withValues(alpha: .7), fontSize: 13)),
            ]),
            section(l.sReminder, C.butter, [
              toggle(l.sReminder, l.sReminderSub, store.reminders, (v) async {
                store.reminders = v;
                if (v) await Effects.askNotificationPermission();
                await store.save();
              }),
              const SizedBox(height: 18),
              toggle(l.sLock, _lockSupported ? l.sLockSub : l.sLockUnavailable, store.lock, !_lockSupported
                  ? null
                  : (v) async {
                      // Turning the lock on or off itself needs an unlock.
                      final was = store.lock;
                      store.lock = true;
                      final ok = await Lock.check(store, l.unlockReason);
                      store.lock = ok ? v : was;
                      await store.save();
                    }),
            ]),
            section(l.sBackup, C.mint, [
              TextField(
                controller: _pass,
                obscureText: true,
                decoration: InputDecoration(labelText: l.passphrase, hintText: l.passphraseHint, prefixIcon: const Icon(Icons.key_rounded)),
              ),
              const SizedBox(height: 10),
              Text(l.backupWarn, style: TextStyle(color: context.line.withValues(alpha: .7), fontSize: 13)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: NeoButton(label: l.exportBackup, small: true, color: C.mint, icon: Icons.upload_rounded, onPressed: _busy ? null : _export)),
                if (isAndroid) ...[
                  const SizedBox(width: 12),
                  Expanded(child: NeoButton(label: l.importBackup, small: true, color: C.white, icon: Icons.download_rounded, onPressed: _busy ? null : _import)),
                ],
              ]),
            ]),
            section(l.sAbout, C.rose, [
              Text(l.privacyLine, style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4)),
              const SizedBox(height: 10),
              Text(l.disclaimer, style: TextStyle(color: context.line.withValues(alpha: .75), height: 1.4)),
              const SizedBox(height: 16),
              NeoButton(
                label: l.licences,
                small: true,
                color: C.white,
                icon: Icons.description_outlined,
                onPressed: () => showLicensePage(context: context, applicationName: 'Clutch', applicationVersion: '1.0.0'),
              ),
            ]),
            Center(child: Text('clutch ✦ v1.0.0 · MIT', style: TextStyle(color: context.line.withValues(alpha: .5), fontWeight: FontWeight.w700))),
          ]),
        ),
      ),
    );
  }
}
