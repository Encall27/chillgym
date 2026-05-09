import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Centered "ChillGym" wordmark used as the title of every AppBar. Tapping it
/// returns the user to the Home tab from anywhere — including pushed detail
/// routes — by issuing a top-level `context.go('/home')`.
class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key, this.subtitle});

  /// Optional secondary line shown below the brand for screens that need
  /// extra context (e.g. a session date).
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Text(
      AppLocalizations.of(context).appName,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
    );
    return InkWell(
      onTap: () => context.go('/home'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: subtitle == null
            ? brand
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  brand,
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
