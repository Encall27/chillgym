import 'models/exercise.dart';
import 'models/exercise_entry.dart';
import 'models/muscle_group.dart';
import 'models/session.dart';

/// Self-rated training experience. Drives the cold-start reference bands until
/// the user has enough history of their own.
enum ExperienceLevel {
  beginner,
  intermediate,
  advanced;

  String get label => switch (this) {
        ExperienceLevel.beginner => 'Beginner',
        ExperienceLevel.intermediate => 'Intermediate',
        ExperienceLevel.advanced => 'Advanced',
      };

  static ExperienceLevel fromName(String? name) {
    return ExperienceLevel.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ExperienceLevel.beginner,
    );
  }
}

/// Categorical feedback shown next to each strength exercise entry once the
/// user has logged at least one completed set.
enum FeedbackTier {
  notEnough,
  oneMoreSet,
  good,
  enough;

  String get label => switch (this) {
        FeedbackTier.notEnough => 'Not enough',
        FeedbackTier.oneMoreSet => 'One more set',
        FeedbackTier.good => "That's good",
        FeedbackTier.enough => 'Enough — rest this muscle',
      };
}

/// Reason code for a feedback result. Lets the UI pick a localized rationale
/// without the engine pulling in BuildContext.
enum FeedbackRationaleCode {
  notEnoughVsAvg,
  notEnoughVsTarget,
  oneMoreVsAvg,
  oneMoreVsTarget,
  goodVsAvg,
  goodVsTarget,
  enoughBySetCount,
  enoughByRatio,
}

class FeedbackResult {
  const FeedbackResult({
    required this.tier,
    required this.rationale,
    required this.code,
    this.level,
    this.setCount,
  });
  final FeedbackTier tier;

  /// English fallback. UI renders [code] via translations instead.
  final String rationale;
  final FeedbackRationaleCode code;
  final ExperienceLevel? level;
  final int? setCount;
}

/// Per-exercise volume target for cold start, in kg×reps. Numbers are
/// deliberately conservative; tune later from real session data.
const Map<MuscleGroup, Map<ExperienceLevel, double>>
    _coldStartPerExerciseVolume = {
  MuscleGroup.chest: {
    ExperienceLevel.beginner: 800,
    ExperienceLevel.intermediate: 1500,
    ExperienceLevel.advanced: 2500,
  },
  MuscleGroup.back: {
    ExperienceLevel.beginner: 800,
    ExperienceLevel.intermediate: 1500,
    ExperienceLevel.advanced: 2500,
  },
  MuscleGroup.shoulders: {
    ExperienceLevel.beginner: 400,
    ExperienceLevel.intermediate: 800,
    ExperienceLevel.advanced: 1500,
  },
  MuscleGroup.biceps: {
    ExperienceLevel.beginner: 300,
    ExperienceLevel.intermediate: 600,
    ExperienceLevel.advanced: 1000,
  },
  MuscleGroup.triceps: {
    ExperienceLevel.beginner: 300,
    ExperienceLevel.intermediate: 600,
    ExperienceLevel.advanced: 1000,
  },
  MuscleGroup.forearms: {
    ExperienceLevel.beginner: 200,
    ExperienceLevel.intermediate: 400,
    ExperienceLevel.advanced: 800,
  },
  MuscleGroup.core: {
    ExperienceLevel.beginner: 50,
    ExperienceLevel.intermediate: 100,
    ExperienceLevel.advanced: 200,
  },
  MuscleGroup.quads: {
    ExperienceLevel.beginner: 1500,
    ExperienceLevel.intermediate: 3000,
    ExperienceLevel.advanced: 5000,
  },
  MuscleGroup.hamstrings: {
    ExperienceLevel.beginner: 800,
    ExperienceLevel.intermediate: 1800,
    ExperienceLevel.advanced: 3000,
  },
  MuscleGroup.glutes: {
    ExperienceLevel.beginner: 800,
    ExperienceLevel.intermediate: 1800,
    ExperienceLevel.advanced: 3000,
  },
  MuscleGroup.calves: {
    ExperienceLevel.beginner: 500,
    ExperienceLevel.intermediate: 1000,
    ExperienceLevel.advanced: 1800,
  },
  MuscleGroup.fullBody: {
    ExperienceLevel.beginner: 1500,
    ExperienceLevel.intermediate: 3000,
    ExperienceLevel.advanced: 5000,
  },
};

/// Volume of a single entry: sum over completed strength sets of weight × reps.
double entryVolume(ExerciseEntry entry) => entry.totalVolumeKg;

