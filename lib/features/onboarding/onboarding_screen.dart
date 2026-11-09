import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../domain/profile.dart';
import '../../main.dart';
import '../output_studio/outputs.dart';
import '../profile_editor/editor_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  int _page = 0;

  Future<void> _start() async {
    store.onboarded = true;
    await store.save();
    if (!mounted) return;
    // Home is now the root (store.onboarded flipped); stack the editor on top.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navKey.currentState?.push(MaterialPageRoute(builder: (_) => EditorScreen(profile: Profile(), isNew: true)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final pages = [
      (C.sage, Icons.lock_clock_rounded, l.ob1Title, l.ob1Body, '2 sec', _sampleCard()),
      (C.rose, Icons.wifi_off_rounded, l.ob2Title, l.ob2Body, 'private', _nopes()),
      (C.sky, Icons.diversity_1_rounded, l.ob3Title, l.ob3Body, 'fam ✦', _fam()),
    ];
    final last = _page == pages.length - 1;
    return Scaffold(
      body: DotGrid(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Text('clutch', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(width: 10),
                Sticker(l.offlineSticker, color: C.sage),
                const Spacer(),
                if (!last)
                  TextButton(
                    onPressed: () => _pc.animateToPage(pages.length - 1, duration: context.ms(300), curve: Curves.easeOut),
                    child: Text(l.skip, style: TextStyle(color: context.line, fontWeight: FontWeight.w700)),
                  ),
              ]),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pc,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final (color, icon, title, body, tag, art) = pages[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 4, 10, 12),
                      child: Neo(
                        color: color,
                        radius: 28,
                        shadow: 8,
                        padding: const EdgeInsets.all(24),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: C.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: C.ink, width: 3),
                              ),
                              child: Icon(icon, size: 38, color: C.ink),
                            ),
                            const Spacer(),
                            Sticker(tag, color: C.white, angle: .08),
                          ]),
                          Expanded(child: Center(child: art)),
                          Text(title,
                              style: const TextStyle(
                                  fontFamily: display, fontWeight: FontWeight.w700, fontSize: 34, height: 1.08, color: C.ink, letterSpacing: -1)),
                          const SizedBox(height: 16),
                          Text(body, style: const TextStyle(fontSize: 17, height: 1.45, color: C.ink, fontWeight: FontWeight.w500)),
                          if (i == pages.length - 1) ...[
                            const SizedBox(height: 16),
                            Text(l.disclaimer, style: const TextStyle(fontSize: 12, color: C.ink, fontWeight: FontWeight.w500)),
                          ],
                        ]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < pages.length; i++)
                  AnimatedContainer(
                    duration: context.ms(200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 28 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: i == _page ? context.line : Colors.transparent,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: context.edge, width: 1.2),
                    ),
                  ),
              ]),
              const SizedBox(height: 20),
              NeoButton(
                label: last ? l.obCta : l.next,
                icon: last ? Icons.bolt_rounded : Icons.arrow_forward_rounded,
                color: last ? C.sage : C.butter,
                onPressed: last
                    ? _start
                    : () => _pc.nextPage(duration: context.ms(280), curve: Curves.easeOut),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _sampleCard() => LayoutBuilder(
        builder: (context, box) => Transform.rotate(
          angle: context.calm ? 0 : -.07,
          child: SizedBox(
            width: box.maxWidth * .92,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: soft(context),
              ),
              child: AspectRatio(
                aspectRatio: cardSize.aspectRatio,
                child: FittedBox(
                  child: SizedBox.fromSize(
                    size: cardSize,
                    child: CardFront(
                      sos: '112',
                      p: Profile(
                        displayName: 'Asha Rao',
                        bloodGroup: 'O+',
                        allergies: ['Penicillin', 'Peanuts'],
                        contacts: [Contact(name: 'Ravi Rao', relation: 'Dad', phone: '+91 90000 00000')],
                        vibe: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _bubble(IconData icon, Color color, double angle, {bool cross = false}) => Transform.rotate(
        angle: angle,
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: C.ink, width: 3),
            boxShadow: soft(context),
          ),
          child: Stack(alignment: Alignment.center, children: [
            Icon(icon, size: 38, color: C.ink),
            if (cross) Transform.rotate(angle: -.8, child: Container(width: 64, height: 5, color: C.red)),
          ]),
        ),
      );

  Widget _nopes() => Wrap(spacing: 14, runSpacing: 14, alignment: WrapAlignment.center, children: [
        _bubble(Icons.person_rounded, C.white, -.1, cross: true),
        _bubble(Icons.cloud_rounded, C.butter, .08, cross: true),
        _bubble(Icons.ads_click_rounded, C.sage, -.05, cross: true),
      ]);

  Widget _fam() => Wrap(spacing: 10, runSpacing: 12, alignment: WrapAlignment.center, children: [
        _bubble(Icons.elderly_rounded, C.butter, -.08),
        _bubble(Icons.face_3_rounded, C.rose, .06),
        _bubble(Icons.face_6_rounded, C.sage, -.04),
        _bubble(Icons.child_care_rounded, C.peach, .1),
      ]);
}
