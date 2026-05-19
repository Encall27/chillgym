import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'HK'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'ChillGym'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'show up. lift. repeat.'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get navLog;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get navBody;

  /// No description provided for @actionHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get actionHome;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get actionUpdate;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get actionImport;

  /// No description provided for @actionPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get actionPaste;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get actionFinish;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get actionDiscard;

  /// No description provided for @actionKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get actionKeepGoing;

  /// No description provided for @actionDeleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get actionDeleteEverything;

  /// No description provided for @actionStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get actionStartWorkout;

  /// No description provided for @actionResumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume workout'**
  String get actionResumeWorkout;

  /// No description provided for @actionStartFromTemplate.
  ///
  /// In en, this message translates to:
  /// **'Start from template'**
  String get actionStartFromTemplate;

  /// No description provided for @actionAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get actionAddExercise;

  /// No description provided for @actionAddSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get actionAddSet;

  /// No description provided for @actionRepeatSet.
  ///
  /// In en, this message translates to:
  /// **'Repeat set'**
  String get actionRepeatSet;

  /// No description provided for @actionShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get actionShowAll;

  /// No description provided for @actionViewAllSessions.
  ///
  /// In en, this message translates to:
  /// **'View all sessions ({count})'**
  String actionViewAllSessions(int count);

  /// No description provided for @actionUseLast.
  ///
  /// In en, this message translates to:
  /// **'Use last ({count} sets)'**
  String actionUseLast(int count);

  /// No description provided for @actionRemoveExercise.
  ///
  /// In en, this message translates to:
  /// **'Remove exercise'**
  String get actionRemoveExercise;

  /// No description provided for @actionRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo?'**
  String get actionRemovePhoto;

  /// No description provided for @actionTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get actionTakePhoto;

  /// No description provided for @actionChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get actionChooseFromGallery;

  /// No description provided for @actionTakeOrChoosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take or choose a photo'**
  String get actionTakeOrChoosePhoto;

  /// No description provided for @actionLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get actionLogWeight;

  /// No description provided for @actionUseThisWeight.
  ///
  /// In en, this message translates to:
  /// **'Use this weight'**
  String get actionUseThisWeight;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeGreetingLate.
  ///
  /// In en, this message translates to:
  /// **'Up late'**
  String get homeGreetingLate;

  /// No description provided for @homeGreetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}.'**
  String homeGreetingWithName(Object greeting, Object name);

  /// No description provided for @homeGreetingNoName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}.'**
  String homeGreetingNoName(Object greeting);

  /// No description provided for @streakCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get streakCurrent;

  /// No description provided for @streakLongest.
  ///
  /// In en, this message translates to:
  /// **'Longest'**
  String get streakLongest;

  /// No description provided for @streakThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get streakThisMonth;

  /// No description provided for @streakDayUnit.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{days}}'**
  String streakDayUnit(int count);

  /// No description provided for @streakSessionUnit.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{session} other{sessions}}'**
  String streakSessionUnit(int count);

  /// No description provided for @homeNoSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet — start one when you\'re ready.'**
  String get homeNoSessionsYet;

  /// No description provided for @homeTrainedToday.
  ///
  /// In en, this message translates to:
  /// **'You trained today.'**
  String get homeTrainedToday;

  /// No description provided for @homeYesterdayLast.
  ///
  /// In en, this message translates to:
  /// **'Yesterday was your last session.'**
  String get homeYesterdayLast;

  /// No description provided for @homeDaysSinceLast.
  ///
  /// In en, this message translates to:
  /// **'{count} days since your last session.'**
  String homeDaysSinceLast(int count);

  /// No description provided for @homeStartFromTemplateNamed.
  ///
  /// In en, this message translates to:
  /// **'Start from \"{name}\"'**
  String homeStartFromTemplateNamed(Object name);

  /// No description provided for @homeRecentSessions.
  ///
  /// In en, this message translates to:
  /// **'Recent sessions'**
  String get homeRecentSessions;

  /// No description provided for @homeBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get homeBodyweight;

  /// No description provided for @homeNoBodyweightYet.
  ///
  /// In en, this message translates to:
  /// **'No bodyweight entries yet'**
  String get homeNoBodyweightYet;

  /// No description provided for @homeTapToLogInProfile.
  ///
  /// In en, this message translates to:
  /// **'Tap to log one in Profile.'**
  String get homeTapToLogInProfile;

  /// No description provided for @homeOnFire.
  ///
  /// In en, this message translates to:
  /// **'ON FIRE'**
  String get homeOnFire;

  /// No description provided for @homeStreakSummary.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String homeStreakSummary(int count);

  /// No description provided for @homeFromRecord.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day from your record} other{{count} days from your record}}'**
  String homeFromRecord(int count);

  /// No description provided for @homeRecordTied.
  ///
  /// In en, this message translates to:
  /// **'You\'re tied with your record.'**
  String get homeRecordTied;

  /// No description provided for @homeRecordSet.
  ///
  /// In en, this message translates to:
  /// **'New personal record!'**
  String get homeRecordSet;

  /// No description provided for @homeNextUp.
  ///
  /// In en, this message translates to:
  /// **'NEXT UP'**
  String get homeNextUp;

  /// No description provided for @homeNextUpSummary.
  ///
  /// In en, this message translates to:
  /// **'{exercises} EXERCISES · ~{minutes} MIN'**
  String homeNextUpSummary(int exercises, int minutes);

  /// No description provided for @homeStartFreshSession.
  ///
  /// In en, this message translates to:
  /// **'Open session'**
  String get homeStartFreshSession;

  /// No description provided for @homeStartFreshHint.
  ///
  /// In en, this message translates to:
  /// **'Pick exercises as you go'**
  String get homeStartFreshHint;

  /// No description provided for @homeMetric7DayVolume.
  ///
  /// In en, this message translates to:
  /// **'7-DAY VOLUME'**
  String get homeMetric7DayVolume;

  /// No description provided for @homeMetricEst1RM.
  ///
  /// In en, this message translates to:
  /// **'EST 1RM'**
  String get homeMetricEst1RM;

  /// No description provided for @homeMetricBodyweight.
  ///
  /// In en, this message translates to:
  /// **'BODYWEIGHT'**
  String get homeMetricBodyweight;

  /// No description provided for @homeMetricSessions.
  ///
  /// In en, this message translates to:
  /// **'SESSIONS'**
  String get homeMetricSessions;

  /// No description provided for @homeUnitPerWeek.
  ///
  /// In en, this message translates to:
  /// **'/wk'**
  String get homeUnitPerWeek;

  /// No description provided for @homeUnitTons.
  ///
  /// In en, this message translates to:
  /// **'t'**
  String get homeUnitTons;

  /// No description provided for @homeRecent.
  ///
  /// In en, this message translates to:
  /// **'RECENT'**
  String get homeRecent;

  /// No description provided for @homeNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet — your last few will land here.'**
  String get homeNoRecent;

  /// No description provided for @logReadyToTrain.
  ///
  /// In en, this message translates to:
  /// **'Ready to train?'**
  String get logReadyToTrain;

  /// No description provided for @logStartHelp.
  ///
  /// In en, this message translates to:
  /// **'Start a session, add exercises, log your sets.'**
  String get logStartHelp;

  /// No description provided for @logNoTemplatesYet.
  ///
  /// In en, this message translates to:
  /// **'No templates yet. Create one in the Library tab.'**
  String get logNoTemplatesYet;

  /// No description provided for @logHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get logHeroEyebrow;

  /// No description provided for @logTemplatesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'QUICK START'**
  String get logTemplatesEyebrow;

  /// No description provided for @logNoTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'No templates yet'**
  String get logNoTemplatesTitle;

  /// No description provided for @logNoTemplatesHelp.
  ///
  /// In en, this message translates to:
  /// **'Save a routine in the Library to start it here in one tap.'**
  String get logNoTemplatesHelp;

  /// No description provided for @logCreateTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get logCreateTemplate;

  /// No description provided for @logRecapToday.
  ///
  /// In en, this message translates to:
  /// **'You already trained today.'**
  String get logRecapToday;

  /// No description provided for @logRecapYesterday.
  ///
  /// In en, this message translates to:
  /// **'Last session: yesterday.'**
  String get logRecapYesterday;

  /// No description provided for @logRecapDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Last session: {count} days ago.'**
  String logRecapDaysAgo(int count);

  /// No description provided for @addExerciseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Adding a new exercise'**
  String get addExerciseConfirmTitle;

  /// No description provided for @addExerciseConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you done with \"{name}\"? Tap Done to push it down and add the new one on top, or Keep going to stay on it.'**
  String addExerciseConfirmBody(Object name);

  /// No description provided for @addExerciseConfirmKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get addExerciseConfirmKeep;

  /// No description provided for @addExerciseConfirmDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get addExerciseConfirmDone;

  /// No description provided for @activeExerciseDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get activeExerciseDone;

  /// No description provided for @activeExerciseFinish.
  ///
  /// In en, this message translates to:
  /// **'Mark exercise finished'**
  String get activeExerciseFinish;

  /// No description provided for @activeExerciseReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen exercise'**
  String get activeExerciseReopen;

  /// No description provided for @restTimerMinutes.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get restTimerMinutes;

  /// No description provided for @restTimerSeconds.
  ///
  /// In en, this message translates to:
  /// **'SEC'**
  String get restTimerSeconds;

  /// No description provided for @notifRestTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest is up'**
  String get notifRestTitle;

  /// No description provided for @notifRestBody.
  ///
  /// In en, this message translates to:
  /// **'Time for the next set.'**
  String get notifRestBody;

  /// No description provided for @notifInactivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to train?'**
  String get notifInactivityTitle;

  /// No description provided for @notifInactivityBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s been a while — keep the streak alive.'**
  String get notifInactivityBody;

  /// No description provided for @activeTitle.
  ///
  /// In en, this message translates to:
  /// **'Active workout'**
  String get activeTitle;

  /// No description provided for @activeCancelWorkout.
  ///
  /// In en, this message translates to:
  /// **'Cancel workout?'**
  String get activeCancelWorkout;

  /// No description provided for @activeCancelHelp.
  ///
  /// In en, this message translates to:
  /// **'Logged sets will be discarded.'**
  String get activeCancelHelp;

  /// No description provided for @activeNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add exercise\" to begin.'**
  String get activeNothingYet;

  /// No description provided for @activeSavedSummary.
  ///
  /// In en, this message translates to:
  /// **'Saved: {sets} sets · {volume} total'**
  String activeSavedSummary(int sets, Object volume);

  /// No description provided for @finishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice workout!'**
  String get finishedTitle;

  /// No description provided for @finishedShareHint.
  ///
  /// In en, this message translates to:
  /// **'Share a card to celebrate, or just tap done.'**
  String get finishedShareHint;

  /// No description provided for @activeWorkoutAlreadyActive.
  ///
  /// In en, this message translates to:
  /// **'A workout is already active. Finish or discard it first.'**
  String get activeWorkoutAlreadyActive;

  /// No description provided for @activeExerciseCounter.
  ///
  /// In en, this message translates to:
  /// **'EXERCISE {current} OF {total}'**
  String activeExerciseCounter(int current, int total);

  /// No description provided for @activeProgressionPill.
  ///
  /// In en, this message translates to:
  /// **'+{amount} {unit}'**
  String activeProgressionPill(Object amount, Object unit);

  /// No description provided for @actionRestAdd15.
  ///
  /// In en, this message translates to:
  /// **'+15s'**
  String get actionRestAdd15;

  /// No description provided for @actionRestSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionRestSkip;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @activeUpNext.
  ///
  /// In en, this message translates to:
  /// **'UP NEXT'**
  String get activeUpNext;

  /// No description provided for @activeNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Last exercise — finish to wrap.'**
  String get activeNoUpcoming;

  /// No description provided for @activeNudgeFromYourTrend.
  ///
  /// In en, this message translates to:
  /// **'Volume in line with your recent average. Try {nudge} next session.'**
  String activeNudgeFromYourTrend(Object nudge);

  /// No description provided for @statExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get statExercises;

  /// No description provided for @statSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get statSets;

  /// No description provided for @statVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get statVolume;

  /// No description provided for @statDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get statDuration;

  /// No description provided for @statBest.
  ///
  /// In en, this message translates to:
  /// **'Best: {value}'**
  String statBest(Object value);

  /// No description provided for @statBestTopSet.
  ///
  /// In en, this message translates to:
  /// **'Best top set'**
  String get statBestTopSet;

  /// No description provided for @statEst1RM.
  ///
  /// In en, this message translates to:
  /// **'Est. 1RM'**
  String get statEst1RM;

  /// No description provided for @statBestVolume.
  ///
  /// In en, this message translates to:
  /// **'Best volume'**
  String get statBestVolume;

  /// No description provided for @statSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get statSessions;

  /// No description provided for @topSetWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Top set weight'**
  String get topSetWeightTitle;

  /// No description provided for @topSetWeightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{unit} per session'**
  String topSetWeightSubtitle(Object unit);

  /// No description provided for @totalVolumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Total volume per session'**
  String get totalVolumeTitle;

  /// No description provided for @totalVolumeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{unit} total'**
  String totalVolumeSubtitle(Object unit);

  /// No description provided for @totalVolumeCardio.
  ///
  /// In en, this message translates to:
  /// **'(weight × reps; usually 0 for cardio)'**
  String get totalVolumeCardio;

  /// No description provided for @noSetData.
  ///
  /// In en, this message translates to:
  /// **'No set data'**
  String get noSetData;

  /// No description provided for @sessionsLogged.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions logged'**
  String sessionsLogged(int count);

  /// No description provided for @perSessionLine.
  ///
  /// In en, this message translates to:
  /// **'{weight} × {reps}  ·  {volume} total'**
  String perSessionLine(Object weight, int reps, Object volume);

  /// No description provided for @volumeCardioLine.
  ///
  /// In en, this message translates to:
  /// **'{volume} volume'**
  String volumeCardioLine(Object volume);

  /// No description provided for @restingLabel.
  ///
  /// In en, this message translates to:
  /// **'Resting'**
  String get restingLabel;

  /// No description provided for @restTimerSection.
  ///
  /// In en, this message translates to:
  /// **'Rest timer'**
  String get restTimerSection;

  /// No description provided for @restTimerHelp.
  ///
  /// In en, this message translates to:
  /// **'Fires this long after each strength set.'**
  String get restTimerHelp;

  /// No description provided for @inactivityNudgeSection.
  ///
  /// In en, this message translates to:
  /// **'Inactivity nudge'**
  String get inactivityNudgeSection;

  /// No description provided for @inactivityNudgeHelp.
  ///
  /// In en, this message translates to:
  /// **'Reminds you if you haven\'t trained in a while. Off keeps the streak nudge silent.'**
  String get inactivityNudgeHelp;

  /// No description provided for @inactivityOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get inactivityOff;

  /// No description provided for @inactivityDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String inactivityDays(int count);

  /// No description provided for @logSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Log set'**
  String get logSetTitle;

  /// No description provided for @editSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit set'**
  String get editSetTitle;

  /// No description provided for @logSetHeader.
  ///
  /// In en, this message translates to:
  /// **'{action} · {exercise}'**
  String logSetHeader(Object action, Object exercise);

  /// No description provided for @fieldWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight ({unit})'**
  String fieldWeight(Object unit);

  /// No description provided for @fieldReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get fieldReps;

  /// No description provided for @fieldRir.
  ///
  /// In en, this message translates to:
  /// **'RIR (optional)'**
  String get fieldRir;

  /// No description provided for @fieldRirHelper.
  ///
  /// In en, this message translates to:
  /// **'Reps in reserve — how many you had left'**
  String get fieldRirHelper;

  /// No description provided for @fieldDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get fieldDistance;

  /// No description provided for @fieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (mm:ss or seconds)'**
  String get fieldDuration;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get fieldNotes;

  /// No description provided for @fieldNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get fieldNote;

  /// No description provided for @actionSaveSet.
  ///
  /// In en, this message translates to:
  /// **'Save set'**
  String get actionSaveSet;

  /// No description provided for @plateCalcTitle.
  ///
  /// In en, this message translates to:
  /// **'Plate calculator'**
  String get plateCalcTitle;

  /// No description provided for @plateCalcTotal.
  ///
  /// In en, this message translates to:
  /// **'Total weight ({unit})'**
  String plateCalcTotal(Object unit);

  /// No description provided for @plateCalcBar.
  ///
  /// In en, this message translates to:
  /// **'Bar ({unit})'**
  String plateCalcBar(Object unit);

  /// No description provided for @plateCalcPerSide.
  ///
  /// In en, this message translates to:
  /// **'Per side (largest first):'**
  String get plateCalcPerSide;

  /// No description provided for @plateCalcJustBar.
  ///
  /// In en, this message translates to:
  /// **'Just the bar.'**
  String get plateCalcJustBar;

  /// No description provided for @plateCalcNoPlates.
  ///
  /// In en, this message translates to:
  /// **'No plates needed.'**
  String get plateCalcNoPlates;

  /// No description provided for @plateCalcUnaccounted.
  ///
  /// In en, this message translates to:
  /// **'Unaccounted: {amount} {unit} (can\'t hit exactly with available plates).'**
  String plateCalcUnaccounted(Object amount, Object unit);

  /// No description provided for @calendarPrevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get calendarPrevMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get calendarNextMonth;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarLegendAm.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get calendarLegendAm;

  /// No description provided for @calendarLegendPm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get calendarLegendPm;

  /// No description provided for @calendarLegendEve.
  ///
  /// In en, this message translates to:
  /// **'EVE'**
  String get calendarLegendEve;

  /// No description provided for @calendarLegendNight.
  ///
  /// In en, this message translates to:
  /// **'NIGHT'**
  String get calendarLegendNight;

  /// No description provided for @calendarMonthSummary.
  ///
  /// In en, this message translates to:
  /// **'{days} days · {perWeek}/wk'**
  String calendarMonthSummary(int days, Object perWeek);

  /// No description provided for @calendarHeatmapLess.
  ///
  /// In en, this message translates to:
  /// **'LESS'**
  String get calendarHeatmapLess;

  /// No description provided for @calendarHeatmapMore.
  ///
  /// In en, this message translates to:
  /// **'MORE'**
  String get calendarHeatmapMore;

  /// No description provided for @calendarStatSets.
  ///
  /// In en, this message translates to:
  /// **'SETS'**
  String get calendarStatSets;

  /// No description provided for @calendarStatVolume.
  ///
  /// In en, this message translates to:
  /// **'VOLUME'**
  String get calendarStatVolume;

  /// No description provided for @calendarStatMax.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get calendarStatMax;

  /// No description provided for @calendarPickADay.
  ///
  /// In en, this message translates to:
  /// **'Pick a day above to see what you did.'**
  String get calendarPickADay;

  /// No description provided for @calendarNoSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'No workout that day'**
  String get calendarNoSessionTitle;

  /// No description provided for @calendarNoSessionBody.
  ///
  /// In en, this message translates to:
  /// **'You didn\'t gym on this day.'**
  String get calendarNoSessionBody;

  /// No description provided for @calendarOpenSession.
  ///
  /// In en, this message translates to:
  /// **'Open session'**
  String get calendarOpenSession;

  /// No description provided for @calendarViewMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get calendarViewMonthly;

  /// No description provided for @calendarViewYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get calendarViewYearly;

  /// No description provided for @calendarYearSummary.
  ///
  /// In en, this message translates to:
  /// **'{days} training days · {sessions} sessions'**
  String calendarYearSummary(int days, int sessions);

  /// No description provided for @calendarScopeCurrentMonth.
  ///
  /// In en, this message translates to:
  /// **'Current month'**
  String get calendarScopeCurrentMonth;

  /// No description provided for @calendarScopeCurrentYear.
  ///
  /// In en, this message translates to:
  /// **'Current year'**
  String get calendarScopeCurrentYear;

  /// No description provided for @calendarScopeAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get calendarScopeAllTime;

  /// No description provided for @calendarScopeChooserTitle.
  ///
  /// In en, this message translates to:
  /// **'Show sessions for…'**
  String get calendarScopeChooserTitle;

  /// No description provided for @calendarPrCallout.
  ///
  /// In en, this message translates to:
  /// **'★ NEW PR'**
  String get calendarPrCallout;

  /// No description provided for @calendarPrLine.
  ///
  /// In en, this message translates to:
  /// **'{exercise} · {weight} × {reps}'**
  String calendarPrLine(Object exercise, Object weight, int reps);

  /// No description provided for @daySheetSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String daySheetSessionsCount(int count);

  /// No description provided for @daySheetEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions on this day'**
  String get daySheetEmpty;

  /// No description provided for @daySheetEmptyHelp.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged on this day. Sessions you finish will land here automatically.'**
  String get daySheetEmptyHelp;

  /// No description provided for @daySheetTimeLine.
  ///
  /// In en, this message translates to:
  /// **'{part} · {time}'**
  String daySheetTimeLine(Object part, Object time);

  /// No description provided for @allSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'All sessions'**
  String get allSessionsTitle;

  /// No description provided for @allSessionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet — finish a workout from the Log tab.'**
  String get allSessionsEmpty;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this session?'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionHelp.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get deleteSessionHelp;

  /// No description provided for @deleteSessionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get deleteSessionTooltip;

  /// No description provided for @sessionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session details'**
  String get sessionDetailsTitle;

  /// No description provided for @sessionName.
  ///
  /// In en, this message translates to:
  /// **'Workout name (optional)'**
  String get sessionName;

  /// No description provided for @sessionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Leg Day, AM Push'**
  String get sessionNameHint;

  /// No description provided for @sessionPlace.
  ///
  /// In en, this message translates to:
  /// **'Place / gym (optional)'**
  String get sessionPlace;

  /// No description provided for @sessionMoodPrompt.
  ///
  /// In en, this message translates to:
  /// **'How did it feel?'**
  String get sessionMoodPrompt;

  /// No description provided for @sessionWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get sessionWeather;

  /// No description provided for @sessionFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends trained with (optional)'**
  String get sessionFriends;

  /// No description provided for @sessionFriendsHelper.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated names'**
  String get sessionFriendsHelper;

  /// No description provided for @sessionDetailEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exercises in this session. Tap \"Add exercise\" below.'**
  String get sessionDetailEmpty;

  /// No description provided for @shareCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Share card'**
  String get shareCardTitle;

  /// No description provided for @shareCardShareToApps.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareCardShareToApps;

  /// No description provided for @shareCardSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get shareCardSave;

  /// No description provided for @shareCardSessionPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Or share a moment from this session'**
  String get shareCardSessionPhotosTitle;

  /// No description provided for @shareCardNoSessionPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos yet on this workout. Take one now and share it.'**
  String get shareCardNoSessionPhotos;

  /// No description provided for @shareCardTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get shareCardTakePhoto;

  /// No description provided for @shareCardSharePhoto.
  ///
  /// In en, this message translates to:
  /// **'Share photo'**
  String get shareCardSharePhoto;

  /// No description provided for @shareCardShareCaption.
  ///
  /// In en, this message translates to:
  /// **'Logged on ChillGym'**
  String get shareCardShareCaption;

  /// No description provided for @shareCardShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the share sheet: {error}'**
  String shareCardShareFailed(Object error);

  /// No description provided for @moodStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get moodStrong;

  /// No description provided for @moodNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get moodNormal;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTired;

  /// No description provided for @moodSick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get moodSick;

  /// No description provided for @weatherSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get weatherSunny;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherRainy;

  /// No description provided for @weatherSnowy.
  ///
  /// In en, this message translates to:
  /// **'Snowy'**
  String get weatherSnowy;

  /// No description provided for @weatherHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get weatherHot;

  /// No description provided for @weatherCold.
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get weatherCold;

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get muscleBiceps;

  /// No description provided for @muscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get muscleTriceps;

  /// No description provided for @muscleForearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get muscleForearms;

  /// No description provided for @muscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @muscleQuads.
  ///
  /// In en, this message translates to:
  /// **'Quads'**
  String get muscleQuads;

  /// No description provided for @muscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get muscleHamstrings;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get muscleFullBody;

  /// No description provided for @muscleCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get muscleCardio;

  /// No description provided for @kindStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get kindStrength;

  /// No description provided for @kindCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get kindCardio;

  /// No description provided for @equipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipmentLabel;

  /// No description provided for @equipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get equipmentBarbell;

  /// No description provided for @equipmentDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get equipmentDumbbell;

  /// No description provided for @equipmentMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get equipmentMachine;

  /// No description provided for @equipmentCable.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get equipmentCable;

  /// No description provided for @equipmentBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get equipmentBodyweight;

  /// No description provided for @equipmentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get equipmentOther;

  /// No description provided for @feedbackNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough'**
  String get feedbackNotEnough;

  /// No description provided for @feedbackOneMoreSet.
  ///
  /// In en, this message translates to:
  /// **'One more set'**
  String get feedbackOneMoreSet;

  /// No description provided for @feedbackGood.
  ///
  /// In en, this message translates to:
  /// **'That\'s good'**
  String get feedbackGood;

  /// No description provided for @feedbackEnough.
  ///
  /// In en, this message translates to:
  /// **'Enough — rest this muscle'**
  String get feedbackEnough;

  /// No description provided for @feedbackEnoughBySetCount.
  ///
  /// In en, this message translates to:
  /// **'You\'ve done {count} sets — extra volume here is unlikely to add growth. Move to another muscle.'**
  String feedbackEnoughBySetCount(int count);

  /// No description provided for @feedbackEnoughByRatio.
  ///
  /// In en, this message translates to:
  /// **'Volume is well past the typical target for this exercise. Save energy for the rest of your session.'**
  String get feedbackEnoughByRatio;

  /// No description provided for @feedbackOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track with your recent average.'**
  String get feedbackOnTrack;

  /// No description provided for @feedbackAboveTarget.
  ///
  /// In en, this message translates to:
  /// **'Above the typical {level} target.'**
  String feedbackAboveTarget(Object level);

  /// No description provided for @feedbackCloseAvg.
  ///
  /// In en, this message translates to:
  /// **'Close to your recent average — one more set tips it over.'**
  String get feedbackCloseAvg;

  /// No description provided for @feedbackAlmostTarget.
  ///
  /// In en, this message translates to:
  /// **'Almost at the typical {level} target.'**
  String feedbackAlmostTarget(Object level);

  /// No description provided for @feedbackBelowAvg.
  ///
  /// In en, this message translates to:
  /// **'Below your recent average for this exercise.'**
  String get feedbackBelowAvg;

  /// No description provided for @feedbackBelowTarget.
  ///
  /// In en, this message translates to:
  /// **'Below the typical {level} target.'**
  String feedbackBelowTarget(Object level);

  /// No description provided for @expBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get expBeginner;

  /// No description provided for @expIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get expIntermediate;

  /// No description provided for @expAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get expAdvanced;

  /// No description provided for @libraryExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get libraryExercises;

  /// No description provided for @libraryTemplates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get libraryTemplates;

  /// No description provided for @librarySearch.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get librarySearch;

  /// No description provided for @libraryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get libraryFilterAll;

  /// No description provided for @libraryNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No exercises match.'**
  String get libraryNoMatch;

  /// No description provided for @libraryNewExercise.
  ///
  /// In en, this message translates to:
  /// **'New exercise'**
  String get libraryNewExercise;

  /// No description provided for @libraryEditExercise.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get libraryEditExercise;

  /// No description provided for @libraryNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'New template'**
  String get libraryNewTemplate;

  /// No description provided for @libraryEditTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit template'**
  String get libraryEditTemplate;

  /// No description provided for @libraryNoTemplatesYet.
  ///
  /// In en, this message translates to:
  /// **'No templates yet.'**
  String get libraryNoTemplatesYet;

  /// No description provided for @libraryCreateOne.
  ///
  /// In en, this message translates to:
  /// **'Create one to start a workout in one tap.'**
  String get libraryCreateOne;

  /// No description provided for @libraryDeleteExercisePrompt.
  ///
  /// In en, this message translates to:
  /// **'Delete this exercise?'**
  String get libraryDeleteExercisePrompt;

  /// No description provided for @libraryDeleteExerciseHelp.
  ///
  /// In en, this message translates to:
  /// **'Past sessions that reference it will keep their data.'**
  String get libraryDeleteExerciseHelp;

  /// No description provided for @libraryDeleteTemplatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String libraryDeleteTemplatePrompt(Object name);

  /// No description provided for @libraryExerciseName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get libraryExerciseName;

  /// No description provided for @libraryExerciseType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get libraryExerciseType;

  /// No description provided for @libraryPrimaryMuscle.
  ///
  /// In en, this message translates to:
  /// **'Primary muscle'**
  String get libraryPrimaryMuscle;

  /// No description provided for @librarySecondaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Secondary muscles (optional)'**
  String get librarySecondaryMuscles;

  /// No description provided for @libraryTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get libraryTemplateName;

  /// No description provided for @libraryTemplateNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Push Day'**
  String get libraryTemplateNameHint;

  /// No description provided for @libraryTemplateExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get libraryTemplateExercises;

  /// No description provided for @libraryNoExercisesYet.
  ///
  /// In en, this message translates to:
  /// **'No exercises added yet.'**
  String get libraryNoExercisesYet;

  /// No description provided for @libraryExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String libraryExerciseCount(int count);

  /// No description provided for @libraryPickExercise.
  ///
  /// In en, this message translates to:
  /// **'Pick exercise'**
  String get libraryPickExercise;

  /// No description provided for @progressNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing to chart yet.'**
  String get progressNothingYet;

  /// No description provided for @progressLogMore.
  ///
  /// In en, this message translates to:
  /// **'Log a few sessions and your trends will appear here.'**
  String get progressLogMore;

  /// No description provided for @progressByExercise.
  ///
  /// In en, this message translates to:
  /// **'By exercise'**
  String get progressByExercise;

  /// No description provided for @progressByMuscle.
  ///
  /// In en, this message translates to:
  /// **'By muscle'**
  String get progressByMuscle;

  /// No description provided for @progressLifts.
  ///
  /// In en, this message translates to:
  /// **'Lifts'**
  String get progressLifts;

  /// No description provided for @progressBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get progressBody;

  /// No description provided for @progressDayChanges.
  ///
  /// In en, this message translates to:
  /// **'Day Changes'**
  String get progressDayChanges;

  /// No description provided for @progressBodyweightTitle.
  ///
  /// In en, this message translates to:
  /// **'BODYWEIGHT'**
  String get progressBodyweightTitle;

  /// No description provided for @progressBodyweightEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log a bodyweight in Profile to start the trend.'**
  String get progressBodyweightEmpty;

  /// No description provided for @progressBodyweightDelta7.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} vs 7 days ago'**
  String progressBodyweightDelta7(Object amount, Object unit);

  /// No description provided for @bodyweightStatMin.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get bodyweightStatMin;

  /// No description provided for @bodyweightStatMax.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get bodyweightStatMax;

  /// No description provided for @bodyweightStatAvg.
  ///
  /// In en, this message translates to:
  /// **'AVG'**
  String get bodyweightStatAvg;

  /// No description provided for @bodyweightStatRange.
  ///
  /// In en, this message translates to:
  /// **'RANGE'**
  String get bodyweightStatRange;

  /// No description provided for @bodyweightTrendUp.
  ///
  /// In en, this message translates to:
  /// **'Trending up — {amount} {unit} over {days} days'**
  String bodyweightTrendUp(Object amount, Object unit, int days);

  /// No description provided for @bodyweightTrendDown.
  ///
  /// In en, this message translates to:
  /// **'Trending down — {amount} {unit} over {days} days'**
  String bodyweightTrendDown(Object amount, Object unit, int days);

  /// No description provided for @bodyweightTrendFlat.
  ///
  /// In en, this message translates to:
  /// **'Holding steady — {days} days logged'**
  String bodyweightTrendFlat(int days);

  /// No description provided for @progressFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured lift'**
  String get progressFeatured;

  /// No description provided for @progressDeltaUp.
  ///
  /// In en, this message translates to:
  /// **'↑ {amount}'**
  String progressDeltaUp(Object amount);

  /// No description provided for @progressDeltaDown.
  ///
  /// In en, this message translates to:
  /// **'↓ {amount}'**
  String progressDeltaDown(Object amount);

  /// No description provided for @progressDeltaFlat.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get progressDeltaFlat;

  /// No description provided for @progressPersonalBests.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL BESTS'**
  String get progressPersonalBests;

  /// No description provided for @progressPrNewBadge.
  ///
  /// In en, this message translates to:
  /// **'★ NEW'**
  String get progressPrNewBadge;

  /// No description provided for @progressNoLiftYet.
  ///
  /// In en, this message translates to:
  /// **'Log a strength set to start a chart.'**
  String get progressNoLiftYet;

  /// No description provided for @progressPickLift.
  ///
  /// In en, this message translates to:
  /// **'Pick a lift'**
  String get progressPickLift;

  /// No description provided for @progressRange1M.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get progressRange1M;

  /// No description provided for @progressRange3M.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get progressRange3M;

  /// No description provided for @progressRange6M.
  ///
  /// In en, this message translates to:
  /// **'6M'**
  String get progressRange6M;

  /// No description provided for @progressRange1Y.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get progressRange1Y;

  /// No description provided for @progressRangeAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get progressRangeAll;

  /// No description provided for @progressByMuscleHelp.
  ///
  /// In en, this message translates to:
  /// **'Tap a body part to dig in. Brighter = more recent volume.'**
  String get progressByMuscleHelp;

  /// No description provided for @bodyDiagramLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get bodyDiagramLow;

  /// No description provided for @bodyDiagramHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get bodyDiagramHigh;

  /// No description provided for @muscleNoVolumeYet.
  ///
  /// In en, this message translates to:
  /// **'No strength volume logged for this muscle yet.'**
  String get muscleNoVolumeYet;

  /// No description provided for @muscleRecentVolume.
  ///
  /// In en, this message translates to:
  /// **'Last 4 weeks'**
  String get muscleRecentVolume;

  /// No description provided for @muscleAllTimeVolume.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get muscleAllTimeVolume;

  /// No description provided for @muscleWeeklyVolume.
  ///
  /// In en, this message translates to:
  /// **'Weekly volume'**
  String get muscleWeeklyVolume;

  /// No description provided for @muscleWeeklyHelp.
  ///
  /// In en, this message translates to:
  /// **'Sum of weight × reps over the last 12 weeks.'**
  String get muscleWeeklyHelp;

  /// No description provided for @muscleExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get muscleExercises;

  /// No description provided for @muscleNoExercisesYet.
  ///
  /// In en, this message translates to:
  /// **'No exercises logged for this muscle group yet.'**
  String get muscleNoExercisesYet;

  /// No description provided for @profileSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get profileSectionAbout;

  /// No description provided for @profileSectionTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get profileSectionTraining;

  /// No description provided for @profileSectionUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get profileSectionUnits;

  /// No description provided for @profileSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileSectionLanguage;

  /// No description provided for @profileSectionTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileSectionTheme;

  /// No description provided for @profileThemeHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose between Warm Editorial (light) and Dark Performance (dark), or follow your phone\'s setting.'**
  String get profileThemeHelp;

  /// No description provided for @profileThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profileThemeSystem;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileSectionBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get profileSectionBodyweight;

  /// No description provided for @profileSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileSectionNotifications;

  /// No description provided for @profileSectionIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get profileSectionIntegrations;

  /// No description provided for @profileSectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get profileSectionData;

  /// No description provided for @profileSectionAbout2.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileSectionAbout2;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get profileName;

  /// No description provided for @profileGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get profileGoal;

  /// No description provided for @profileGoalHelp.
  ///
  /// In en, this message translates to:
  /// **'Used in summaries and feedback rationale.'**
  String get profileGoalHelp;

  /// No description provided for @profileGoalStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get profileGoalStrength;

  /// No description provided for @profileGoalMuscle.
  ///
  /// In en, this message translates to:
  /// **'Muscle / size'**
  String get profileGoalMuscle;

  /// No description provided for @profileGoalGeneral.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get profileGoalGeneral;

  /// No description provided for @profileGoalEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get profileGoalEndurance;

  /// No description provided for @profileGoalWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Weight loss'**
  String get profileGoalWeightLoss;

  /// No description provided for @profileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height ({unit})'**
  String profileHeight(Object unit);

  /// No description provided for @profileExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience level'**
  String get profileExperience;

  /// No description provided for @profileExperienceHelp.
  ///
  /// In en, this message translates to:
  /// **'Used to size your \"Not enough / One more set\" targets until you have your own history.'**
  String get profileExperienceHelp;

  /// No description provided for @profileShowRir.
  ///
  /// In en, this message translates to:
  /// **'Show RIR field'**
  String get profileShowRir;

  /// No description provided for @profileShowRirHelp.
  ///
  /// In en, this message translates to:
  /// **'Reps in reserve prompt on the set sheet.'**
  String get profileShowRirHelp;

  /// No description provided for @profileWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get profileWeightLabel;

  /// No description provided for @profileHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileHeightLabel;

  /// No description provided for @profileUnitsHelp.
  ///
  /// In en, this message translates to:
  /// **'Switching only changes how weights are shown and entered. Existing data is converted on the fly.'**
  String get profileUnitsHelp;

  /// No description provided for @profileLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app should be displayed.'**
  String get profileLanguageHelp;

  /// No description provided for @profileLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profileLanguageSystem;

  /// No description provided for @profileLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profileLanguageEnglish;

  /// No description provided for @profileLanguageZhHK.
  ///
  /// In en, this message translates to:
  /// **'繁體中文 (香港)'**
  String get profileLanguageZhHK;

  /// No description provided for @profileHealth.
  ///
  /// In en, this message translates to:
  /// **'Health integration'**
  String get profileHealth;

  /// No description provided for @profileHealthOnMobile.
  ///
  /// In en, this message translates to:
  /// **'Workouts will be written to Apple Health / Health Connect.'**
  String get profileHealthOnMobile;

  /// No description provided for @profileHealthOff.
  ///
  /// In en, this message translates to:
  /// **'Off — toggle on to write workouts to your phone\'s health app.'**
  String get profileHealthOff;

  /// No description provided for @profileHealthWeb.
  ///
  /// In en, this message translates to:
  /// **'Not supported on web — toggle works on iOS / Android.'**
  String get profileHealthWeb;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'Rest-timer end and inactivity nudge are on.'**
  String get profileNotificationsOn;

  /// No description provided for @profileNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Off — toggle on for rest-timer and nudge alerts.'**
  String get profileNotificationsOff;

  /// No description provided for @profileNotificationsWeb.
  ///
  /// In en, this message translates to:
  /// **'Not supported on web — wires up on iOS / Android.'**
  String get profileNotificationsWeb;

  /// No description provided for @profileNotificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied — enable notifications in system settings.'**
  String get profileNotificationsDenied;

  /// No description provided for @profileVersionLine.
  ///
  /// In en, this message translates to:
  /// **'v0.1.0 · Phase 1 (MVP) — pre-SSO build'**
  String get profileVersionLine;

  /// No description provided for @profileSignInSoon.
  ///
  /// In en, this message translates to:
  /// **'Sign-in coming soon'**
  String get profileSignInSoon;

  /// No description provided for @profileSignInSoonHelp.
  ///
  /// In en, this message translates to:
  /// **'Account, sync, and SSO will be added at the end of Phase 1.'**
  String get profileSignInSoonHelp;

  /// No description provided for @bodyweightLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get bodyweightLatest;

  /// No description provided for @bodyweightInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight ({unit})'**
  String bodyweightInputLabel(Object unit);

  /// No description provided for @bodyweightLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log bodyweight'**
  String get bodyweightLogTitle;

  /// No description provided for @bodyweightEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit bodyweight'**
  String get bodyweightEditTitle;

  /// No description provided for @bodyweightEmptyHelp.
  ///
  /// In en, this message translates to:
  /// **'No bodyweight entries yet. Tap \"Log weight\" to add one.'**
  String get bodyweightEmptyHelp;

  /// No description provided for @dataExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get dataExportJson;

  /// No description provided for @dataExportJsonHelp.
  ///
  /// In en, this message translates to:
  /// **'Full backup. Round-trips via Import.'**
  String get dataExportJsonHelp;

  /// No description provided for @dataExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export sets as CSV'**
  String get dataExportCsv;

  /// No description provided for @dataExportCsvHelp.
  ///
  /// In en, this message translates to:
  /// **'One row per set, for spreadsheets.'**
  String get dataExportCsvHelp;

  /// No description provided for @dataImport.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get dataImport;

  /// No description provided for @dataImportHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste a previously exported JSON. Replaces existing data.'**
  String get dataImportHelp;

  /// No description provided for @dataDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get dataDeleteAll;

  /// No description provided for @dataDeleteAllHelp.
  ///
  /// In en, this message translates to:
  /// **'Wipes everything stored on this device. Irreversible.'**
  String get dataDeleteAllHelp;

  /// No description provided for @dataDeleteAllPrompt.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get dataDeleteAllPrompt;

  /// No description provided for @dataDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'This wipes every session, template, custom exercise, bodyweight entry, and preference on this device. It cannot be undone.'**
  String get dataDeleteAllConfirm;

  /// No description provided for @dataAllDeleted.
  ///
  /// In en, this message translates to:
  /// **'All data deleted.'**
  String get dataAllDeleted;

  /// No description provided for @dataExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String dataExportFailed(Object error);

  /// No description provided for @dataImportComplete.
  ///
  /// In en, this message translates to:
  /// **'Import complete.'**
  String get dataImportComplete;

  /// No description provided for @dataImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String dataImportFailed(Object error);

  /// No description provided for @dataDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded.'**
  String get dataDownloaded;

  /// No description provided for @dataSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to: {path}'**
  String dataSavedTo(Object path);

  /// No description provided for @dataBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup JSON'**
  String get dataBackupTitle;

  /// No description provided for @dataImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get dataImportTitle;

  /// No description provided for @dataImportWarning.
  ///
  /// In en, this message translates to:
  /// **'Existing data will be replaced. This cannot be undone.'**
  String get dataImportWarning;

  /// No description provided for @dataImportHint.
  ///
  /// In en, this message translates to:
  /// **'Paste backup JSON here…'**
  String get dataImportHint;

  /// No description provided for @dataCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard.'**
  String get dataCopied;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String loadFailed(Object error);

  /// No description provided for @genericFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String genericFailed(Object error);

  /// No description provided for @bodyPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Body progress'**
  String get bodyPhotosTitle;

  /// No description provided for @bodyPhotosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No body photos yet.'**
  String get bodyPhotosEmpty;

  /// No description provided for @bodyPhotosEmptyHelp.
  ///
  /// In en, this message translates to:
  /// **'Add a photo every week or two; the timeline lets you replay your progress like a flipbook.'**
  String get bodyPhotosEmptyHelp;

  /// No description provided for @bodyPhotosAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get bodyPhotosAdd;

  /// No description provided for @bodyPhotosAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New body photo'**
  String get bodyPhotosAddTitle;

  /// No description provided for @bodyPhotosEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit body photo'**
  String get bodyPhotosEditTitle;

  /// No description provided for @bodyPhotosDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bodyPhotosDate;

  /// No description provided for @bodyPhotosNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional note (e.g. cut start, vacation)'**
  String get bodyPhotosNoteHint;

  /// No description provided for @bodyPhotosWeightOptional.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight ({unit}, optional)'**
  String bodyPhotosWeightOptional(Object unit);

  /// No description provided for @bodyPhotosCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String bodyPhotosCount(int count);

  /// No description provided for @bodyPhotosPlay.
  ///
  /// In en, this message translates to:
  /// **'Play timeline'**
  String get bodyPhotosPlay;

  /// No description provided for @bodyPhotosPlayHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to pause · swipe to scrub'**
  String get bodyPhotosPlayHint;

  /// No description provided for @bodyPhotosNeedTwo.
  ///
  /// In en, this message translates to:
  /// **'Add at least two photos to play the timeline.'**
  String get bodyPhotosNeedTwo;

  /// No description provided for @bodyPhotosDeletePrompt.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo?'**
  String get bodyPhotosDeletePrompt;

  /// No description provided for @bodyPhotosTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress timeline'**
  String get bodyPhotosTimelineTitle;

  /// No description provided for @bodyPhotosSlideRate.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get bodyPhotosSlideRate;

  /// No description provided for @bodyPhotosSlideRateSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get bodyPhotosSlideRateSlow;

  /// No description provided for @bodyPhotosSlideRateNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get bodyPhotosSlideRateNormal;

  /// No description provided for @bodyPhotosSlideRateFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get bodyPhotosSlideRateFast;

  /// No description provided for @bodyPhotosQuotaError.
  ///
  /// In en, this message translates to:
  /// **'Browser storage is full — body photos are kept in localStorage which only allows ~5MB. Delete a few older photos and try again, or export your data and run this on the mobile app where there\'s no quota.'**
  String get bodyPhotosQuotaError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'HK':
            return AppLocalizationsZhHk();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
