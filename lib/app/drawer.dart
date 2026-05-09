import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class _DrawerEntry {
  const _DrawerEntry(this.path, this.labelOf, this.icon);
  final String path;
  final String Function(AppLocalizations l) labelOf;
  final IconData icon;
}

final _entries = <_DrawerEntry>[
  _DrawerEntry('/home', (l) => l.navHome, Icons.home),
  _DrawerEntry('/log', (l) => l.navLog, Icons.fitness_center),
  _DrawerEntry('/progress', (l) => l.navProgress, Icons.show_chart),
  _DrawerEntry('/calendar', (l) => l.navCalendar, Icons.calendar_today),
  _DrawerEntry('/library', (l) => l.navLibrary, Icons.menu_book),
  _DrawerEntry('/profile', (l) => l.navProfile, Icons.person),
  _DrawerEntry('/settings', (l) => l.navSettings, Icons.settings),
];

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final currentLocation = GoRouterState.of(context).uri.path;

    return NavigationDrawer(
      selectedIndex: _entries
          .indexWhere((e) => currentLocation.startsWith(e.path))
          .clamp(0, _entries.length - 1),
      onDestinationSelected: (i) {
        Navigator.of(context).pop();
        GoRouter.of(context).go(_entries[i].path);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                l.appTagline,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const Divider(),
        ..._entries.map(
          (e) => NavigationDrawerDestination(
            icon: Icon(e.icon),
            label: Text(e.labelOf(l)),
          ),
        ),
      ],
    );
  }
}
