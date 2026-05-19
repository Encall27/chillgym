import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/brand_title.dart';
import '../../app/drawer.dart';
import '../../domain/day_part.dart';
import '../../domain/models/muscle_group.dart';
import '../../domain/models/session.dart';
import '../../domain/models/template.dart';
import '../../domain/streaks.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/active_session_controller.dart';
import '../../state/preferences_provider.dart';
import '../../state/session_repository_provider.dart';
import '../../state/template_repository_provider.dart';
import '../../theme/brand_tokens.dart';
import '../history/session_detail_screen.dart';
import '../library/template_detail_screen.dart';
import '../shared/design_primitives.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final asyncSessions = ref.watch(pastSessionsProvider);
    final asyncTemplates = ref.watch(templatesProvider);
    final asyncName = ref.watch(profileNameProvider);
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandTitle(),
        centerTitle: true,
      ),
      body: asyncSessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.loadFailed(e.toString()))),
        data: (sessions) {
          final stats = computeStreakStats(sessions);
          final templates = asyncTemplates.maybeWhen(
            data: (t) => t,
            orElse: () => const <WorkoutTemplate>[],
          );
          final name = asyncName.maybeWhen(data: (n) => n, orElse: () => null);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _Greeting(name: name),
              const SizedBox(height: 16),
              _StreakHeroCard(stats: stats),
              const SizedBox(height: 12),
              _NextUpCard(
                template: templates.isEmpty ? null : templates.first,
                hasActive: ref.watch(activeSessionProvider) != null,
              ),
              const SizedBox(height: 20),
              EyebrowLabel(l.homeRecent),
              const SizedBox(height: 8),
              if (sessions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l.homeNoRecent,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                )
              else
                ...sessions.take(3).map(
                      (s) => _RecentRow(session: s, unit: unit, brand: brand),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name});
  final String? name;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final greeting = l.homeGreetingFor(DateTime.now().hour);
    final dateFmt = DateFormat.MMMEd(
      Localizations.localeOf(context).toString(),
    );
    final hasName = name != null && name!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateFmt.format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          greeting,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        Text(
          hasName ? '$name.' : '${l.navHome}.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}

class _StreakHeroCard extends StatelessWidget {
  const _StreakHeroCard({required this.stats});
  final StreakStats stats;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final ringProgress =
        stats.longest <= 0 ? 0.0 : stats.current / stats.longest;
    final stripFilled = stats.current.clamp(0, 14);
    final delta = stats.longest - stats.current;
    final subtitle = stats.longest <= 0 || delta < 0
        ? l.homeRecordSet
        : delta == 0
            ? l.homeRecordTied
            : l.homeFromRecord(delta);

    return Card(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: RadialGradient(
                  center: const Alignment(0.6, -0.7),
                  radius: 1.1,
                  colors: [
                    scheme.primary.withValues(alpha: 0.13),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                StreakRing(
                  size: 86,
                  progress: ringProgress,
                  strokeWidth: 6,
                  useGlow: brand.useGlow,
                  label: Text(
                    '${stats.current}',
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                  ),
                  subLabel: Text(
                    l.streakDayUnit(stats.current).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.5,
                          fontSize: 9,
                        ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EyebrowLabel(
                        l.homeOnFire,
                        color: brand.amberDeep,
                        dot: true,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.homeStreakSummary(stats.current),
                        style: brand.useGlow
                            ? Theme.of(context).textTheme.titleMedium
                            : Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      StreakStrip(filled: stripFilled, total: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextUpCard extends ConsumerWidget {
  const _NextUpCard({required this.template, required this.hasActive});

  final WorkoutTemplate? template;
  final bool hasActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;

    // Amber-on-everything: warm theme uses amberDeep + cream text, dark theme
    // uses amber primary + black text. Earlier the warm theme inverted to a
    // dark cream-on-charcoal card, which clashed with the rest of the screen.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? scheme.primary : brand.amberDeep;
    final fg = isDark ? const Color(0xFF000000) : scheme.onPrimary;
    final eyebrow = fg.withValues(alpha: 0.75);
    final playBg = isDark ? const Color(0xFF000000) : scheme.surface;
    final playFg = isDark ? scheme.primary : brand.amberDeep;

    final t = template;
    final exercises = t?.exercises.length ?? 0;
    final estMinutes = exercises == 0 ? null : exercises * 10;

    void onTap() {
      if (hasActive) {
        // Already in a session — just go to the Log tab.
        context.go('/log');
        return;
      }
      if (t != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TemplateDetailScreen(template: t)),
        );
      } else {
        ref.read(activeSessionProvider.notifier).startSession();
        context.go('/log');
      }
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: brand.useGlow
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.20),
                      blurRadius: 20,
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EyebrowLabel(l.homeNextUp, color: eyebrow),
                    const SizedBox(height: 4),
                    Text(
                      hasActive
                          ? l.actionResumeWorkout
                          : t?.name ?? l.homeStartFreshSession,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: fg,
                            fontStyle: brand.useGlow
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasActive
                          ? l.activeTitle
                          : t == null
                              ? l.homeStartFreshHint
                              : l.homeNextUpSummary(exercises, estMinutes ?? 0),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: fg.withValues(alpha: 0.7),
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: playBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.play_arrow_rounded, size: 28, color: playFg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({
    required this.session,
    required this.unit,
    required this.brand,
  });

  final Session session;
  final WeightUnit unit;
  final BrandTokens brand;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final shortDate = DateFormat('MM.dd').format(session.startedAt);
    final part = dayPartOf(session.startedAt);
    final accent = switch (part) {
      DayPart.morning => brand.amberDeep,
      DayPart.afternoon => brand.warning,
      DayPart.evening => brand.info,
      DayPart.night => brand.positive,
    };

    // Headline: user-supplied name beats auto-detected muscle group.
    final headline = (session.name != null && session.name!.isNotEmpty)
        ? session.name!
        : (session.entries.isEmpty
            ? l.activeTitle
            : _topMuscleLabel(session, l));

    final muscleTag = _muscleTagText(session, l);
    final placeTag = session.place;

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SessionDetailScreen(session: session),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 48,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  shortDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (muscleTag != null)
                        _SessionTag(
                          icon: Icons.fitness_center,
                          label: muscleTag,
                          color: brand.positive,
                        ),
                      if (placeTag != null)
                        _SessionTag(
                          icon: Icons.place_outlined,
                          label: placeTag,
                          color: brand.info,
                        ),
                      for (final f in session.friends)
                        _SessionTag(
                          icon: Icons.people_outline,
                          label: _titleCase(f),
                          color: brand.warning,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(Icons.chevron_right, color: accent),
            ),
          ],
        ),
      ),
    );
  }

  /// Headline label = the muscle group with the most sets in the session.
  String _topMuscleLabel(Session s, AppLocalizations l) {
    final counts = <MuscleGroup, int>{};
    for (final e in s.entries) {
      counts[e.exercise.primaryMuscle] =
          (counts[e.exercise.primaryMuscle] ?? 0) + e.sets.length;
    }
    if (counts.isEmpty) {
      return l.muscleLabel(s.entries.first.exercise.primaryMuscle);
    }
    final top = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return l.muscleLabel(top.key);
  }

  /// Tag = up to 3 distinct primary muscles, comma-joined ("Chest · Triceps").
  String? _muscleTagText(Session s, AppLocalizations l) {
    if (s.entries.isEmpty) return null;
    final seen = <MuscleGroup>{};
    for (final e in s.entries) {
      seen.add(e.exercise.primaryMuscle);
      if (seen.length >= 3) break;
    }
    return seen.map((m) => l.muscleLabel(m)).join(' · ');
  }

  /// Title-case a friend's name ("douglas" → "Douglas", "BIG MIKE" → "Big Mike").
  String _titleCase(String s) {
    final trimmed = s.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed.split(RegExp(r'\s+')).map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }
}

class _SessionTag extends StatelessWidget {
  const _SessionTag({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
