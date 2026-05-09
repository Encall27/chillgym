import 'package:flutter/material.dart';

import '../../domain/feedback_engine.dart';

class FeedbackBadge extends StatelessWidget {
  const FeedbackBadge({super.key, required this.result});

  final FeedbackResult result;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg, icon) = switch (result.tier) {
      FeedbackTier.notEnough => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        Icons.trending_down,
      ),
      FeedbackTier.oneMoreSet => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
        Icons.add_circle_outline,
      ),
      FeedbackTier.good => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        Icons.check_circle_outline,
      ),
      FeedbackTier.enough => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        Icons.pan_tool_outlined,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            result.tier.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
