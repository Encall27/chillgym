import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

import '../domain/day_part.dart';
import '../domain/feedback_engine.dart';
import '../domain/models/exercise.dart';
import '../domain/models/muscle_group.dart';
import '../domain/models/session.dart';
import '../domain/units.dart';

/// Helpers for translating enum labels and feedback rationale codes against
/// the active [AppLocalizations]. Models keep English `.label` for non-UI
/// callers (JSON, tests, share-card fallback); the UI calls these instead.
extension TranslationsX on AppLocalizations {
  String muscleLabel(MuscleGroup g) => switch (g) {
        MuscleGroup.chest => muscleChest,
        MuscleGroup.back => muscleBack,
        MuscleGroup.shoulders => muscleShoulders,
        MuscleGroup.biceps => muscleBiceps,
        MuscleGroup.triceps => muscleTriceps,
        MuscleGroup.forearms => muscleForearms,
        MuscleGroup.core => muscleCore,
        MuscleGroup.quads => muscleQuads,
        MuscleGroup.hamstrings => muscleHamstrings,
        MuscleGroup.glutes => muscleGlutes,
        MuscleGroup.calves => muscleCalves,
        MuscleGroup.fullBody => muscleFullBody,
        MuscleGroup.cardio => muscleCardio,
      };

  String moodLabel(SessionMood m) => switch (m) {
        SessionMood.strong => moodStrong,
        SessionMood.normal => moodNormal,
        SessionMood.tired => moodTired,
        SessionMood.sick => moodSick,
      };

  String weatherLabel(SessionWeather w) => switch (w) {
        SessionWeather.sunny => weatherSunny,
        SessionWeather.cloudy => weatherCloudy,
        SessionWeather.rainy => weatherRainy,
        SessionWeather.snowy => weatherSnowy,
        SessionWeather.hot => weatherHot,
        SessionWeather.cold => weatherCold,
      };

  String kindLabel(ExerciseKind k) => switch (k) {
        ExerciseKind.strength => kindStrength,
        ExerciseKind.cardio => kindCardio,
      };

  String equipmentLabelOf(Equipment e) => switch (e) {
        Equipment.barbell => equipmentBarbell,
        Equipment.dumbbell => equipmentDumbbell,
        Equipment.machine => equipmentMachine,
        Equipment.cable => equipmentCable,
        Equipment.bodyweight => equipmentBodyweight,
        Equipment.other => equipmentOther,
      };

  String expLabel(ExperienceLevel l) => switch (l) {
        ExperienceLevel.beginner => expBeginner,
        ExperienceLevel.intermediate => expIntermediate,
        ExperienceLevel.advanced => expAdvanced,
      };

  String feedbackTierLabel(FeedbackTier t) => switch (t) {
        FeedbackTier.notEnough => feedbackNotEnough,
        FeedbackTier.oneMoreSet => feedbackOneMoreSet,
        FeedbackTier.good => feedbackGood,
        FeedbackTier.enough => feedbackEnough,
      };

  String dayPartShortLabel(DayPart p) => switch (p) {
        DayPart.morning => calendarLegendAm,
        DayPart.afternoon => calendarLegendPm,
        DayPart.evening => calendarLegendEve,
        DayPart.night => calendarLegendNight,
      };

  String homeGreetingFor(int hour) {
    if (hour < 5) return homeGreetingLate;
    if (hour < 12) return homeGreetingMorning;
    if (hour < 18) return homeGreetingAfternoon;
    return homeGreetingEvening;
  }

  String feedbackRationaleFor(FeedbackResult r) {
    final levelText = r.level == null ? '' : expLabel(r.level!);
    return switch (r.code) {
      FeedbackRationaleCode.notEnoughVsAvg => feedbackBelowAvg,
      FeedbackRationaleCode.notEnoughVsTarget =>
        feedbackBelowTarget(levelText),
      FeedbackRationaleCode.oneMoreVsAvg => feedbackCloseAvg,
      FeedbackRationaleCode.oneMoreVsTarget =>
        feedbackAlmostTarget(levelText),
      FeedbackRationaleCode.goodVsAvg => feedbackOnTrack,
      FeedbackRationaleCode.goodVsTarget => feedbackAboveTarget(levelText),
      FeedbackRationaleCode.enoughBySetCount =>
        feedbackEnoughBySetCount(r.setCount ?? 0),
      FeedbackRationaleCode.enoughByRatio => feedbackEnoughByRatio,
    };
  }

  String weightUnitSuffix(WeightUnit u) => u.suffix;
  String lengthUnitSuffix(LengthUnit u) => u.suffix;
}

/// Top-level convenience: `tr(context).startWorkout` if you'd rather not pass
/// `AppLocalizations` around manually.
AppLocalizations tr(BuildContext context) => AppLocalizations.of(context);
