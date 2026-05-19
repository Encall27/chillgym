import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'services/notification_service.dart';
import 'state/preferences_provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No-op on web. On mobile, sets up the notifications plugin / channels.
  await NotificationService.instance.init();
  runApp(const ProviderScope(child: ChillGymApp()));
}

class ChillGymApp extends ConsumerStatefulWidget {
  const ChillGymApp({super.key});

  @override
  ConsumerState<ChillGymApp> createState() =>
      _ChillGymAppState();
}

class _ChillGymAppState extends ConsumerState<ChillGymApp> {
  late final _router = buildAppRouter();

  /// Decodes `en`, `zh`, `zh_HK` style tags into a Flutter [Locale]. Anything
  /// unrecognised falls back to system (null).
  Locale? _localeFromTag(String? tag) {
    if (tag == null || tag.isEmpty) return null;
    final parts = tag.split('_');
    if (parts.length == 1) return Locale(parts[0]);
    return Locale(parts[0], parts[1]);
  }

  ThemeMode _themeModeFromTag(String? tag) {
    switch (tag) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = _localeFromTag(ref.watch(localeTagProvider).valueOrNull);
    final themeMode =
        _themeModeFromTag(ref.watch(themeModeTagProvider).valueOrNull);
    return MaterialApp.router(
      title: 'ChillGym',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: _router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