/// Median of the last `windowSessions` recorded volumes for the same exercise.
/// Returns null if the user has no prior session of this exercise.
double? _personalBaseline({
  required String exerciseId,
  required List<Session> history,
  int windowSessions = 4,
}) {
  final volumes = <double>[];
  for (final s in history) {
    for (final e in s.entries) {
      if (e.exercise.id == exerciseId) {
        final v = entryVolume(e);
        if (v > 0) volumes.add(v);
      }
    }
  }
  if (volumes.isEmpty) return null;
  // history is expected newest-first; take the first windowSessions volumes.
  final tail =
      volumes.length <= windowSessions ? volumes : volumes.sublist(0, windowSessions);
  tail.sort();
  final mid = tail.length ~/ 2;
  return tail.length.isOdd
      ? tail[mid]
      : (tail[mid - 1] + tail[mid]) / 2.0;
}

/// Beyond ~5 quality strength sets per exercise, additional volume is mostly
/// junk volume on the same muscle. Cap suggests stopping rather than piling
/// on extra sets.
const int _maxRecommendedStrengthSets = 5;

/// Hard ceiling on volume ratio. Above this we override the "good" tier and
/// recommend stopping — protects users who are doing extreme volume on a
/// single exercise (e.g. 10+ sets of bench press).
const double _excessRatioCap = 1.8;

/// Returns null when no feedback should be shown:
/// - cardio entries (different metric)
/// - empty entries (nothing logged yet)
FeedbackResult? evaluateEntry({
  required ExerciseEntry entry,
  required List<Session> history,
  required ExperienceLevel experienceLevel,
}) {
  if (entry.exercise.kind == ExerciseKind.cardio) return null;
  final current = entryVolume(entry);
  if (current <= 0) return null;

  final completedStrengthSets = entry.sets
      .where((s) => s.weightKg != null && s.reps != null && s.reps! > 0)
      .length;

  final personal = _personalBaseline(
    exerciseId: entry.exercise.id,
    history: history,
  );
  final cold =
      _coldStartPerExerciseVolume[entry.exercise.primaryMuscle]?[experienceLevel] ??
          800;
  final baseline = personal ?? cold;
  if (baseline <= 0) return null;

  final ratio = current / baseline;

  // Cap fires whenever the user has stacked enough sets to risk junk volume,
  // or whenever they've blown well past the baseline. Either signal alone is
  // enough — set count catches the 10×3 case, ratio catches huge weights.
  if (completedStrengthSets >= _maxRecommendedStrengthSets ||
      ratio >= _excessRatioCap) {
    final bySetCount = completedStrengthSets >= _maxRecommendedStrengthSets;
    final reason = bySetCount
        ? 'You\'ve done $completedStrengthSets sets — extra volume here is '
            'unlikely to add growth. Move to another muscle.'
        : 'Volume is well past the typical target for this exercise. Save '
            'energy for the rest of your session.';
    return FeedbackResult(
      tier: FeedbackTier.enough,
      rationale: reason,
      code: bySetCount
          ? FeedbackRationaleCode.enoughBySetCount
          : FeedbackRationaleCode.enoughByRatio,
      setCount: bySetCount ? completedStrengthSets : null,
    );
  }
  if (ratio >= 1.05) {
    return FeedbackResult(
      tier: FeedbackTier.good,
      rationale: personal != null
          ? 'On track with your recent average.'
          : 'Above the typical ${experienceLevel.label.toLowerCase()} target.',
      code: personal != null
          ? FeedbackRationaleCode.goodVsAvg
          : FeedbackRationaleCode.goodVsTarget,
      level: experienceLevel,
    );
  }
  if (ratio >= 0.85) {
    return FeedbackResult(
      tier: FeedbackTier.oneMoreSet,
      rationale: personal != null
          ? 'Close to your recent average — one more set tips it over.'
          : 'Almost at the typical ${experienceLevel.label.toLowerCase()} target.',
      code: personal != null
          ? FeedbackRationaleCode.oneMoreVsAvg
          : FeedbackRationaleCode.oneMoreVsTarget,
      level: experienceLevel,
    );
  }
  return FeedbackResult(
    tier: FeedbackTier.notEnough,
    rationale: personal != null
        ? 'Below your recent average for this exercise.'
        : 'Below the typical ${experienceLevel.label.toLowerCase()} target.',
    code: personal != null
        ? FeedbackRationaleCode.notEnoughVsAvg
        : FeedbackRationaleCode.notEnoughVsTarget,
    level: experienceLevel,
  );
}
