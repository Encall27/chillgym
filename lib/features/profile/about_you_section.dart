import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/preferences_provider.dart';

const _goalKeys = <String>[
  'strength',
  'muscle',
  'general',
  'endurance',
  'weightLoss',
];

String _goalLabel(AppLocalizations l, String key) => switch (key) {
      'strength' => l.profileGoalStrength,
      'muscle' => l.profileGoalMuscle,
      'general' => l.profileGoalGeneral,
      'endurance' => l.profileGoalEndurance,
      'weightLoss' => l.profileGoalWeightLoss,
      _ => key,
    };

class AboutYouSection extends ConsumerWidget {
  const AboutYouSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final asyncName = ref.watch(profileNameProvider);
    final asyncHeight = ref.watch(profileHeightCmProvider);
    final asyncGoal = ref.watch(profileGoalProvider);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          asyncName.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text(l.genericFailed(e.toString())),
            data: (name) => _NameField(initial: name),
          ),
          const SizedBox(height: 12),
          asyncHeight.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text(l.genericFailed(e.toString())),
            data: (cm) => Consumer(
              builder: (_, innerRef, __) {
                final unit = innerRef
                        .watch(lengthUnitProvider)
                        .valueOrNull ??
                    LengthUnit.cm;
                return _HeightField(
                  key: ValueKey('height-${unit.name}'),
                  initialCm: cm,
                  unit: unit,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.profileGoal,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            l.profileGoalHelp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          asyncGoal.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text(l.genericFailed(e.toString())),
            data: (goal) => Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final key in _goalKeys)
                  ChoiceChip(
                    label: Text(_goalLabel(l, key)),
                    selected: goal == key,
                    onSelected: (sel) async {
                      final prefs =
                          await ref.read(preferencesProvider.future);
                      await prefs.setProfileGoal(sel ? key : null);
                      ref.invalidate(profileGoalProvider);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NameField extends ConsumerStatefulWidget {
  const _NameField({required this.initial});
  final String? initial;

  @override
  ConsumerState<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends ConsumerState<_NameField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final prefs = await ref.read(preferencesProvider.future);
    final v = _ctrl.text.trim();
    await prefs.setProfileName(v.isEmpty ? null : v);
    ref.invalidate(profileNameProvider);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: tr(context).profileName,
        prefixIcon: const Icon(Icons.person_outline),
        border: const OutlineInputBorder(),
      ),
      onEditingComplete: _save,
      onTapOutside: (_) => _save(),
    );
  }
}

class _HeightField extends ConsumerStatefulWidget {
  const _HeightField({super.key, required this.initialCm, required this.unit});
  final double? initialCm;
  final LengthUnit unit;

  @override
  ConsumerState<_HeightField> createState() => _HeightFieldState();
}

class _HeightFieldState extends ConsumerState<_HeightField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final cm = widget.initialCm;
    _ctrl = TextEditingController(
      text: cm == null
          ? ''
          : (() {
              final v = widget.unit.fromCm(cm);
              return v % 1 == 0
                  ? v.toStringAsFixed(0)
                  : v.toStringAsFixed(1);
            })(),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final prefs = await ref.read(preferencesProvider.future);
    final raw = _ctrl.text.trim();
    if (raw.isEmpty) {
      await prefs.setProfileHeightCm(null);
    } else {
      final v = double.tryParse(raw);
      if (v != null) await prefs.setProfileHeightCm(widget.unit.toCm(v));
    }
    ref.invalidate(profileHeightCmProvider);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: tr(context).profileHeight(widget.unit.suffix),
        prefixIcon: const Icon(Icons.height),
        border: const OutlineInputBorder(),
      ),
      onEditingComplete: _save,
      onTapOutside: (_) => _save(),
    );
  }
}
