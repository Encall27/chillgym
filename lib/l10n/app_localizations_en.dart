// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ChillGym';

  @override
  String get appTagline => 'show up. lift. repeat.';

  @override
  String get navHome => 'Home';

  @override
  String get navLog => 'Log';

  @override
  String get navProgress => 'Progress';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navLibrary => 'Library';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get navBody => 'Body';

  @override
  String get actionHome => 'Home';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionUpdate => 'Update';

  @override
  String get actionClose => 'Close';

  @override
  String get actionImport => 'Import';

  @override
  String get actionPaste => 'Paste';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionFinish => 'Finish';

  @override
  String get actionDone => 'Done';

  @override
  String get actionShare => 'Share';

  @override
  String get actionDiscard => 'Discard';

  @override
  String get actionKeepGoing => 'Keep going';

  @override
  String get actionDeleteEverything => 'Delete everything';

  @override
  String get actionStartWorkout => 'Start workout';

  @override
  String get actionResumeWorkout => 'Resume workout';

  @override
  String get actionStartFromTemplate => 'Start from template';

  @override
  String get actionAddExercise => 'Add exercise';

  @override
  String get actionAddSet => 'Add set';

  @override
  String get actionRepeatSet => 'Repeat set';

  @override
  String get actionShowAll => 'Show all';

  @override
  String actionViewAllSessions(int count) {
    return 'View all sessions ($count)';
  }

  @override
  String actionUseLast(int count) {
    return 'Use last ($count sets)';
  }

  @override
  String get actionRemoveExercise => 'Remove exercise';

  @override
  String get actionRemovePhoto => 'Remove photo?';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get actionChooseFromGallery => 'Choose from gallery';

  @override
  String get actionTakeOrChoosePhoto => 'Take or choose a photo';

  @override
  String get actionLogWeight => 'Log weight';

  @override
  String get actionUseThisWeight => 'Use this weight';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeGreetingLate => 'Up late';

  @override
  String homeGreetingWithName(Object greeting, Object name) {
    return '$greeting, $name.';
  }

  @override
  String homeGreetingNoName(Object greeting) {
    return '$greeting.';
  }

  @override
  String get streakCurrent => 'Current streak';

  @override
  String get streakLongest => 'Longest';

  @override
  String get streakThisMonth => 'This month';

  @override
  String streakDayUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String streakSessionUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sessions',
      one: 'session',
    );
    return '$_temp0';
  }

  @override
  String get homeNoSessionsYet =>
      'No sessions yet — start one when you\'re ready.';

  @override
  String get homeTrainedToday => 'You trained today.';

  @override
  String get homeYesterdayLast => 'Yesterday was your last session.';

  @override
  String homeDaysSinceLast(int count) {
    return '$count days since your last session.';
  }

  @override
  String homeStartFromTemplateNamed(Object name) {
    return 'Start from \"$name\"';
  }

  @override
  String get homeRecentSessions => 'Recent sessions';

  @override
  String get homeBodyweight => 'Bodyweight';

  @override
  String get homeNoBodyweightYet => 'No bodyweight entries yet';

  @override
  String get homeTapToLogInProfile => 'Tap to log one in Profile.';

  @override
  String get homeOnFire => 'ON FIRE';

  @override
  String homeStreakSummary(int count) {
    return '$count-day streak';
  }

  @override
  String homeFromRecord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days from your record',
      one: '1 day from your record',
    );
    return '$_temp0';
  }

  @override
  String get homeRecordTied => 'You\'re tied with your record.';

  @override
  String get homeRecordSet => 'New personal record!';

  @override
  String get homeNextUp => 'NEXT UP';

  @override
  String homeNextUpSummary(int exercises, int minutes) {
    return '$exercises EXERCISES · ~$minutes MIN';
  }

  @override
  String get homeStartFreshSession => 'Open session';

  @override
  String get homeStartFreshHint => 'Pick exercises as you go';

  @override
  String get homeMetric7DayVolume => '7-DAY VOLUME';

  @override
  String get homeMetricEst1RM => 'EST 1RM';

  @override
  String get homeMetricBodyweight => 'BODYWEIGHT';

  @override
  String get homeMetricSessions => 'SESSIONS';

  @override
  String get homeUnitPerWeek => '/wk';

  @override
  String get homeUnitTons => 't';

  @override
  String get homeRecent => 'RECENT';

  @override
  String get homeNoRecent => 'No sessions yet — your last few will land here.';

  @override
  String get logReadyToTrain => 'Ready to train?';

  @override
  String get logStartHelp => 'Start a session, add exercises, log your sets.';

  @override
  String get logNoTemplatesYet =>
      'No templates yet. Create one in the Library tab.';

  @override
  String get logHeroEyebrow => 'TODAY';

  @override
  String get logTemplatesEyebrow => 'QUICK START';

  @override
  String get logNoTemplatesTitle => 'No templates yet';

  @override
  String get logNoTemplatesHelp =>
      'Save a routine in the Library to start it here in one tap.';

  @override
  String get logCreateTemplate => 'Create';

  @override
  String get logRecapToday => 'You already trained today.';

  @override
  String get logRecapYesterday => 'Last session: yesterday.';

  @override
  String logRecapDaysAgo(int count) {
    return 'Last session: $count days ago.';
  }

  @override
  String get addExerciseConfirmTitle => 'Adding a new exercise';

  @override
  String addExerciseConfirmBody(Object name) {
    return 'Are you done with \"$name\"? Tap Done to push it down and add the new one on top, or Keep going to stay on it.';
  }

  @override
  String get addExerciseConfirmKeep => 'Keep going';

  @override
  String get addExerciseConfirmDone => 'Done';

  @override
  String get activeExerciseDone => 'DONE';

  @override
  String get activeExerciseFinish => 'Mark exercise finished';

  @override
  String get activeExerciseReopen => 'Reopen exercise';

  @override
  String get restTimerMinutes => 'MIN';

  @override
  String get restTimerSeconds => 'SEC';

  @override
  String get notifRestTitle => 'Rest is up';

  @override
  String get notifRestBody => 'Time for the next set.';

  @override
  String get notifInactivityTitle => 'Time to train?';

  @override
  String get notifInactivityBody =>
      'It\'s been a while — keep the streak alive.';

  @override
  String get activeTitle => 'Active workout';

  @override
  String get activeCancelWorkout => 'Cancel workout?';

  @override
  String get activeCancelHelp => 'Logged sets will be discarded.';

  @override
  String get activeNothingYet => 'Tap \"Add exercise\" to begin.';

  @override
  String activeSavedSummary(int sets, Object volume) {
    return 'Saved: $sets sets · $volume total';
  }

  @override
  String get finishedTitle => 'Nice workout!';

  @override
  String get finishedShareHint =>
      'Share a card to celebrate, or just tap done.';

  @override
  String get activeWorkoutAlreadyActive =>
      'A workout is already active. Finish or discard it first.';

  @override
  String activeExerciseCounter(int current, int total) {
    return 'EXERCISE $current OF $total';
  }

  @override
  String activeProgressionPill(Object amount, Object unit) {
    return '+$amount $unit';
  }

  @override
  String get actionRestAdd15 => '+15s';

  @override
  String get actionRestSkip => 'Skip';

  @override
  String get actionNext => 'Next';

  @override
  String get activeUpNext => 'UP NEXT';

  @override
  String get activeNoUpcoming => 'Last exercise — finish to wrap.';

  @override
  String activeNudgeFromYourTrend(Object nudge) {
    return 'Volume in line with your recent average. Try $nudge next session.';
  }

  @override
  String get statExercises => 'Exercises';

  @override
  String get statSets => 'Sets';

  @override
  String get statVolume => 'Volume';

  @override
  String get statDuration => 'Duration';

  @override
  String statBest(Object value) {
    return 'Best: $value';
  }

  @override
  String get statBestTopSet => 'Best top set';

  @override
  String get statEst1RM => 'Est. 1RM';

  @override
  String get statBestVolume => 'Best volume';

  @override
  String get statSessions => 'Sessions';

  @override
  String get topSetWeightTitle => 'Top set weight';

  @override
  String topSetWeightSubtitle(Object unit) {
    return '$unit per session';
  }

  @override
  String get totalVolumeTitle => 'Total volume per session';

  @override
  String totalVolumeSubtitle(Object unit) {
    return '$unit total';
  }

  @override
  String get totalVolumeCardio => '(weight × reps; usually 0 for cardio)';

  @override
  String get noSetData => 'No set data';

  @override
  String sessionsLogged(int count) {
    return '$count sessions logged';
  }

  @override
  String perSessionLine(Object weight, int reps, Object volume) {
    return '$weight × $reps  ·  $volume total';
  }

  @override
  String volumeCardioLine(Object volume) {
    return '$volume volume';
  }

  @override
  String get restingLabel => 'Resting';

  @override
  String get restTimerSection => 'Rest timer';

  @override
  String get restTimerHelp => 'Fires this long after each strength set.';

  @override
  String get inactivityNudgeSection => 'Inactivity nudge';

  @override
  String get inactivityNudgeHelp =>
      'Reminds you if you haven\'t trained in a while. Off keeps the streak nudge silent.';

  @override
  String get inactivityOff => 'Off';

  @override
  String inactivityDays(int count) {
    return '${count}d';
  }

  @override
  String get logSetTitle => 'Log set';

  @override
  String get editSetTitle => 'Edit set';

  @override
  String logSetHeader(Object action, Object exercise) {
    return '$action · $exercise';
  }

  @override
  String fieldWeight(Object unit) {
    return 'Weight ($unit)';
  }

  @override
  String get fieldReps => 'Reps';

  @override
  String get fieldRir => 'RIR (optional)';

  @override
  String get fieldRirHelper => 'Reps in reserve — how many you had left';

  @override
  String get fieldDistance => 'Distance (km)';

  @override
  String get fieldDuration => 'Duration (mm:ss or seconds)';

  @override
  String get fieldNotes => 'Notes (optional)';

  @override
  String get fieldNote => 'Note (optional)';

  @override
  String get actionSaveSet => 'Save set';

  @override
  String get plateCalcTitle => 'Plate calculator';

  @override
  String plateCalcTotal(Object unit) {
    return 'Total weight ($unit)';
  }

  @override
  String plateCalcBar(Object unit) {
    return 'Bar ($unit)';
  }

  @override
  String get plateCalcPerSide => 'Per side (largest first):';

  @override
  String get plateCalcJustBar => 'Just the bar.';

  @override
  String get plateCalcNoPlates => 'No plates needed.';

  @override
  String plateCalcUnaccounted(Object amount, Object unit) {
    return 'Unaccounted: $amount $unit (can\'t hit exactly with available plates).';
  }

  @override
  String get calendarPrevMonth => 'Previous month';

  @override
  String get calendarNextMonth => 'Next month';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarLegendAm => 'AM';

  @override
  String get calendarLegendPm => 'PM';

  @override
  String get calendarLegendEve => 'EVE';

  @override
  String get calendarLegendNight => 'NIGHT';

  @override
  String calendarMonthSummary(int days, Object perWeek) {
    return '$days days · $perWeek/wk';
  }

  @override
  String get calendarHeatmapLess => 'LESS';

  @override
  String get calendarHeatmapMore => 'MORE';

  @override
  String get calendarStatSets => 'SETS';

  @override
  String get calendarStatVolume => 'VOLUME';

  @override
  String get calendarStatMax => 'MAX';

  @override
  String get calendarPickADay => 'Pick a day above to see what you did.';

  @override
  String get calendarNoSessionTitle => 'No workout that day';

  @override
  String get calendarNoSessionBody => 'You didn\'t gym on this day.';

  @override
  String get calendarOpenSession => 'Open session';

  @override
  String get calendarViewMonthly => 'Monthly';

  @override
  String get calendarViewYearly => 'Yearly';

  @override
  String calendarYearSummary(int days, int sessions) {
    return '$days training days · $sessions sessions';
  }

  @override
  String get calendarScopeCurrentMonth => 'Current month';

  @override
  String get calendarScopeCurrentYear => 'Current year';

  @override
  String get calendarScopeAllTime => 'All time';

  @override
  String get calendarScopeChooserTitle => 'Show sessions for…';

  @override
  String get calendarPrCallout => '★ NEW PR';

  @override
  String calendarPrLine(Object exercise, Object weight, int reps) {
    return '$exercise · $weight × $reps';
  }

  @override
  String daySheetSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get daySheetEmpty => 'No sessions on this day';

  @override
  String get daySheetEmptyHelp =>
      'Nothing logged on this day. Sessions you finish will land here automatically.';

  @override
  String daySheetTimeLine(Object part, Object time) {
    return '$part · $time';
  }

  @override
  String get allSessionsTitle => 'All sessions';

  @override
  String get allSessionsEmpty =>
      'No sessions yet — finish a workout from the Log tab.';

  @override
  String get deleteSessionTitle => 'Delete this session?';

  @override
  String get deleteSessionHelp => 'This cannot be undone.';

  @override
  String get deleteSessionTooltip => 'Delete session';

  @override
  String get sessionDetailsTitle => 'Session details';

  @override
  String get sessionName => 'Workout name (optional)';

  @override
  String get sessionNameHint => 'e.g. Leg Day, AM Push';

  @override
  String get sessionPlace => 'Place / gym (optional)';

  @override
  String get sessionMoodPrompt => 'How did it feel?';

  @override
  String get sessionWeather => 'Weather';

  @override
  String get sessionFriends => 'Friends trained with (optional)';

  @override
  String get sessionFriendsHelper => 'Comma-separated names';

  @override
  String get sessionDetailEmpty =>
      'No exercises in this session. Tap \"Add exercise\" below.';

  @override
  String get shareCardTitle => 'Share card';

  @override
  String get shareCardShareToApps => 'Share';

  @override
  String get shareCardSave => 'Save';

  @override
  String get shareCardSessionPhotosTitle =>
      'Or share a moment from this session';

  @override
  String get shareCardNoSessionPhotos =>
      'No photos yet on this workout. Take one now and share it.';

  @override
  String get shareCardTakePhoto => 'Take a photo';

  @override
  String get shareCardSharePhoto => 'Share photo';

  @override
  String get shareCardShareCaption => 'Logged on ChillGym';

  @override
  String shareCardShareFailed(Object error) {
    return 'Couldn\'t open the share sheet: $error';
  }

  @override
  String get moodStrong => 'Strong';

  @override
  String get moodNormal => 'Normal';

  @override
  String get moodTired => 'Tired';

  @override
  String get moodSick => 'Sick';

  @override
  String get weatherSunny => 'Sunny';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherRainy => 'Rainy';

  @override
  String get weatherSnowy => 'Snowy';

  @override
  String get weatherHot => 'Hot';

  @override
  String get weatherCold => 'Cold';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleForearms => 'Forearms';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleQuads => 'Quads';

  @override
  String get muscleHamstrings => 'Hamstrings';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleFullBody => 'Full body';

  @override
  String get muscleCardio => 'Cardio';

  @override
  String get kindStrength => 'Strength';

  @override
  String get kindCardio => 'Cardio';

  @override
  String get equipmentLabel => 'Equipment';

  @override
  String get equipmentBarbell => 'Barbell';

  @override
  String get equipmentDumbbell => 'Dumbbell';

  @override
  String get equipmentMachine => 'Machine';

  @override
  String get equipmentCable => 'Cable';

  @override
  String get equipmentBodyweight => 'Bodyweight';

  @override
  String get equipmentOther => 'Other';

  @override
  String get feedbackNotEnough => 'Not enough';

  @override
  String get feedbackOneMoreSet => 'One more set';

  @override
  String get feedbackGood => 'That\'s good';

  @override
  String get feedbackEnough => 'Enough — rest this muscle';

  @override
  String feedbackEnoughBySetCount(int count) {
    return 'You\'ve done $count sets — extra volume here is unlikely to add growth. Move to another muscle.';
  }

  @override
  String get feedbackEnoughByRatio =>
      'Volume is well past the typical target for this exercise. Save energy for the rest of your session.';

  @override
  String get feedbackOnTrack => 'On track with your recent average.';

  @override
  String feedbackAboveTarget(Object level) {
    return 'Above the typical $level target.';
  }

  @override
  String get feedbackCloseAvg =>
      'Close to your recent average — one more set tips it over.';

  @override
  String feedbackAlmostTarget(Object level) {
    return 'Almost at the typical $level target.';
  }

  @override
  String get feedbackBelowAvg => 'Below your recent average for this exercise.';

  @override
  String feedbackBelowTarget(Object level) {
    return 'Below the typical $level target.';
  }

  @override
  String get expBeginner => 'Beginner';

  @override
  String get expIntermediate => 'Intermediate';

  @override
  String get expAdvanced => 'Advanced';

  @override
  String get libraryExercises => 'Exercises';

  @override
  String get libraryTemplates => 'Templates';

  @override
  String get librarySearch => 'Search exercises';

  @override
  String get libraryFilterAll => 'All';

  @override
  String get libraryNoMatch => 'No exercises match.';

  @override
  String get libraryNewExercise => 'New exercise';

  @override
  String get libraryEditExercise => 'Edit exercise';

  @override
  String get libraryNewTemplate => 'New template';

  @override
  String get libraryEditTemplate => 'Edit template';

  @override
  String get libraryNoTemplatesYet => 'No templates yet.';

  @override
  String get libraryCreateOne => 'Create one to start a workout in one tap.';

  @override
  String get libraryDeleteExercisePrompt => 'Delete this exercise?';

  @override
  String get libraryDeleteExerciseHelp =>
      'Past sessions that reference it will keep their data.';

  @override
  String libraryDeleteTemplatePrompt(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get libraryExerciseName => 'Name';

  @override
  String get libraryExerciseType => 'Type';

  @override
  String get libraryPrimaryMuscle => 'Primary muscle';

  @override
  String get librarySecondaryMuscles => 'Secondary muscles (optional)';

  @override
  String get libraryTemplateName => 'Template name';

  @override
  String get libraryTemplateNameHint => 'e.g. Push Day';

  @override
  String get libraryTemplateExercises => 'Exercises';

  @override
  String get libraryNoExercisesYet => 'No exercises added yet.';

  @override
  String libraryExerciseCount(int count) {
    return '$count exercises';
  }

  @override
  String get libraryPickExercise => 'Pick exercise';

  @override
  String get progressNothingYet => 'Nothing to chart yet.';

  @override
  String get progressLogMore =>
      'Log a few sessions and your trends will appear here.';

  @override
  String get progressByExercise => 'By exercise';

  @override
  String get progressByMuscle => 'By muscle';

  @override
  String get progressLifts => 'Lifts';

  @override
  String get progressBody => 'Body';

  @override
  String get progressDayChanges => 'Day Changes';

  @override
  String get progressBodyweightTitle => 'BODYWEIGHT';

  @override
  String get progressBodyweightEmpty =>
      'Log a bodyweight in Profile to start the trend.';

  @override
  String progressBodyweightDelta7(Object amount, Object unit) {
    return '$amount $unit vs 7 days ago';
  }

  @override
  String get bodyweightStatMin => 'MIN';

  @override
  String get bodyweightStatMax => 'MAX';

  @override
  String get bodyweightStatAvg => 'AVG';

  @override
  String get bodyweightStatRange => 'RANGE';

  @override
  String bodyweightTrendUp(Object amount, Object unit, int days) {
    return 'Trending up — $amount $unit over $days days';
  }

  @override
  String bodyweightTrendDown(Object amount, Object unit, int days) {
    return 'Trending down — $amount $unit over $days days';
  }

  @override
  String bodyweightTrendFlat(int days) {
    return 'Holding steady — $days days logged';
  }

  @override
  String get progressFeatured => 'Featured lift';

  @override
  String progressDeltaUp(Object amount) {
    return '↑ $amount';
  }

  @override
  String progressDeltaDown(Object amount) {
    return '↓ $amount';
  }

  @override
  String get progressDeltaFlat => '—';

  @override
  String get progressPersonalBests => 'PERSONAL BESTS';

  @override
  String get progressPrNewBadge => '★ NEW';

  @override
  String get progressNoLiftYet => 'Log a strength set to start a chart.';

  @override
  String get progressPickLift => 'Pick a lift';

  @override
  String get progressRange1M => '1M';

  @override
  String get progressRange3M => '3M';

  @override
  String get progressRange6M => '6M';

  @override
  String get progressRange1Y => '1Y';

  @override
  String get progressRangeAll => 'ALL';

  @override
  String get progressByMuscleHelp =>
      'Tap a body part to dig in. Brighter = more recent volume.';

  @override
  String get bodyDiagramLow => 'Low';

  @override
  String get bodyDiagramHigh => 'High';

  @override
  String get muscleNoVolumeYet =>
      'No strength volume logged for this muscle yet.';

  @override
  String get muscleRecentVolume => 'Last 4 weeks';

  @override
  String get muscleAllTimeVolume => 'All time';

  @override
  String get muscleWeeklyVolume => 'Weekly volume';

  @override
  String get muscleWeeklyHelp => 'Sum of weight × reps over the last 12 weeks.';

  @override
  String get muscleExercises => 'Exercises';

  @override
  String get muscleNoExercisesYet =>
      'No exercises logged for this muscle group yet.';

  @override
  String get profileSectionAbout => 'About you';

  @override
  String get profileSectionTraining => 'Training';

  @override
  String get profileSectionUnits => 'Units';

  @override
  String get profileSectionLanguage => 'Language';

  @override
  String get profileSectionTheme => 'Appearance';

  @override
  String get profileThemeHelp =>
      'Choose between Warm Editorial (light) and Dark Performance (dark), or follow your phone\'s setting.';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileSectionBodyweight => 'Bodyweight';

  @override
  String get profileSectionNotifications => 'Notifications';

  @override
  String get profileSectionIntegrations => 'Integrations';

  @override
  String get profileSectionData => 'Data';

  @override
  String get profileSectionAbout2 => 'About';

  @override
  String get profileName => 'Name (optional)';

  @override
  String get profileGoal => 'Goal';

  @override
  String get profileGoalHelp => 'Used in summaries and feedback rationale.';

  @override
  String get profileGoalStrength => 'Strength';

  @override
  String get profileGoalMuscle => 'Muscle / size';

  @override
  String get profileGoalGeneral => 'General fitness';

  @override
  String get profileGoalEndurance => 'Endurance';

  @override
  String get profileGoalWeightLoss => 'Weight loss';

  @override
  String profileHeight(Object unit) {
    return 'Height ($unit)';
  }

  @override
  String get profileExperience => 'Experience level';

  @override
  String get profileExperienceHelp =>
      'Used to size your \"Not enough / One more set\" targets until you have your own history.';

  @override
  String get profileShowRir => 'Show RIR field';

  @override
  String get profileShowRirHelp => 'Reps in reserve prompt on the set sheet.';

  @override
  String get profileWeightLabel => 'Weight';

  @override
  String get profileHeightLabel => 'Height';

  @override
  String get profileUnitsHelp =>
      'Switching only changes how weights are shown and entered. Existing data is converted on the fly.';

  @override
  String get profileLanguageHelp => 'Choose how the app should be displayed.';

  @override
  String get profileLanguageSystem => 'System';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageZhHK => '繁體中文 (香港)';

  @override
  String get profileHealth => 'Health integration';

  @override
  String get profileHealthOnMobile =>
      'Workouts will be written to Apple Health / Health Connect.';

  @override
  String get profileHealthOff =>
      'Off — toggle on to write workouts to your phone\'s health app.';

  @override
  String get profileHealthWeb =>
      'Not supported on web — toggle works on iOS / Android.';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationsOn =>
      'Rest-timer end and inactivity nudge are on.';

  @override
  String get profileNotificationsOff =>
      'Off — toggle on for rest-timer and nudge alerts.';

  @override
  String get profileNotificationsWeb =>
      'Not supported on web — wires up on iOS / Android.';

  @override
  String get profileNotificationsDenied =>
      'Permission denied — enable notifications in system settings.';

  @override
  String get profileVersionLine => 'v0.1.0 · Phase 1 (MVP) — pre-SSO build';

  @override
  String get profileSignInSoon => 'Sign-in coming soon';

  @override
  String get profileSignInSoonHelp =>
      'Account, sync, and SSO will be added at the end of Phase 1.';

  @override
  String get bodyweightLatest => 'Latest';

  @override
  String bodyweightInputLabel(Object unit) {
    return 'Weight ($unit)';
  }

  @override
  String get bodyweightLogTitle => 'Log bodyweight';

  @override
  String get bodyweightEditTitle => 'Edit bodyweight';

  @override
  String get bodyweightEmptyHelp =>
      'No bodyweight entries yet. Tap \"Log weight\" to add one.';

  @override
  String get dataExportJson => 'Export as JSON';

  @override
  String get dataExportJsonHelp => 'Full backup. Round-trips via Import.';

  @override
  String get dataExportCsv => 'Export sets as CSV';

  @override
  String get dataExportCsvHelp => 'One row per set, for spreadsheets.';

  @override
  String get dataImport => 'Import data';

  @override
  String get dataImportHelp =>
      'Paste a previously exported JSON. Replaces existing data.';

  @override
  String get dataDeleteAll => 'Delete all data';

  @override
  String get dataDeleteAllHelp =>
      'Wipes everything stored on this device. Irreversible.';

  @override
  String get dataDeleteAllPrompt => 'Delete all data?';

  @override
  String get dataDeleteAllConfirm =>
      'This wipes every session, template, custom exercise, bodyweight entry, and preference on this device. It cannot be undone.';

  @override
  String get dataAllDeleted => 'All data deleted.';

  @override
  String dataExportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String get dataImportComplete => 'Import complete.';

  @override
  String dataImportFailed(Object error) {
    return 'Import failed: $error';
  }

  @override
  String get dataDownloaded => 'Downloaded.';

  @override
  String dataSavedTo(Object path) {
    return 'Saved to: $path';
  }

  @override
  String get dataBackupTitle => 'Backup JSON';

  @override
  String get dataImportTitle => 'Import backup';

  @override
  String get dataImportWarning =>
      'Existing data will be replaced. This cannot be undone.';

  @override
  String get dataImportHint => 'Paste backup JSON here…';

  @override
  String get dataCopied => 'Copied to clipboard.';

  @override
  String loadFailed(Object error) {
    return 'Failed to load: $error';
  }

  @override
  String genericFailed(Object error) {
    return 'Failed: $error';
  }

  @override
  String get bodyPhotosTitle => 'Body progress';

  @override
  String get bodyPhotosEmpty => 'No body photos yet.';

  @override
  String get bodyPhotosEmptyHelp =>
      'Add a photo every week or two; the timeline lets you replay your progress like a flipbook.';

  @override
  String get bodyPhotosAdd => 'Add photo';

  @override
  String get bodyPhotosAddTitle => 'New body photo';

  @override
  String get bodyPhotosEditTitle => 'Edit body photo';

  @override
  String get bodyPhotosDate => 'Date';

  @override
  String get bodyPhotosNoteHint => 'Optional note (e.g. cut start, vacation)';

  @override
  String bodyPhotosWeightOptional(Object unit) {
    return 'Bodyweight ($unit, optional)';
  }

  @override
  String bodyPhotosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get bodyPhotosPlay => 'Play timeline';

  @override
  String get bodyPhotosPlayHint => 'Tap to pause · swipe to scrub';

  @override
  String get bodyPhotosNeedTwo =>
      'Add at least two photos to play the timeline.';

  @override
  String get bodyPhotosDeletePrompt => 'Delete this photo?';

  @override
  String get bodyPhotosTimelineTitle => 'Progress timeline';

  @override
  String get bodyPhotosSlideRate => 'Speed';

  @override
  String get bodyPhotosSlideRateSlow => 'Slow';

  @override
  String get bodyPhotosSlideRateNormal => 'Normal';

  @override
  String get bodyPhotosSlideRateFast => 'Fast';

  @override
  String get bodyPhotosQuotaError =>
      'Browser storage is full — body photos are kept in localStorage which only allows ~5MB. Delete a few older photos and try again, or export your data and run this on the mobile app where there\'s no quota.';
}
