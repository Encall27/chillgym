import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/brand_title.dart';
import '../../app/drawer.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../services/health_service.dart';
import '../../state/preferences_provider.dart';
import '../profile/notifications_section.dart';

/// App-wide preferences. Profile keeps personal data (name, height, goal,
/// bodyweight, body photos, data export); Settings owns app behaviour
/// (language, units, notifications, integrations).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final asyncWeightUnit = ref.watch(weightUnitProvider);
    final asyncLengthUnit = ref.watch(lengthUnitProvider);
    final asyncLocale = ref.watch(localeTagProvider);
    final asyncTheme = ref.watch(themeModeTagProvider);
    final asyncEnabled = ref.watch(healthEnabledProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandTitle(),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader(label: l.profileSectionTheme),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.profileThemeHelp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                asyncTheme.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text(l.genericFailed(e.toString())),
                  data: (tag) => SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'system',
                        label: Text(l.profileThemeSystem),
                        icon: const Icon(Icons.brightness_auto_outlined),
                      ),
                      ButtonSegment(
                        value: 'light',
                        label: Text(l.profileThemeLight),
                        icon: const Icon(Icons.light_mode_outlined),
                      ),
                      ButtonSegment(
                        value: 'dark',
                        label: Text(l.profileThemeDark),
                        icon: const Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                    selected: {tag ?? 'system'},
                    onSelectionChanged: (s) async {
                      final prefs =
                          await ref.read(preferencesProvider.future);
                      await prefs.setThemeModeTag(s.first);
                      ref.invalidate(themeModeTagProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(label: l.profileSectionLanguage),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.profileLanguageHelp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                asyncLocale.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text(l.genericFailed(e.toString())),
                  data: (tag) => SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'system',
                        label: Text(l.profileLanguageSystem),
                      ),
                      ButtonSegment(
                        value: 'en',
                        label: Text(l.profileLanguageEnglish),
                      ),
                      ButtonSegment(
                        value: 'zh_HK',
                        label: Text(l.profileLanguageZhHK),
                      ),
                    ],
                    selected: {tag ?? 'system'},
                    onSelectionChanged: (s) async {
                      final prefs =
                          await ref.read(preferencesProvider.future);
                      final picked = s.first;
                      await prefs.setLocaleTag(
                        picked == 'system' ? null : picked,
                      );
                      ref.invalidate(localeTagProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(label: l.profileSectionUnits),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.profileWeightLabel,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  l.profileUnitsHelp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                asyncWeightUnit.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text(l.genericFailed(e.toString())),
                  data: (unit) => SegmentedButton<WeightUnit>(
                    segments: const [
                      ButtonSegment(
                        value: WeightUnit.kg,
                        label: Text('kg'),
                      ),
                      ButtonSegment(
                        value: WeightUnit.lb,
                        label: Text('lb'),
                      ),
                    ],
                    selected: {unit},
                    onSelectionChanged: (s) async {
                      final prefs =
                          await ref.read(preferencesProvider.future);
                      await prefs.setWeightUnit(s.first);
                      ref.invalidate(weightUnitProvider);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.profileHeightLabel,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                asyncLengthUnit.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text(l.genericFailed(e.toString())),
                  data: (unit) => SegmentedButton<LengthUnit>(
                    segments: const [
                      ButtonSegment(
                        value: LengthUnit.cm,
                        label: Text('cm'),
                      ),
                      ButtonSegment(
                        value: LengthUnit.inch,
                        label: Text('in'),
                      ),
                    ],
                    selected: {unit},
                    onSelectionChanged: (s) async {
                      final prefs =
                          await ref.read(preferencesProvider.future);
                      await prefs.setLengthUnit(s.first);
                      ref.invalidate(lengthUnitProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(label: l.profileSectionNotifications),
          const NotificationsSection(),
          const Divider(height: 32),
          _SectionHeader(label: l.profileSectionIntegrations),
          asyncEnabled.when(
            loading: () => ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(l.profileHealth),
              trailing: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(l.profileHealth),
              subtitle: Text(l.genericFailed(e.toString())),
            ),
            data: (enabled) => SwitchListTile(
              secondary: const Icon(Icons.favorite),
              title: Text(l.profileHealth),
              subtitle: Text(
                kIsWeb
                    ? l.profileHealthWeb
                    : enabled
                        ? l.profileHealthOnMobile
                        : l.profileHealthOff,
              ),
              value: enabled,
              onChanged: (v) async {
                final prefs = await ref.read(preferencesProvider.future);
                await prefs.setHealthEnabled(v);
                if (v && HealthService.instance.isPlatformSupported) {
                  await HealthService.instance.requestPermissions();
                }
                ref.invalidate(healthEnabledProvider);
              },
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
