import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/brand_title.dart';
import '../../app/drawer.dart';
import '../../domain/feedback_engine.dart';
import '../../l10n/translations.dart';
import '../../state/preferences_provider.dart';
import 'about_you_section.dart';
import 'data_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final asyncLevel = ref.watch(experienceLevelProvider);
    final asyncShowRir = ref.watch(showRirProvider);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandTitle(),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader(label: l.profileSectionAbout),
          const AboutYouSection(),
          const Divider(height: 32),
          _SectionHeader(label: l.profileSectionTraining),
          asyncLevel.when(
            loading: () => ListTile(
              leading: const Icon(Icons.fitness_center_outlined),
              title: Text(l.profileExperience),
              subtitle: const Text('…'),
            ),
            error: (e, _) => ListTile(
              leading: const Icon(Icons.fitness_center_outlined),
              title: Text(l.profileExperience),
              subtitle: Text(l.genericFailed(e.toString())),
            ),
            data: (level) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.profileExperience,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.profileExperienceHelp,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<ExperienceLevel>(
                    segments: [
                      ButtonSegment(
                        value: ExperienceLevel.beginner,
                        label: Text(l.expBeginner),
                      ),
                      ButtonSegment(
                        value: ExperienceLevel.intermediate,
                        label: Text(l.expIntermediate),
                      ),
                      ButtonSegment(
                        value: ExperienceLevel.advanced,
                        label: Text(l.expAdvanced),
                      ),
                    ],
                    selected: {level},
                    onSelectionChanged: (s) async {
                      final prefs =
                          await ref.read(preferencesProvider.future);
                      await prefs.setExperienceLevel(s.first);
                      ref.invalidate(experienceLevelProvider);
                    },
                  ),
                ],
              ),
            ),
          ),
          asyncShowRir.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => SizedBox.shrink(),
            data: (showRir) => SwitchListTile(
              secondary: const Icon(Icons.battery_3_bar_outlined),
              title: Text(l.profileShowRir),
              subtitle: Text(l.profileShowRirHelp),
              value: showRir,
              onChanged: (v) async {
                final prefs = await ref.read(preferencesProvider.future);
                await prefs.setShowRir(v);
                ref.invalidate(showRirProvider);
              },
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(label: l.profileSectionData),
          const DataSection(),
          const Divider(height: 32),
          _SectionHeader(label: l.profileSectionAbout2),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.appName),
            subtitle: Text(l.profileVersionLine),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.profileSignInSoon),
            subtitle: Text(
              l.profileSignInSoonHelp,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 1.1,
            ),
      ),
    );
  }
}
