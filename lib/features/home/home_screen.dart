import 'package:flutter/material.dart';

import '../../core/effects.dart';
import '../../core/theme.dart';
import '../../domain/profile.dart';
import '../../main.dart';
import '../output_studio/outputs.dart';
import '../output_studio/studio_screen.dart';
import '../profile_editor/editor_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _pc = PageController(viewportFraction: .86, initialPage: store.current);

  void _changed() => setState(() {});

  @override
  void initState() {
    super.initState();
    store.addListener(_changed);
  }

  @override
  void dispose() {
    store.removeListener(_changed);
    _pc.dispose();
    super.dispose();
  }

  void _go(int i) {
    if (_pc.hasClients) _pc.animateToPage(i, duration: context.ms(300), curve: Curves.easeOut);
  }

  Future<void> _edit(Profile p, {bool isNew = false}) async {
    if (!await Lock.check(store, context.l.unlockReason) || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditorScreen(profile: p.copy(), isNew: isNew)));
    if (mounted) _go(store.current);
  }

  void _studio(Profile p) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudioScreen(profileId: p.id)));

  Future<void> _delete(Profile p) async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.delete),
        content: Text(l.deleteConfirm(p.displayName)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel, style: TextStyle(color: c.line))),
          NeoButton(label: l.delete, color: C.redDark, expand: false, small: true, onPressed: () => Navigator.pop(c, true)),
        ],
      ),
    );
    if (ok == true && await Lock.check(store, l.unlockReason)) await store.delete(p);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final ps = store.profiles;
    final stale = ps.where((p) => p.isStale).firstOrNull;
    return Scaffold(
      body: DotGrid(
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(children: [
                Text('clutch', style: Theme.of(context).textTheme.displaySmall),
                Padding(padding: const EdgeInsets.only(left: 4, bottom: 18), child: Text('✦', style: TextStyle(fontSize: 20, color: context.emergency))),
                const Spacer(),
                NeoIconButton(
                  icon: Icons.tune_rounded,
                  tooltip: l.settings,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(l.tagline, style: TextStyle(color: context.line.withValues(alpha: .7), fontWeight: FontWeight.w500)),
            ),
            if (stale != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: GestureDetector(
                  onTap: () => _edit(stale),
                  child: Neo(
                    color: C.butter,
                    radius: 14,
                    shadow: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(children: [
                      const Icon(Icons.alarm_rounded, color: C.ink),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(l.staleBanner(stale.displayName),
                              style: const TextStyle(color: C.ink, fontWeight: FontWeight.w700))),
                      const Icon(Icons.chevron_right_rounded, color: C.ink),
                    ]),
                  ),
                ),
              ),
            Expanded(child: ps.isEmpty ? _empty(context) : _carousel(context, ps)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: NeoButton(
                label: l.newCard,
                icon: Icons.add_rounded,
                color: ps.isEmpty ? C.sage : C.white,
                onPressed: () => _edit(Profile(vibe: ps.length), isNew: true),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final l = context.l;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(clipBehavior: Clip.none, children: [
          Neo(
            color: C.rose,
            radius: 28,
            shadow: 8,
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.badge_rounded, size: 48, color: C.ink),
              const SizedBox(height: 16),
              Text(l.homeEmptyTitle,
                  style: const TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 28, color: C.ink, height: 1.1)),
              const SizedBox(height: 10),
              Text(l.homeEmptyBody, style: const TextStyle(fontSize: 16, color: C.ink, height: 1.4)),
            ]),
          ),
          const Positioned(right: -6, top: -14, child: Sticker('~3 min', color: C.sage, angle: .1)),
        ]),
      ),
    );
  }

  Widget _carousel(BuildContext context, List<Profile> ps) {
    final l = context.l;
    final cur = store.selected!;
    return Column(children: [
      const SizedBox(height: 16),
      // Family switcher (F10).
      SizedBox(
        height: 56,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          itemCount: ps.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, i) {
            final on = i == store.current;
            return Semantics(
              button: true,
              selected: on,
              label: ps[i].displayName,
              child: GestureDetector(
                onTap: () => _go(i),
                child: AnimatedContainer(
                  duration: context.ms(160),
                  padding: EdgeInsets.only(left: 4, right: on ? 14 : 4),
                  decoration: BoxDecoration(
                    color: on ? vibe(ps[i].vibe) : context.card,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: context.edge, width: 1.2),
                    boxShadow: null,
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: vibe(ps[i].vibe),
                      child: Text(ps[i].initials,
                          style: const TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 12, color: C.ink)),
                    ),
                    if (on) ...[
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 140),
                        child: Text(ps[i].displayName.split(' ').first,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: C.ink)),
                      ),
                    ],
                  ]),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: PageView.builder(
          controller: _pc,
          itemCount: ps.length,
          onPageChanged: store.select,
          itemBuilder: (context, i) => AnimatedBuilder(
            animation: _pc,
            builder: (context, child) {
              final page = _pc.position.haveDimensions ? _pc.page! : store.current.toDouble();
              final d = (i - page).clamp(-1.0, 1.0);
              return Transform.rotate(angle: context.calm ? 0 : d * .08, child: Transform.scale(scale: 1 - d.abs() * .08, child: child));
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 14, 14),
                child: GestureDetector(
                  onTap: () => _studio(ps[i]),
                  child: Semantics(
                    button: true,
                    label: '${ps[i].displayName}. ${l.makeOutputs}',
                    child: ExcludeSemantics(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: soft(context),
                        ),
                        child: AspectRatio(
                          aspectRatio: cardSize.aspectRatio,
                          child: FittedBox(
                            child: SizedBox.fromSize(size: cardSize, child: CardFront(p: ps[i], sos: store.sos)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        child: Column(children: [
          Text(l.updatedOn(ymd(cur.updatedAt)),
              style: TextStyle(color: context.line.withValues(alpha: .65), fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: NeoButton(label: l.makeOutputs, icon: Icons.auto_awesome_rounded, color: vibe(cur.vibe), onPressed: () => _studio(cur)),
            ),
            const SizedBox(width: 10),
            NeoIconButton(icon: Icons.edit_rounded, tooltip: l.edit, onPressed: () => _edit(cur)),
            const SizedBox(width: 10),
            NeoIconButton(
              icon: Icons.copy_all_rounded,
              tooltip: l.duplicate,
              onPressed: () async {
                await store.duplicate(cur);
                _go(store.current);
              },
            ),
            const SizedBox(width: 10),
            NeoIconButton(icon: Icons.delete_outline_rounded, tooltip: l.delete, onPressed: () => _delete(cur)),
          ]),
        ]),
      ),
    ]);
  }
}
