import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/effects.dart';
import '../../core/theme.dart';
import '../../domain/profile.dart';
import '../../main.dart';
import '../output_studio/outputs.dart';
import '../output_studio/studio_screen.dart';

const _allergySuggestions = ['Penicillin', 'Peanuts', 'Latex', 'Sulfa drugs', 'Shellfish', 'Bee stings', 'Aspirin', 'Dust'];
const _conditionSuggestions = ['Asthma', 'Diabetes', 'Epilepsy', 'Hypertension', 'Heart condition', 'Pregnant'];

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.profile, this.isNew = false});
  final Profile profile;
  final bool isNew;
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final Profile p = widget.profile;
  final _forms = List.generate(4, (_) => GlobalKey<FormState>());
  int _step = 0;
  int _rev = 0; // bump to re-seed fields after programmatic changes (contact picker, relation chips)

  @override
  void initState() {
    super.initState();
    // Keep medical details out of screenshots and recents. Skipped in debug so
    // screens can be captured while developing.
    if (!kDebugMode) Native.setSecure(true);
    if (p.contacts.isEmpty) p.contacts.add(Contact());
  }

  @override
  void dispose() {
    Native.setSecure(false);
    super.dispose();
  }

  /// Saves progress (F1). Called at every step change and when leaving.
  Future<void> _persist() async {
    if (p.displayName.trim().isEmpty) return;
    final copy = p.copy()
      ..contacts.removeWhere((c) => c.isEmpty)
      ..meds.removeWhere((m) => m.label.isEmpty);
    await store.upsert(copy);
    if (!store.askedNotifications && store.reminders) {
      store.askedNotifications = true;
      await Effects.askNotificationPermission();
      await store.save();
    }
  }

  Future<void> _next() async {
    if (!(_forms[_step].currentState?.validate() ?? true)) {
      HapticFeedback.heavyImpact();
      return;
    }
    FocusScope.of(context).unfocus();
    await _persist();
    if (mounted) setState(() => _step++);
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final steps = [l.stepBasics, l.stepMedical, l.stepContacts, l.stepReview];
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && (_forms[_step].currentState?.validate() ?? true)) _persist();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(children: [
                NeoIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () => Navigator.of(context).maybePop()),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.stepOf(_step + 1), style: Theme.of(context).textTheme.labelSmall),
                    Text(steps[_step], style: Theme.of(context).textTheme.headlineSmall),
                  ]),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(children: [
                for (var i = 0; i < 4; i++)
                  Expanded(
                    child: AnimatedContainer(
                      duration: context.ms(250),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      height: 12,
                      decoration: BoxDecoration(
                        color: i <= _step ? [C.sage, C.rose, C.sky, C.butter][i] : context.card,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: context.edge, width: 1.2),
                      ),
                    ),
                  ),
              ]),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: context.ms(220),
                switchInCurve: Curves.easeOut,
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(position: Tween(begin: const Offset(.06, 0), end: Offset.zero).animate(a), child: child),
                ),
                child: Form(
                  key: _forms[_step],
                  child: ListView(
                    key: ValueKey(_step),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    children: switch (_step) {
                      0 => _basics(context),
                      1 => _medical(context),
                      2 => _contacts(context),
                      _ => _review(context),
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _step < 3
                  ? Row(children: [
                      if (_step > 0) ...[
                        Expanded(child: NeoButton(label: l.back, color: context.card == C.white ? C.white : C.snow, onPressed: _back)),
                        const SizedBox(width: 12),
                      ],
                      Expanded(flex: 2, child: NeoButton(label: l.next, icon: Icons.arrow_forward_rounded, onPressed: _next)),
                    ])
                  : Row(children: [
                      Expanded(child: NeoButton(label: l.done, color: C.white, onPressed: () => Navigator.of(context).maybePop())),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: NeoButton(
                          label: l.makeOutputs,
                          icon: Icons.auto_awesome_rounded,
                          onPressed: () async {
                            await _persist();
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StudioScreen(profileId: p.id)));
                          },
                        ),
                      ),
                    ]),
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _basics(BuildContext context) {
    final l = context.l;
    return [
      TextFormField(
        initialValue: p.displayName,
        autofocus: widget.isNew,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        decoration: InputDecoration(labelText: l.fName),
        validator: (v) => (v ?? '').trim().isEmpty ? l.nameRequired : null,
        onChanged: (v) => p.displayName = v,
      ),
      const SizedBox(height: 24),
      SectionLabel(l.fBlood),
      Wrap(spacing: 8, runSpacing: 10, children: [
        for (final g in bloodGroups)
          NeoChip(
            label: g == 'unknown' ? l.bloodUnknown : g,
            selected: p.bloodGroup == g,
            color: g == 'unknown' ? C.butter : C.redDark,
            onTap: () => setState(() => p.bloodGroup = g),
          ),
      ]),
      const SizedBox(height: 24),
      SectionLabel(l.fDonor),
      Wrap(spacing: 8, runSpacing: 10, children: [
        for (final (v, t) in [(true, l.yes), (false, l.no), (null, l.notSet)])
          NeoChip(label: t, selected: p.organDonor == v, onTap: () => setState(() => p.organDonor = v)),
      ]),
      const SizedBox(height: 24),
      SectionLabel(l.fLanguage),
      Text(l.fLanguageSub, style: TextStyle(color: context.line.withValues(alpha: .7))),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 10, children: [
        for (final e in outputLanguages.entries)
          NeoChip(label: e.value, selected: p.language == e.key, color: C.sky, onTap: () => setState(() => p.language = e.key)),
      ]),
      const SizedBox(height: 24),
      SectionLabel(l.fVibe),
      Wrap(spacing: 12, runSpacing: 12, children: [
        for (var i = 0; i < vibes.length; i++)
          Semantics(
            button: true,
            selected: p.vibe == i,
            label: '${l.fVibe} ${i + 1}',
            child: GestureDetector(
              onTap: () => setState(() => p.vibe = i),
              child: AnimatedContainer(
                duration: context.ms(150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: vibes[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: context.line, width: p.vibe == i ? 4 : 2.5),
                  boxShadow: p.vibe == i ? null : soft(context),
                ),
                child: p.vibe == i ? const Icon(Icons.check_rounded, color: C.ink) : null,
              ),
            ),
          ),
      ]),
    ];
  }

  List<Widget> _medical(BuildContext context) {
    final l = context.l;
    return [
      ChipInput(label: l.fAllergies, items: p.allergies, suggestions: _allergySuggestions, color: C.redDark),
      const SizedBox(height: 24),
      ChipInput(label: l.fConditions, items: p.conditions, suggestions: _conditionSuggestions, color: C.lavender),
      const SizedBox(height: 24),
      SectionLabel(l.fMeds),
      for (final m in p.meds)
        Padding(
          key: ObjectKey(m),
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: m.name,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l.medName),
                onChanged: (v) => m.name = v,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: m.dose,
                decoration: InputDecoration(labelText: l.medDose),
                onChanged: (v) => m.dose = v,
              ),
            ),
            IconButton(
              tooltip: l.delete,
              icon: Icon(Icons.close_rounded, color: context.line),
              onPressed: () => setState(() => p.meds.remove(m)),
            ),
          ]),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: NeoButton(
            label: l.addMed, icon: Icons.medication_rounded, small: true, expand: false, color: C.mint, onPressed: () => setState(() => p.meds.add(Med()))),
      ),
      const SizedBox(height: 28),
      TextFormField(
        initialValue: p.notes,
        maxLength: maxNotes,
        maxLines: 3,
        minLines: 2,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: l.fNotes, hintText: l.notesHint, alignLabelWithHint: true),
        onChanged: (v) => p.notes = v,
      ),
    ];
  }

  List<Widget> _contacts(BuildContext context) {
    final l = context.l;
    final out = outL10n(p); // relation chips in the card's language, since they get printed
    final rels = [out.relMom, out.relDad, out.relPartner, out.relSibling, out.relFriend, out.relChild];
    return [
      Text(l.maxContactsNote, style: TextStyle(color: context.line.withValues(alpha: .7))),
      const SizedBox(height: 14),
      for (var i = 0; i < p.contacts.length; i++)
        Padding(
          key: ObjectKey(p.contacts[i]),
          padding: const EdgeInsets.only(bottom: 18),
          child: Neo(
            color: i == 0 ? vibe(p.vibe) : null,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Builder(builder: (context) {
              final c = p.contacts[i];
              final onVibe = i == 0;
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Text(l.contactN(i + 1),
                      style: TextStyle(fontFamily: display, fontWeight: FontWeight.w700, color: onVibe ? C.ink : context.line)),
                  const Spacer(),
                  if (isAndroid)
                    TextButton.icon(
                      onPressed: () async {
                        final picked = await Native.pickContact();
                        if (picked == null) return;
                        setState(() {
                          c.name = picked.name;
                          c.phone = picked.phone;
                          _rev++;
                        });
                      },
                      icon: Icon(Icons.contacts_rounded, size: 18, color: onVibe ? C.ink : context.line),
                      label: Text(l.pickContact,
                          style: TextStyle(fontWeight: FontWeight.w700, color: onVibe ? C.ink : context.line)),
                    ),
                  if (p.contacts.length > 1)
                    IconButton(
                      tooltip: l.delete,
                      icon: Icon(Icons.close_rounded, color: onVibe ? C.ink : context.line),
                      onPressed: () => setState(() => p.contacts.removeAt(i)),
                    ),
                ]),
                const SizedBox(height: 8),
                TextFormField(
                  key: ValueKey('n$i-$_rev'),
                  initialValue: c.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l.cName),
                  onChanged: (v) => c.name = v,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  key: ValueKey('p$i-$_rev'),
                  initialValue: c.phone,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: InputDecoration(labelText: l.cPhone, prefixIcon: const Icon(Icons.call_rounded)),
                  validator: (v) => validPhone(v ?? '') ? null : l.badPhone,
                  onChanged: (v) => c.phone = v,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  key: ValueKey('r$i-$_rev'),
                  initialValue: c.relation,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l.cRelation),
                  onChanged: (v) => c.relation = v,
                ),
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 8, children: [
                  for (final r in rels)
                    NeoChip(
                      label: r,
                      selected: c.relation == r,
                      color: onVibe ? C.white : vibe(p.vibe),
                      onTap: () => setState(() {
                        c.relation = r;
                        _rev++;
                      }),
                    ),
                ]),
              ]);
            }),
          ),
        ),
      if (p.contacts.length < maxContacts)
        Align(
          alignment: Alignment.centerLeft,
          child: NeoButton(
            label: l.addContact,
            icon: Icons.person_add_alt_1_rounded,
            small: true,
            expand: false,
            color: C.butter,
            onPressed: () => setState(() => p.contacts.add(Contact())),
          ),
        ),
      const SizedBox(height: 28),
      SectionLabel(l.fDoctor),
      TextFormField(
        initialValue: p.doctorName,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: l.doctorName, prefixIcon: const Icon(Icons.medical_services_rounded)),
        onChanged: (v) => p.doctorName = v,
      ),
      const SizedBox(height: 10),
      TextFormField(
        initialValue: p.doctorPhone,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(labelText: l.doctorPhone, prefixIcon: const Icon(Icons.call_rounded)),
        validator: (v) => validPhone(v ?? '') ? null : l.badPhone,
        onChanged: (v) => p.doctorPhone = v,
      ),
    ];
  }

  List<Widget> _review(BuildContext context) {
    final l = context.l;
    final saved = store.profiles.firstWhere((x) => x.id == p.id, orElse: () => p);
    Widget card(Widget w) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: soft(context),
          ),
          child: AspectRatio(aspectRatio: cardSize.aspectRatio, child: FittedBox(child: SizedBox.fromSize(size: cardSize, child: w))),
        );
    return [
      Stack(clipBehavior: Clip.none, children: [
        Neo(
          color: C.sage,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.reviewTitle, style: const TextStyle(fontFamily: display, fontWeight: FontWeight.w700, fontSize: 24, color: C.ink)),
            const SizedBox(height: 6),
            Text(l.reviewBody, style: const TextStyle(color: C.ink, fontSize: 15, height: 1.4)),
          ]),
        ),
        const Positioned(right: 10, top: -12, child: Sticker('saved ✓', color: C.white, angle: .07)),
      ]),
      const SizedBox(height: 24),
      SectionLabel(l.front),
      card(CardFront(p: saved, sos: store.sos)),
      const SizedBox(height: 20),
      SectionLabel(l.backSide),
      card(CardBack(p: saved, sos: store.sos)),
    ];
  }
}

