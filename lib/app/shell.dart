import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Indices 0..3 correspond to bottom-nav tabs; 4..6 are drawer-only.
  static const _bottomCount = 4;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final showBottomNav = navigationShell.currentIndex < _bottomCount;
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: l.navHome,
      ),
      NavigationDestination(
        icon: const Icon(Icons.fitness_center_outlined),
        selectedIcon: const Icon(Icons.fitness_center),
        label: l.navLog,
      ),
      NavigationDestination(
        icon: const Icon(Icons.show_chart_outlined),
        selectedIcon: const Icon(Icons.show_chart),
        label: l.navProgress,
      ),
      NavigationDestination(
        icon: const Icon(Icons.calendar_today_outlined),
        selectedIcon: const Icon(Icons.calendar_today),
        label: l.navCalendar,
      ),
    ];
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (i) => navigationShell.goBranch(
                i,
                initialLocation: i == navigationShell.currentIndex,
              ),
              destinations: destinations,
            )
          : null,
    );
  }
}
