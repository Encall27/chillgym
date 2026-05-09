import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/translations.dart';
import '../../services/notification_service.dart';
import '../../state/preferences_provider.dart';

const _restOptions = <int>[60, 90, 120, 180];
const _nudgeOptions = <int>[0, 2, 3, 5, 7];

class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final asyncOn = ref.watch(notificationsEnabledProvider);
    final asyncRest = ref.watch(restTimerSecondsProvider);
    final asyncNudge = ref.watch(inactivityNudgeDaysProvider);
    final scheme = Theme.of(context).colorScheme;

    return asyncOn.when(
      loading: () => ListTile(
        leading: const Icon(Icons.notifications_outlined),
        title: Text(l.profileNotifications),
        trailing: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (e, _) => ListTile(
        leading: const Icon(Icons.notifications_outlined),
        title: Text(l.profileNotifications),
        subtitle: Text(l.genericFailed(e.toString())),
      ),
      data: (enabled) {
        return Column(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: Text(l.profileNotifications),
              subtitle: Text(
                kIsWeb
                    ? l.profileNotificationsWeb
                    : enabled
                        ? l.profileNotificationsOn
                        : l.profileNotificationsOff,
              ),
              value: enabled,
              onChanged: (v) async {
                final prefs = await ref.read(preferencesProvider.future);
                if (v && NotificationService.instance.isPlatformSupported) {
                  final granted = await NotificationService.instance
                      .requestPermissions();
                  if (!granted) {
                    await prefs.setNotificationsEnabled(false);
                    ref.invalidate(notificationsEnabledProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l.profileNotificationsDenied),
                        ),
                      );
                    }
                    return;
                  }
                }
                await prefs.setNotificationsEnabled(v);
                if (!v) {
                  await NotificationService.instance.cancelRest();
                  await NotificationService.instance.cancelInactivity();
                }
                ref.invalidate(notificationsEnabledProvider);
              },
            ),
            if (enabled) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  l.restTimerSection,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  l.restTimerHelp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: asyncRest.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text(l.genericFailed(e.toString())),
                  data: (secs) => SegmentedButton<int>(
                    segments: [
                      for (final s in _restOptions)
                        ButtonSegment(
                          value: s,
                          label: Text(_formatSecs(s)),
                        ),
                    ],
                    selected: {
                      _restOptions.contains(secs)
                          ? secs
                          : _restOptions.first,
                    },
                    onSelectionChanged: (sel) async {
                      final prefs =
                          await ref.read(preferencesProvider.future);
                      await prefs.setRestTimerSeconds(sel.first);
                      ref.invalidate(restTimerSecondsProvider);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  l.inactivityNudgeSection,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  l.inactivityNudgeHelp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: asyncNudge.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text(l.genericFailed(e.toString())),
                  data: (days) => Wrap(
                    spacing: 6,
                    children: [
                      for (final d in _nudgeOptions)
                        ChoiceChip(
                          label: Text(d == 0
                              ? l.inactivityOff
                              : l.inactivityDays(d)),
                          selected: days == d,
                          onSelected: (sel) async {
                            if (!sel) return;
                            final prefs = await ref
                                .read(preferencesProvider.future);
                            await prefs.setInactivityNudgeDays(d);
                            if (d == 0) {
                              await NotificationService.instance
                                  .cancelInactivity();
                            }
                            ref.invalidate(inactivityNudgeDaysProvider);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _formatSecs(int s) {
    if (s < 60) return '${s}s';
    final m = s ~/ 60;
    final r = s % 60;
    return r == 0 ? '${m}m' : '${m}m${r}s';
  }
}