/// Type-and-add chips plus one-tap suggestions.
class ChipInput extends StatefulWidget {
  const ChipInput({super.key, required this.label, required this.items, required this.suggestions, required this.color});
  final String label;
  final List<String> items;
  final List<String> suggestions;
  final Color color;
  @override
  State<ChipInput> createState() => _ChipInputState();
}

class _ChipInputState extends State<ChipInput> {
  final _c = TextEditingController();

  void _add(String v) {
    final t = v.trim();
    if (t.isNotEmpty && !widget.items.any((x) => x.toLowerCase() == t.toLowerCase())) {
      setState(() => widget.items.add(t));
    }
    _c.clear();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final left = widget.suggestions.where((s) => !widget.items.contains(s));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionLabel(widget.label),
      TextField(
        controller: _c,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onSubmitted: _add,
        decoration: InputDecoration(
          hintText: l.addItemHint,
          suffixIcon: IconButton(tooltip: l.add, icon: Icon(Icons.add_circle_rounded, color: context.line, size: 28), onPressed: () => _add(_c.text)),
        ),
      ),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 10, children: [
        for (final s in widget.items)
          NeoChip(label: s, selected: true, color: widget.color, onDelete: () => setState(() => widget.items.remove(s))),
        for (final s in left) NeoChip(label: '+ $s', onTap: () => _add(s)),
      ]),
    ]);
  }
}
