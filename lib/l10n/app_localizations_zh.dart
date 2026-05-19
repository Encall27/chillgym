// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'ChillGym';

  @override
  String get appTagline => '出席。舉鐵。再來。';

  @override
  String get navHome => '主頁';

  @override
  String get navLog => '記錄';

  @override
  String get navProgress => '進度';

  @override
  String get navCalendar => '日曆';

  @override
  String get navLibrary => '動作庫';

  @override
  String get navProfile => '個人';

  @override
  String get navSettings => '設定';

  @override
  String get navBody => '身體紀錄';

  @override
  String get actionHome => '主頁';

  @override
  String get actionSave => '儲存';

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '刪除';

  @override
  String get actionRemove => '移除';

  @override
  String get actionEdit => '編輯';

  @override
  String get actionUpdate => '更新';

  @override
  String get actionClose => '關閉';

  @override
  String get actionImport => '匯入';

  @override
  String get actionPaste => '貼上';

  @override
  String get actionCopy => '複製';

  @override
  String get actionFinish => '完成';

  @override
  String get actionDone => '完成';

  @override
  String get actionShare => '分享';

  @override
  String get actionDiscard => '捨棄';

  @override
  String get actionKeepGoing => '繼續';

  @override
  String get actionDeleteEverything => '全部刪除';

  @override
  String get actionStartWorkout => '開始訓練';

  @override
  String get actionResumeWorkout => '繼續訓練';

  @override
  String get actionStartFromTemplate => '由範本開始';

  @override
  String get actionAddExercise => '加入動作';

  @override
  String get actionAddSet => '加入一組';

  @override
  String get actionRepeatSet => '重複上一組';

  @override
  String get actionShowAll => '顯示全部';

  @override
  String actionViewAllSessions(int count) {
    return '查看全部訓練 ($count)';
  }

  @override
  String actionUseLast(int count) {
    return '套用上次（$count 組）';
  }

  @override
  String get actionRemoveExercise => '移除動作';

  @override
  String get actionRemovePhoto => '移除相片？';

  @override
  String get actionTakePhoto => '拍照';

  @override
  String get actionChooseFromGallery => '從相簿選擇';

  @override
  String get actionTakeOrChoosePhoto => '拍照或從相簿選取';

  @override
  String get actionLogWeight => '記錄體重';

  @override
  String get actionUseThisWeight => '使用此重量';

  @override
  String get homeGreetingMorning => '早晨';

  @override
  String get homeGreetingAfternoon => '午安';

  @override
  String get homeGreetingEvening => '夜晚好';

  @override
  String get homeGreetingLate => '夜深了';

  @override
  String homeGreetingWithName(Object greeting, Object name) {
    return '$greeting，$name。';
  }

  @override
  String homeGreetingNoName(Object greeting) {
    return '$greeting。';
  }

  @override
  String get streakCurrent => '目前連續';

  @override
  String get streakLongest => '最長';

  @override
  String get streakThisMonth => '本月';

  @override
  String streakDayUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '日',
      one: '日',
    );
    return '$_temp0';
  }

  @override
  String streakSessionUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '次訓練',
      one: '次訓練',
    );
    return '$_temp0';
  }

  @override
  String get homeNoSessionsYet => '還未有訓練紀錄 — 準備好就開始一節吧。';

  @override
  String get homeTrainedToday => '今日已經訓練過了。';

  @override
  String get homeYesterdayLast => '昨日是你最近一次訓練。';

  @override
  String homeDaysSinceLast(int count) {
    return '距離上次訓練已過 $count 日。';
  }

  @override
  String homeStartFromTemplateNamed(Object name) {
    return '由「$name」開始';
  }

  @override
  String get homeRecentSessions => '近期訓練';

  @override
  String get homeBodyweight => '體重';

  @override
  String get homeNoBodyweightYet => '尚未有體重紀錄';

  @override
  String get homeTapToLogInProfile => '在「個人」中加入紀錄。';

  @override
  String get homeOnFire => '連勝中';

  @override
  String homeStreakSummary(int count) {
    return '連續 $count 日';
  }

  @override
  String homeFromRecord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '距離紀錄還差 $count 日',
      one: '距離紀錄還差 1 日',
    );
    return '$_temp0';
  }

  @override
  String get homeRecordTied => '已追平你的紀錄。';

  @override
  String get homeRecordSet => '新個人紀錄！';

  @override
  String get homeNextUp => '下一節';

  @override
  String homeNextUpSummary(int exercises, int minutes) {
    return '$exercises 個動作 · 約 $minutes 分鐘';
  }

  @override
  String get homeStartFreshSession => '自由訓練';

  @override
  String get homeStartFreshHint => '邊練邊加動作';

  @override
  String get homeMetric7DayVolume => '7 日訓練量';

  @override
  String get homeMetricEst1RM => '估算 1RM';

  @override
  String get homeMetricBodyweight => '體重';

  @override
  String get homeMetricSessions => '訓練次數';

  @override
  String get homeUnitPerWeek => '/週';

  @override
  String get homeUnitTons => '公噸';

  @override
  String get homeRecent => '近期';

  @override
  String get homeNoRecent => '還未有訓練紀錄 — 完成幾節後會在這裡看到。';

  @override
  String get logReadyToTrain => '準備好訓練了嗎？';

  @override
  String get logStartHelp => '開始一節訓練、加入動作、記錄每組數字。';

  @override
  String get logNoTemplatesYet => '尚未有範本，先去「動作庫」建立一個。';

  @override
  String get logHeroEyebrow => '今天';

  @override
  String get logTemplatesEyebrow => '快速開始';

  @override
  String get logNoTemplatesTitle => '尚未有範本';

  @override
  String get logNoTemplatesHelp => '在動作庫儲存一套訓練，這裡一按即用。';

  @override
  String get logCreateTemplate => '建立';

  @override
  String get logRecapToday => '你今天已經訓練了。';

  @override
  String get logRecapYesterday => '上次訓練：昨天。';

  @override
  String logRecapDaysAgo(int count) {
    return '上次訓練：$count 天前。';
  }

  @override
  String get addExerciseConfirmTitle => '加入新動作';

  @override
  String addExerciseConfirmBody(Object name) {
    return '「$name」做完了嗎？選「完成」會把它收到下面、把新動作放到頂；選「繼續」就留在原來那一個。';
  }

  @override
  String get addExerciseConfirmKeep => '繼續';

  @override
  String get addExerciseConfirmDone => '完成';

  @override
  String get activeExerciseDone => '完成';

  @override
  String get activeExerciseFinish => '標記為完成';

  @override
  String get activeExerciseReopen => '重新打開';

  @override
  String get restTimerMinutes => '分';

  @override
  String get restTimerSeconds => '秒';

  @override
  String get notifRestTitle => '休息結束';

  @override
  String get notifRestBody => '可以做下一組了。';

  @override
  String get notifInactivityTitle => '去訓練吧？';

  @override
  String get notifInactivityBody => '好一陣子沒練了 — 別斷連勝。';

  @override
  String get activeTitle => '進行中的訓練';

  @override
  String get activeCancelWorkout => '取消這次訓練？';

  @override
  String get activeCancelHelp => '已記錄的組數會一併清除。';

  @override
  String get activeNothingYet => '點選「加入動作」開始。';

  @override
  String activeSavedSummary(int sets, Object volume) {
    return '已儲存：$sets 組 · 共 $volume';
  }

  @override
  String get finishedTitle => '今日做得好！';

  @override
  String get finishedShareHint => '分享一張卡片，或直接完成。';

  @override
  String get activeWorkoutAlreadyActive => '已有訓練進行中，先完成或取消才能再開。';

  @override
  String activeExerciseCounter(int current, int total) {
    return '動作 $current / $total';
  }

  @override
  String activeProgressionPill(Object amount, Object unit) {
    return '+$amount $unit';
  }

  @override
  String get actionRestAdd15 => '+15 秒';

  @override
  String get actionRestSkip => '略過';

  @override
  String get actionNext => '下一個';

  @override
  String get activeUpNext => '下一個';

  @override
  String get activeNoUpcoming => '最後一個動作 — 完成後就可以收工。';

  @override
  String activeNudgeFromYourTrend(Object nudge) {
    return '訓練量與你近期平均一致，下次可以試試 $nudge。';
  }

  @override
  String get statExercises => '動作';

  @override
  String get statSets => '組數';

  @override
  String get statVolume => '總量';

  @override
  String get statDuration => '時間';

  @override
  String statBest(Object value) {
    return '最佳：$value';
  }

  @override
  String get statBestTopSet => '最佳重組';

  @override
  String get statEst1RM => '估算 1RM';

  @override
  String get statBestVolume => '最佳訓練量';

  @override
  String get statSessions => '訓練次數';

  @override
  String get topSetWeightTitle => '最重那一組';

  @override
  String topSetWeightSubtitle(Object unit) {
    return '每節 $unit';
  }

  @override
  String get totalVolumeTitle => '每節總訓練量';

  @override
  String totalVolumeSubtitle(Object unit) {
    return '$unit 總計';
  }

  @override
  String get totalVolumeCardio => '（重量 × 次數，帶氧通常為 0）';

  @override
  String get noSetData => '尚無組數資料';

  @override
  String sessionsLogged(int count) {
    return '已記錄 $count 節訓練';
  }

  @override
  String perSessionLine(Object weight, int reps, Object volume) {
    return '$weight × $reps  ·  總計 $volume';
  }

  @override
  String volumeCardioLine(Object volume) {
    return '總量 $volume';
  }

  @override
  String get restingLabel => '休息中';

  @override
  String get restTimerSection => '休息計時器';

  @override
  String get restTimerHelp => '每組力量訓練後等候此時間後提示。';

  @override
  String get inactivityNudgeSection => '懶人提醒';

  @override
  String get inactivityNudgeHelp => '如果一段時間沒有訓練就會提醒你。關閉就不會打擾你。';

  @override
  String get inactivityOff => '關閉';

  @override
  String inactivityDays(int count) {
    return '$count 日';
  }

  @override
  String get logSetTitle => '記錄組';

  @override
  String get editSetTitle => '編輯組';

  @override
  String logSetHeader(Object action, Object exercise) {
    return '$action · $exercise';
  }

  @override
  String fieldWeight(Object unit) {
    return '重量（$unit）';
  }

  @override
  String get fieldReps => '次數';

  @override
  String get fieldRir => 'RIR（選填）';

  @override
  String get fieldRirHelper => '保留次數 — 還可以再做幾下';

  @override
  String get fieldDistance => '距離（公里）';

  @override
  String get fieldDuration => '時間（分:秒 或 秒數）';

  @override
  String get fieldNotes => '備註（選填）';

  @override
  String get fieldNote => '備註（選填）';

  @override
  String get actionSaveSet => '儲存組數';

  @override
  String get plateCalcTitle => '計算槓片';

  @override
  String plateCalcTotal(Object unit) {
    return '總重量（$unit）';
  }

  @override
  String plateCalcBar(Object unit) {
    return '槓鈴（$unit）';
  }

  @override
  String get plateCalcPerSide => '每邊（由大到細）：';

  @override
  String get plateCalcJustBar => '只用槓鈴。';

  @override
  String get plateCalcNoPlates => '毋須加片。';

  @override
  String plateCalcUnaccounted(Object amount, Object unit) {
    return '尚欠：$amount $unit（現有槓片無法剛好湊出此重量）。';
  }

  @override
  String get calendarPrevMonth => '上個月';

  @override
  String get calendarNextMonth => '下個月';

  @override
  String get calendarToday => '今日';

  @override
  String get calendarLegendAm => '上午';

  @override
  String get calendarLegendPm => '下午';

  @override
  String get calendarLegendEve => '傍晚';

  @override
  String get calendarLegendNight => '夜晚';

  @override
  String calendarMonthSummary(int days, Object perWeek) {
    return '$days 日 · 每週 $perWeek 次';
  }

  @override
  String get calendarHeatmapLess => '少';

  @override
  String get calendarHeatmapMore => '多';

  @override
  String get calendarStatSets => '組數';

  @override
  String get calendarStatVolume => '訓練量';

  @override
  String get calendarStatMax => '最重';

  @override
  String get calendarPickADay => '點按上面的日期查看當日訓練。';

  @override
  String get calendarNoSessionTitle => '當天無訓練';

  @override
  String get calendarNoSessionBody => '你嗰日冇做gym。';

  @override
  String get calendarOpenSession => '查看訓練';

  @override
  String get calendarViewMonthly => '月份';

  @override
  String get calendarViewYearly => '年度';

  @override
  String calendarYearSummary(int days, int sessions) {
    return '$days 個訓練日 · $sessions 課';
  }

  @override
  String get calendarScopeCurrentMonth => '本月';

  @override
  String get calendarScopeCurrentYear => '今年';

  @override
  String get calendarScopeAllTime => '全部';

  @override
  String get calendarScopeChooserTitle => '顯示哪段時間？';

  @override
  String get calendarPrCallout => '★ 新個人紀錄';

  @override
  String calendarPrLine(Object exercise, Object weight, int reps) {
    return '$exercise · $weight × $reps';
  }

  @override
  String daySheetSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 節訓練',
      one: '1 節訓練',
    );
    return '$_temp0';
  }

  @override
  String get daySheetEmpty => '今日沒有訓練紀錄';

  @override
  String get daySheetEmptyHelp => '今日還未有紀錄。完成的訓練會自動出現在這裡。';

  @override
  String daySheetTimeLine(Object part, Object time) {
    return '$part · $time';
  }

  @override
  String get allSessionsTitle => '所有訓練紀錄';

  @override
  String get allSessionsEmpty => '還未有訓練紀錄 — 由「記錄」分頁完成一節。';

  @override
  String get deleteSessionTitle => '刪除這節訓練？';

  @override
  String get deleteSessionHelp => '刪除後無法復原。';

  @override
  String get deleteSessionTooltip => '刪除這節訓練';

  @override
  String get sessionDetailsTitle => '訓練詳情';

  @override
  String get sessionName => '訓練名稱（選填）';

  @override
  String get sessionNameHint => '例如：練腿日、Push Day';

  @override
  String get sessionPlace => '場地 / 健身室（選填）';

  @override
  String get sessionMoodPrompt => '今日感覺如何？';

  @override
  String get sessionWeather => '天氣';

  @override
  String get sessionFriends => '同行訓練伙伴（選填）';

  @override
  String get sessionFriendsHelper => '用逗號分隔';

  @override
  String get sessionDetailEmpty => '這節訓練還未加入動作。點下方的「加入動作」。';

  @override
  String get shareCardTitle => '分享卡片';

  @override
  String get shareCardShareToApps => '分享';

  @override
  String get shareCardSave => '儲存';

  @override
  String get shareCardSessionPhotosTitle => '或者分享今次訓練的相片';

  @override
  String get shareCardNoSessionPhotos => '今次訓練還未有相片。可以即刻拍一張分享出去。';

  @override
  String get shareCardTakePhoto => '影一張相';

  @override
  String get shareCardSharePhoto => '分享相片';

  @override
  String get shareCardShareCaption => '用 ChillGym 紀錄';

  @override
  String shareCardShareFailed(Object error) {
    return '無法開啟分享選單：$error';
  }

  @override
  String get moodStrong => '強';

  @override
  String get moodNormal => '正常';

  @override
  String get moodTired => '攰';

  @override
  String get moodSick => '唔舒服';

  @override
  String get weatherSunny => '晴朗';

  @override
  String get weatherCloudy => '多雲';

  @override
  String get weatherRainy => '落雨';

  @override
  String get weatherSnowy => '落雪';

  @override
  String get weatherHot => '炎熱';

  @override
  String get weatherCold => '寒冷';

  @override
  String get muscleChest => '胸';

  @override
  String get muscleBack => '背';

  @override
  String get muscleShoulders => '膊頭';

  @override
  String get muscleBiceps => '二頭肌';

  @override
  String get muscleTriceps => '三頭肌';

  @override
  String get muscleForearms => '前臂';

  @override
  String get muscleCore => '核心';

  @override
  String get muscleQuads => '股四頭肌';

  @override
  String get muscleHamstrings => '腿後腱';

  @override
  String get muscleGlutes => '臀';

  @override
  String get muscleCalves => '小腿';

  @override
  String get muscleFullBody => '全身';

  @override
  String get muscleCardio => '帶氧';

  @override
  String get kindStrength => '力量';

  @override
  String get kindCardio => '帶氧';

  @override
  String get equipmentLabel => '器材';

  @override
  String get equipmentBarbell => '槓鈴';

  @override
  String get equipmentDumbbell => '啞鈴';

  @override
  String get equipmentMachine => '機械';

  @override
  String get equipmentCable => '拉索';

  @override
  String get equipmentBodyweight => '徒手';

  @override
  String get equipmentOther => '其他';

  @override
  String get feedbackNotEnough => '未夠';

  @override
  String get feedbackOneMoreSet => '再多一組';

  @override
  String get feedbackGood => '做得好';

  @override
  String get feedbackEnough => '夠了，去練其他部位';

  @override
  String feedbackEnoughBySetCount(int count) {
    return '你已做了 $count 組 — 再加組對成長幫助有限，轉去練其他肌群吧。';
  }

  @override
  String get feedbackEnoughByRatio => '今日這個動作的訓練量已超出常見目標，留力做之後的訓練。';

  @override
  String get feedbackOnTrack => '與你近期平均水平一致。';

  @override
  String feedbackAboveTarget(Object level) {
    return '超出$level的常見目標。';
  }

  @override
  String get feedbackCloseAvg => '接近你近期平均 — 再多一組就夠。';

  @override
  String feedbackAlmostTarget(Object level) {
    return '差不多達到$level的常見目標。';
  }

  @override
  String get feedbackBelowAvg => '低於你近期該動作的平均水平。';

  @override
  String feedbackBelowTarget(Object level) {
    return '低於$level的常見目標。';
  }

  @override
  String get expBeginner => '初學者';

  @override
  String get expIntermediate => '中級';

  @override
  String get expAdvanced => '進階';

  @override
  String get libraryExercises => '動作';

  @override
  String get libraryTemplates => '範本';

  @override
  String get librarySearch => '搜尋動作';

  @override
  String get libraryFilterAll => '全部';

  @override
  String get libraryNoMatch => '沒有符合的動作。';

  @override
  String get libraryNewExercise => '新動作';

  @override
  String get libraryEditExercise => '編輯動作';

  @override
  String get libraryNewTemplate => '新範本';

  @override
  String get libraryEditTemplate => '編輯範本';

  @override
  String get libraryNoTemplatesYet => '還未有範本。';

  @override
  String get libraryCreateOne => '建立一個範本，下次一按即開始訓練。';

  @override
  String get libraryDeleteExercisePrompt => '刪除這個動作？';

  @override
  String get libraryDeleteExerciseHelp => '已參考此動作的訓練紀錄會保留。';

  @override
  String libraryDeleteTemplatePrompt(Object name) {
    return '刪除「$name」？';
  }

  @override
  String get libraryExerciseName => '名稱';

  @override
  String get libraryExerciseType => '類型';

  @override
  String get libraryPrimaryMuscle => '主要肌群';

  @override
  String get librarySecondaryMuscles => '次要肌群（選填）';

  @override
  String get libraryTemplateName => '範本名稱';

  @override
  String get libraryTemplateNameHint => '例如 推日';

  @override
  String get libraryTemplateExercises => '動作';

  @override
  String get libraryNoExercisesYet => '尚未加入動作。';

  @override
  String libraryExerciseCount(int count) {
    return '$count 個動作';
  }

  @override
  String get libraryPickExercise => '選擇動作';

  @override
  String get progressNothingYet => '尚未有圖表可看。';

  @override
  String get progressLogMore => '完成幾節訓練後就會看到趨勢。';

  @override
  String get progressByExercise => '按動作';

  @override
  String get progressByMuscle => '按肌群';

  @override
  String get progressLifts => '動作';

  @override
  String get progressBody => '身體';

  @override
  String get progressDayChanges => '身體變化';

  @override
  String get progressBodyweightTitle => '體重';

  @override
  String get progressBodyweightEmpty => '在「個人」紀錄體重就會開始顯示趨勢。';

  @override
  String progressBodyweightDelta7(Object amount, Object unit) {
    return '比 7 日前 $amount $unit';
  }

  @override
  String get bodyweightStatMin => '最低';

  @override
  String get bodyweightStatMax => '最高';

  @override
  String get bodyweightStatAvg => '平均';

  @override
  String get bodyweightStatRange => '區間';

  @override
  String bodyweightTrendUp(Object amount, Object unit, int days) {
    return '上升中 — $days 天內增加 $amount $unit';
  }

  @override
  String bodyweightTrendDown(Object amount, Object unit, int days) {
    return '下降中 — $days 天內減少 $amount $unit';
  }

  @override
  String bodyweightTrendFlat(int days) {
    return '保持穩定 — 已記錄 $days 天';
  }

  @override
  String get progressFeatured => '焦點動作';

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
  String get progressPersonalBests => '個人最佳';

  @override
  String get progressPrNewBadge => '★ 新';

  @override
  String get progressNoLiftYet => '完成至少一組力量訓練就會出現圖表。';

  @override
  String get progressPickLift => '選擇動作';

  @override
  String get progressRange1M => '1 個月';

  @override
  String get progressRange3M => '3 個月';

  @override
  String get progressRange6M => '6 個月';

  @override
  String get progressRange1Y => '1 年';

  @override
  String get progressRangeAll => '全部';

  @override
  String get progressByMuscleHelp => '點按身體部位查看詳情。顏色越深代表近期訓練量越多。';

  @override
  String get bodyDiagramLow => '少';

  @override
  String get bodyDiagramHigh => '多';

  @override
  String get muscleNoVolumeYet => '尚未記錄此肌群的力量訓練。';

  @override
  String get muscleRecentVolume => '近 4 週';

  @override
  String get muscleAllTimeVolume => '歷史總計';

  @override
  String get muscleWeeklyVolume => '每週訓練量';

  @override
  String get muscleWeeklyHelp => '近 12 週重量 × 次數的總和。';

  @override
  String get muscleExercises => '相關動作';

  @override
  String get muscleNoExercisesYet => '尚未為此肌群記錄動作。';

  @override
  String get profileSectionAbout => '關於你';

  @override
  String get profileSectionTraining => '訓練';

  @override
  String get profileSectionUnits => '單位';

  @override
  String get profileSectionLanguage => '語言';

  @override
  String get profileSectionTheme => '外觀';

  @override
  String get profileThemeHelp =>
      '可以選擇 Warm Editorial（淺色）或 Dark Performance（深色），或跟隨手機設定。';

  @override
  String get profileThemeSystem => '跟隨系統';

  @override
  String get profileThemeLight => '淺色';

  @override
  String get profileThemeDark => '深色';

  @override
  String get profileSectionBodyweight => '體重';

  @override
  String get profileSectionNotifications => '通知';

  @override
  String get profileSectionIntegrations => '整合';

  @override
  String get profileSectionData => '資料';

  @override
  String get profileSectionAbout2 => '關於';

  @override
  String get profileName => '名稱（選填）';

  @override
  String get profileGoal => '目標';

  @override
  String get profileGoalHelp => '用於摘要與回饋說明。';

  @override
  String get profileGoalStrength => '力量';

  @override
  String get profileGoalMuscle => '增肌 / 體型';

  @override
  String get profileGoalGeneral => '一般健身';

  @override
  String get profileGoalEndurance => '耐力';

  @override
  String get profileGoalWeightLoss => '減重';

  @override
  String profileHeight(Object unit) {
    return '身高（$unit）';
  }

  @override
  String get profileExperience => '訓練程度';

  @override
  String get profileExperienceHelp => '在你累積到自己的紀錄前，用作「未夠／再多一組」目標的基準。';

  @override
  String get profileShowRir => '顯示 RIR 欄位';

  @override
  String get profileShowRirHelp => '在記錄組的視窗顯示「保留次數」。';

  @override
  String get profileWeightLabel => '重量';

  @override
  String get profileHeightLabel => '身高';

  @override
  String get profileUnitsHelp => '切換只影響顯示與輸入方式，已記錄的資料會即時換算。';

  @override
  String get profileLanguageHelp => '選擇程式介面顯示的語言。';

  @override
  String get profileLanguageSystem => '跟隨系統';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageZhHK => '繁體中文（香港）';

  @override
  String get profileHealth => '健康整合';

  @override
  String get profileHealthOnMobile => '訓練紀錄會寫入 Apple Health / Health Connect。';

  @override
  String get profileHealthOff => '已關 — 開啟可將訓練寫入手機的健康程式。';

  @override
  String get profileHealthWeb => '網頁版不支援，iOS / Android 可用。';

  @override
  String get profileNotifications => '通知';

  @override
  String get profileNotificationsOn => '休息計時器與懶人提醒已開。';

  @override
  String get profileNotificationsOff => '已關 — 開啟可收到休息與提醒通知。';

  @override
  String get profileNotificationsWeb => '網頁版不支援，iOS / Android 可用。';

  @override
  String get profileNotificationsDenied => '權限被拒 — 請至系統設定開啟通知。';

  @override
  String get profileVersionLine => 'v0.1.0 · Phase 1（MVP）— 未開放登入';

  @override
  String get profileSignInSoon => '登入即將推出';

  @override
  String get profileSignInSoonHelp => '帳戶、同步與 SSO 將會在 Phase 1 末段加入。';

  @override
  String get bodyweightLatest => '最新';

  @override
  String bodyweightInputLabel(Object unit) {
    return '體重（$unit）';
  }

  @override
  String get bodyweightLogTitle => '記錄體重';

  @override
  String get bodyweightEditTitle => '編輯體重';

  @override
  String get bodyweightEmptyHelp => '尚未有體重紀錄。點「記錄體重」加入一筆。';

  @override
  String get dataExportJson => '匯出為 JSON';

  @override
  String get dataExportJsonHelp => '完整備份，可透過匯入還原。';

  @override
  String get dataExportCsv => '匯出組數為 CSV';

  @override
  String get dataExportCsvHelp => '每組一行，方便試算表分析。';

  @override
  String get dataImport => '匯入資料';

  @override
  String get dataImportHelp => '貼上之前匯出的 JSON。會取代現有資料。';

  @override
  String get dataDeleteAll => '刪除所有資料';

  @override
  String get dataDeleteAllHelp => '清除本機所有資料，無法復原。';

  @override
  String get dataDeleteAllPrompt => '刪除所有資料？';

  @override
  String get dataDeleteAllConfirm => '這會清除本機上所有訓練、範本、自訂動作、體重與設定，無法復原。';

  @override
  String get dataAllDeleted => '所有資料已刪除。';

  @override
  String dataExportFailed(Object error) {
    return '匯出失敗：$error';
  }

  @override
  String get dataImportComplete => '匯入完成。';

  @override
  String dataImportFailed(Object error) {
    return '匯入失敗：$error';
  }

  @override
  String get dataDownloaded => '已下載。';

  @override
  String dataSavedTo(Object path) {
    return '已儲存到：$path';
  }

  @override
  String get dataBackupTitle => '備份 JSON';

  @override
  String get dataImportTitle => '匯入備份';

  @override
  String get dataImportWarning => '現有資料會被取代，無法復原。';

  @override
  String get dataImportHint => '在此貼上備份 JSON…';

  @override
  String get dataCopied => '已複製到剪貼簿。';

  @override
  String loadFailed(Object error) {
    return '載入失敗：$error';
  }

  @override
  String genericFailed(Object error) {
    return '失敗：$error';
  }

  @override
  String get bodyPhotosTitle => '身體變化';

  @override
  String get bodyPhotosEmpty => '尚未有身體相片。';

  @override
  String get bodyPhotosEmptyHelp => '建議每週或每兩週影一張，時間線會像翻頁動畫般播放出你的變化。';

  @override
  String get bodyPhotosAdd => '加入相片';

  @override
  String get bodyPhotosAddTitle => '新身體相片';

  @override
  String get bodyPhotosEditTitle => '編輯身體相片';

  @override
  String get bodyPhotosDate => '日期';

  @override
  String get bodyPhotosNoteHint => '備註（例如：減脂開始、旅行）';

  @override
  String bodyPhotosWeightOptional(Object unit) {
    return '當時體重（$unit，選填）';
  }

  @override
  String bodyPhotosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 張相片',
      one: '1 張相片',
    );
    return '$_temp0';
  }

  @override
  String get bodyPhotosPlay => '播放時間線';

  @override
  String get bodyPhotosPlayHint => '點按暫停 · 滑動快搜';

  @override
  String get bodyPhotosNeedTwo => '至少加入兩張相片才能播放時間線。';

  @override
  String get bodyPhotosDeletePrompt => '刪除這張相片？';

  @override
  String get bodyPhotosTimelineTitle => '變化時間線';

  @override
  String get bodyPhotosSlideRate => '速度';

  @override
  String get bodyPhotosSlideRateSlow => '慢';

  @override
  String get bodyPhotosSlideRateNormal => '正常';

  @override
  String get bodyPhotosSlideRateFast => '快';

  @override
  String get bodyPhotosQuotaError =>
      '瀏覽器儲存空間已滿 — 身體相片儲存在 localStorage，上限約 5MB。請刪除一些較舊的相片再試，或匯出資料後改在手機 App 上使用（手機沒有此限制）。';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class AppLocalizationsZhHk extends AppLocalizationsZh {
  AppLocalizationsZhHk() : super('zh_HK');

  @override
  String get appName => 'ChillGym';

  @override
  String get appTagline => '出席。舉鐵。再來。';

  @override
  String get navHome => '主頁';

  @override
  String get navLog => '記錄';

  @override
  String get navProgress => '進度';

  @override
  String get navCalendar => '日曆';

  @override
  String get navLibrary => '動作庫';

  @override
  String get navProfile => '個人';

  @override
  String get navSettings => '設定';

  @override
  String get navBody => '身體紀錄';

  @override
  String get actionHome => '主頁';

  @override
  String get actionSave => '儲存';

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '刪除';

  @override
  String get actionRemove => '移除';

  @override
  String get actionEdit => '編輯';

  @override
  String get actionUpdate => '更新';

  @override
  String get actionClose => '關閉';

  @override
  String get actionImport => '匯入';

  @override
  String get actionPaste => '貼上';

  @override
  String get actionCopy => '複製';

  @override
  String get actionFinish => '完成';

  @override
  String get actionDone => '完成';

  @override
  String get actionShare => '分享';

  @override
  String get actionDiscard => '捨棄';

  @override
  String get actionKeepGoing => '繼續';

  @override
  String get actionDeleteEverything => '全部刪除';

  @override
  String get actionStartWorkout => '開始訓練';

  @override
  String get actionResumeWorkout => '繼續訓練';

  @override
  String get actionStartFromTemplate => '由範本開始';

  @override
  String get actionAddExercise => '加入動作';

  @override
  String get actionAddSet => '加入一組';

  @override
  String get actionRepeatSet => '重複上一組';

  @override
  String get actionShowAll => '顯示全部';

  @override
  String actionViewAllSessions(int count) {
    return '查看全部訓練 ($count)';
  }

  @override
  String actionUseLast(int count) {
    return '套用上次（$count 組）';
  }

  @override
  String get actionRemoveExercise => '移除動作';

  @override
  String get actionRemovePhoto => '移除相片？';

  @override
  String get actionTakePhoto => '拍照';

  @override
  String get actionChooseFromGallery => '從相簿選擇';

  @override
  String get actionTakeOrChoosePhoto => '拍照或從相簿選取';

  @override
  String get actionLogWeight => '記錄體重';

  @override
  String get actionUseThisWeight => '使用此重量';

  @override
  String get homeGreetingMorning => '早晨';

  @override
  String get homeGreetingAfternoon => '午安';

  @override
  String get homeGreetingEvening => '夜晚好';

  @override
  String get homeGreetingLate => '夜深了';

  @override
  String homeGreetingWithName(Object greeting, Object name) {
    return '$greeting，$name。';
  }

  @override
  String homeGreetingNoName(Object greeting) {
    return '$greeting。';
  }

  @override
  String get streakCurrent => '目前連續';

  @override
  String get streakLongest => '最長';

  @override
  String get streakThisMonth => '本月';

  @override
  String streakDayUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '日',
      one: '日',
    );
    return '$_temp0';
  }

  @override
  String streakSessionUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '次訓練',
      one: '次訓練',
    );
    return '$_temp0';
  }

  @override
  String get homeNoSessionsYet => '還未有訓練紀錄 — 準備好就開始一節吧。';

  @override
  String get homeTrainedToday => '今日已經訓練過了。';

  @override
  String get homeYesterdayLast => '昨日是你最近一次訓練。';

  @override
  String homeDaysSinceLast(int count) {
    return '距離上次訓練已過 $count 日。';
  }

  @override
  String homeStartFromTemplateNamed(Object name) {
    return '由「$name」開始';
  }

  @override
  String get homeRecentSessions => '近期訓練';

  @override
  String get homeBodyweight => '體重';

  @override
  String get homeNoBodyweightYet => '尚未有體重紀錄';

  @override
  String get homeTapToLogInProfile => '在「個人」中加入紀錄。';

  @override
  String get homeOnFire => '連勝中';

  @override
  String homeStreakSummary(int count) {
    return '連續 $count 日';
  }

  @override
  String homeFromRecord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '距離紀錄還差 $count 日',
      one: '距離紀錄還差 1 日',
    );
    return '$_temp0';
  }

  @override
  String get homeRecordTied => '已追平你的紀錄。';

  @override
  String get homeRecordSet => '新個人紀錄！';

  @override
  String get homeNextUp => '下一節';

  @override
  String homeNextUpSummary(int exercises, int minutes) {
    return '$exercises 個動作 · 約 $minutes 分鐘';
  }

  @override
  String get homeStartFreshSession => '自由訓練';

  @override
  String get homeStartFreshHint => '邊練邊加動作';

  @override
  String get homeMetric7DayVolume => '7 日訓練量';

  @override
  String get homeMetricEst1RM => '估算 1RM';

  @override
  String get homeMetricBodyweight => '體重';

  @override
  String get homeMetricSessions => '訓練次數';

  @override
  String get homeUnitPerWeek => '/週';

  @override
  String get homeUnitTons => '公噸';

  @override
  String get homeRecent => '近期';

  @override
  String get homeNoRecent => '還未有訓練紀錄 — 完成幾節後會在這裡看到。';

  @override
  String get logReadyToTrain => '準備好訓練了嗎？';

  @override
  String get logStartHelp => '開始一節訓練、加入動作、記錄每組數字。';

  @override
  String get logNoTemplatesYet => '尚未有範本，先去「動作庫」建立一個。';

  @override
  String get logHeroEyebrow => '今日';

  @override
  String get logTemplatesEyebrow => '快速開始';

  @override
  String get logNoTemplatesTitle => '未有範本';

  @override
  String get logNoTemplatesHelp => '去「動作庫」save低一個 routine，喺度一㩒就開始。';

  @override
  String get logCreateTemplate => '建立';

  @override
  String get logRecapToday => '你今日已經練咗。';

  @override
  String get logRecapYesterday => '上次訓練：尋日。';

  @override
  String logRecapDaysAgo(int count) {
    return '上次訓練：$count 日前。';
  }

  @override
  String get addExerciseConfirmTitle => '加新動作';

  @override
  String addExerciseConfirmBody(Object name) {
    return '「$name」做完未？㩒「完成」會將佢收到下面、新動作擺上頂；㩒「繼續」就留喺原本嗰個。';
  }

  @override
  String get addExerciseConfirmKeep => '繼續';

  @override
  String get addExerciseConfirmDone => '完成';

  @override
  String get activeExerciseDone => '完';

  @override
  String get activeExerciseFinish => '標記為完成';

  @override
  String get activeExerciseReopen => '重新打開';

  @override
  String get restTimerMinutes => '分';

  @override
  String get restTimerSeconds => '秒';

  @override
  String get notifRestTitle => '休息完';

  @override
  String get notifRestBody => '做下一組啦。';

  @override
  String get notifInactivityTitle => '練嘢？';

  @override
  String get notifInactivityBody => '好耐冇練，唔好斷連勝。';

  @override
  String get activeTitle => '進行中的訓練';

  @override
  String get activeCancelWorkout => '取消這次訓練？';

  @override
  String get activeCancelHelp => '已記錄的組數會一併清除。';

  @override
  String get activeNothingYet => '點選「加入動作」開始。';

  @override
  String activeSavedSummary(int sets, Object volume) {
    return '已儲存：$sets 組 · 共 $volume';
  }

  @override
  String get finishedTitle => '今日做得好！';

  @override
  String get finishedShareHint => '分享一張卡片，或直接完成。';

  @override
  String get activeWorkoutAlreadyActive => '已有訓練進行中，先完成或取消才能再開。';

  @override
  String activeExerciseCounter(int current, int total) {
    return '動作 $current / $total';
  }

  @override
  String activeProgressionPill(Object amount, Object unit) {
    return '+$amount $unit';
  }

  @override
  String get actionRestAdd15 => '+15 秒';

  @override
  String get actionRestSkip => '略過';

  @override
  String get actionNext => '下一個';

  @override
  String get activeUpNext => '下一個';

  @override
  String get activeNoUpcoming => '最後一個動作 — 完成後就可以收工。';

  @override
  String activeNudgeFromYourTrend(Object nudge) {
    return '訓練量與你近期平均一致，下次可以試試 $nudge。';
  }

  @override
  String get statExercises => '動作';

  @override
  String get statSets => '組數';

  @override
  String get statVolume => '總量';

  @override
  String get statDuration => '時間';

  @override
  String statBest(Object value) {
    return '最佳：$value';
  }

  @override
  String get statBestTopSet => '最佳重組';

  @override
  String get statEst1RM => '估算 1RM';

  @override
  String get statBestVolume => '最佳訓練量';

  @override
  String get statSessions => '訓練次數';

  @override
  String get topSetWeightTitle => '最重那一組';

  @override
  String topSetWeightSubtitle(Object unit) {
    return '每節 $unit';
  }

  @override
  String get totalVolumeTitle => '每節總訓練量';

  @override
  String totalVolumeSubtitle(Object unit) {
    return '$unit 總計';
  }

  @override
  String get totalVolumeCardio => '（重量 × 次數，帶氧通常為 0）';

  @override
  String get noSetData => '尚無組數資料';

  @override
  String sessionsLogged(int count) {
    return '已記錄 $count 節訓練';
  }

  @override
  String perSessionLine(Object weight, int reps, Object volume) {
    return '$weight × $reps  ·  總計 $volume';
  }

  @override
  String volumeCardioLine(Object volume) {
    return '總量 $volume';
  }

  @override
  String get restingLabel => '休息中';

  @override
  String get restTimerSection => '休息計時器';

  @override
  String get restTimerHelp => '每組力量訓練後等候此時間後提示。';

  @override
  String get inactivityNudgeSection => '懶人提醒';

  @override
  String get inactivityNudgeHelp => '如果一段時間沒有訓練就會提醒你。關閉就不會打擾你。';

  @override
  String get inactivityOff => '關閉';

  @override
  String inactivityDays(int count) {
    return '$count 日';
  }

  @override
  String get logSetTitle => '記錄組';

  @override
  String get editSetTitle => '編輯組';

  @override
  String logSetHeader(Object action, Object exercise) {
    return '$action · $exercise';
  }

  @override
  String fieldWeight(Object unit) {
    return '重量（$unit）';
  }

  @override
  String get fieldReps => '次數';

  @override
  String get fieldRir => 'RIR（選填）';

  @override
  String get fieldRirHelper => '保留次數 — 還可以再做幾下';

  @override
  String get fieldDistance => '距離（公里）';

  @override
  String get fieldDuration => '時間（分:秒 或 秒數）';

  @override
  String get fieldNotes => '備註（選填）';

  @override
  String get fieldNote => '備註（選填）';

  @override
  String get actionSaveSet => '儲存組數';

  @override
  String get plateCalcTitle => '計算槓片';

  @override
  String plateCalcTotal(Object unit) {
    return '總重量（$unit）';
  }

  @override
  String plateCalcBar(Object unit) {
    return '槓鈴（$unit）';
  }

  @override
  String get plateCalcPerSide => '每邊（由大到細）：';

  @override
  String get plateCalcJustBar => '只用槓鈴。';

  @override
  String get plateCalcNoPlates => '毋須加片。';

  @override
  String plateCalcUnaccounted(Object amount, Object unit) {
    return '尚欠：$amount $unit（現有槓片無法剛好湊出此重量）。';
  }

  @override
  String get calendarPrevMonth => '上個月';

  @override
  String get calendarNextMonth => '下個月';

  @override
  String get calendarToday => '今日';

  @override
  String get calendarLegendAm => '上午';

  @override
  String get calendarLegendPm => '下午';

  @override
  String get calendarLegendEve => '傍晚';

  @override
  String get calendarLegendNight => '夜晚';

  @override
  String calendarMonthSummary(int days, Object perWeek) {
    return '$days 日 · 每週 $perWeek 次';
  }

  @override
  String get calendarHeatmapLess => '少';

  @override
  String get calendarHeatmapMore => '多';

  @override
  String get calendarStatSets => '組數';

  @override
  String get calendarStatVolume => '訓練量';

  @override
  String get calendarStatMax => '最重';

  @override
  String get calendarPickADay => '點按上面的日期查看當日訓練。';

  @override
  String get calendarNoSessionTitle => '當天無訓練';

  @override
  String get calendarNoSessionBody => '你嗰日冇做gym。';

  @override
  String get calendarOpenSession => '查看訓練';

  @override
  String get calendarViewMonthly => '月份';

  @override
  String get calendarViewYearly => '年度';

  @override
  String calendarYearSummary(int days, int sessions) {
    return '$days 個訓練日 · $sessions 課';
  }

  @override
  String get calendarScopeCurrentMonth => '本月';

  @override
  String get calendarScopeCurrentYear => '今年';

  @override
  String get calendarScopeAllTime => '全部';

  @override
  String get calendarScopeChooserTitle => '顯示哪段時間？';

  @override
  String get calendarPrCallout => '★ 新個人紀錄';

  @override
  String calendarPrLine(Object exercise, Object weight, int reps) {
    return '$exercise · $weight × $reps';
  }

  @override
  String daySheetSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 節訓練',
      one: '1 節訓練',
    );
    return '$_temp0';
  }

  @override
  String get daySheetEmpty => '今日沒有訓練紀錄';

  @override
  String get daySheetEmptyHelp => '今日還未有紀錄。完成的訓練會自動出現在這裡。';

  @override
  String daySheetTimeLine(Object part, Object time) {
    return '$part · $time';
  }

  @override
  String get allSessionsTitle => '所有訓練紀錄';

  @override
  String get allSessionsEmpty => '還未有訓練紀錄 — 由「記錄」分頁完成一節。';

  @override
  String get deleteSessionTitle => '刪除這節訓練？';

  @override
  String get deleteSessionHelp => '刪除後無法復原。';

  @override
  String get deleteSessionTooltip => '刪除這節訓練';

  @override
  String get sessionDetailsTitle => '訓練詳情';

  @override
  String get sessionName => '訓練名稱（選填）';

  @override
  String get sessionNameHint => '例如：練腿日、Push Day';

  @override
  String get sessionPlace => '場地 / 健身室（選填）';

  @override
  String get sessionMoodPrompt => '今日感覺如何？';

  @override
  String get sessionWeather => '天氣';

  @override
  String get sessionFriends => '同行訓練伙伴（選填）';

  @override
  String get sessionFriendsHelper => '用逗號分隔';

  @override
  String get sessionDetailEmpty => '這節訓練還未加入動作。點下方的「加入動作」。';

  @override
  String get shareCardTitle => '分享卡片';

  @override
  String get shareCardShareToApps => '分享';

  @override
  String get shareCardSave => '儲存';

  @override
  String get shareCardSessionPhotosTitle => '或者分享今次訓練的相片';

  @override
  String get shareCardNoSessionPhotos => '今次訓練還未有相片。可以即刻拍一張分享出去。';

  @override
  String get shareCardTakePhoto => '影一張相';

  @override
  String get shareCardSharePhoto => '分享相片';

  @override
  String get shareCardShareCaption => '用 ChillGym 紀錄';

  @override
  String shareCardShareFailed(Object error) {
    return '無法開啟分享選單：$error';
  }

  @override
  String get moodStrong => '強';

  @override
  String get moodNormal => '正常';

  @override
  String get moodTired => '攰';

  @override
  String get moodSick => '唔舒服';

  @override
  String get weatherSunny => '晴朗';

  @override
  String get weatherCloudy => '多雲';

  @override
  String get weatherRainy => '落雨';

  @override
  String get weatherSnowy => '落雪';

  @override
  String get weatherHot => '炎熱';

  @override
  String get weatherCold => '寒冷';

  @override
  String get muscleChest => '胸';

  @override
  String get muscleBack => '背';

  @override
  String get muscleShoulders => '膊頭';

  @override
  String get muscleBiceps => '二頭肌';

  @override
  String get muscleTriceps => '三頭肌';

  @override
  String get muscleForearms => '前臂';

  @override
  String get muscleCore => '核心';

  @override
  String get muscleQuads => '股四頭肌';

  @override
  String get muscleHamstrings => '腿後腱';

  @override
  String get muscleGlutes => '臀';

  @override
  String get muscleCalves => '小腿';

  @override
  String get muscleFullBody => '全身';

  @override
  String get muscleCardio => '帶氧';

  @override
  String get kindStrength => '力量';

  @override
  String get kindCardio => '帶氧';

  @override
  String get equipmentLabel => '器材';

  @override
  String get equipmentBarbell => '槓鈴';

  @override
  String get equipmentDumbbell => '啞鈴';

  @override
  String get equipmentMachine => '機械';

  @override
  String get equipmentCable => '拉索';

  @override
  String get equipmentBodyweight => '徒手';

  @override
  String get equipmentOther => '其他';

  @override
  String get feedbackNotEnough => '未夠';

  @override
  String get feedbackOneMoreSet => '再多一組';

  @override
  String get feedbackGood => '做得好';

  @override
  String get feedbackEnough => '夠了，去練其他部位';

  @override
  String feedbackEnoughBySetCount(int count) {
    return '你已做了 $count 組 — 再加組對成長幫助有限，轉去練其他肌群吧。';
  }

  @override
  String get feedbackEnoughByRatio => '今日這個動作的訓練量已超出常見目標，留力做之後的訓練。';

  @override
  String get feedbackOnTrack => '與你近期平均水平一致。';

  @override
  String feedbackAboveTarget(Object level) {
    return '超出$level的常見目標。';
  }

  @override
  String get feedbackCloseAvg => '接近你近期平均 — 再多一組就夠。';

  @override
  String feedbackAlmostTarget(Object level) {
    return '差不多達到$level的常見目標。';
  }

  @override
  String get feedbackBelowAvg => '低於你近期該動作的平均水平。';

  @override
  String feedbackBelowTarget(Object level) {
    return '低於$level的常見目標。';
  }

  @override
  String get expBeginner => '初學者';

  @override
  String get expIntermediate => '中級';

  @override
  String get expAdvanced => '進階';

  @override
  String get libraryExercises => '動作';

  @override
  String get libraryTemplates => '範本';

  @override
  String get librarySearch => '搜尋動作';

  @override
  String get libraryFilterAll => '全部';

  @override
  String get libraryNoMatch => '沒有符合的動作。';

  @override
  String get libraryNewExercise => '新動作';

  @override
  String get libraryEditExercise => '編輯動作';

  @override
  String get libraryNewTemplate => '新範本';

  @override
  String get libraryEditTemplate => '編輯範本';

  @override
  String get libraryNoTemplatesYet => '還未有範本。';

  @override
  String get libraryCreateOne => '建立一個範本，下次一按即開始訓練。';

  @override
  String get libraryDeleteExercisePrompt => '刪除這個動作？';

  @override
  String get libraryDeleteExerciseHelp => '已參考此動作的訓練紀錄會保留。';

  @override
  String libraryDeleteTemplatePrompt(Object name) {
    return '刪除「$name」？';
  }

  @override
  String get libraryExerciseName => '名稱';

  @override
  String get libraryExerciseType => '類型';

  @override
  String get libraryPrimaryMuscle => '主要肌群';

  @override
  String get librarySecondaryMuscles => '次要肌群（選填）';

  @override
  String get libraryTemplateName => '範本名稱';

  @override
  String get libraryTemplateNameHint => '例如 推日';

  @override
  String get libraryTemplateExercises => '動作';

  @override
  String get libraryNoExercisesYet => '尚未加入動作。';

  @override
  String libraryExerciseCount(int count) {
    return '$count 個動作';
  }

  @override
  String get libraryPickExercise => '選擇動作';

  @override
  String get progressNothingYet => '尚未有圖表可看。';

  @override
  String get progressLogMore => '完成幾節訓練後就會看到趨勢。';

  @override
  String get progressByExercise => '按動作';

  @override
  String get progressByMuscle => '按肌群';

  @override
  String get progressLifts => '動作';

  @override
  String get progressBody => '身體';

  @override
  String get progressDayChanges => '身體變化';

  @override
  String get progressBodyweightTitle => '體重';

  @override
  String get progressBodyweightEmpty => '在「個人」紀錄體重就會開始顯示趨勢。';

  @override
  String progressBodyweightDelta7(Object amount, Object unit) {
    return '比 7 日前 $amount $unit';
  }

  @override
  String get bodyweightStatMin => '最低';

  @override
  String get bodyweightStatMax => '最高';

  @override
  String get bodyweightStatAvg => '平均';

  @override
  String get bodyweightStatRange => '幅度';

  @override
  String bodyweightTrendUp(Object amount, Object unit, int days) {
    return '上升緊 — $days 日內增加 $amount $unit';
  }

  @override
  String bodyweightTrendDown(Object amount, Object unit, int days) {
    return '下降緊 — $days 日內減少 $amount $unit';
  }

  @override
  String bodyweightTrendFlat(int days) {
    return '穩定中 — 已記錄 $days 日';
  }

  @override
  String get progressFeatured => '焦點動作';

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
  String get progressPersonalBests => '個人最佳';

  @override
  String get progressPrNewBadge => '★ 新';

  @override
  String get progressNoLiftYet => '完成至少一組力量訓練就會出現圖表。';

  @override
  String get progressPickLift => '選擇動作';

  @override
  String get progressRange1M => '1 個月';

  @override
  String get progressRange3M => '3 個月';

  @override
  String get progressRange6M => '6 個月';

  @override
  String get progressRange1Y => '1 年';

  @override
  String get progressRangeAll => '全部';

  @override
  String get progressByMuscleHelp => '點按身體部位查看詳情。顏色越深代表近期訓練量越多。';

  @override
  String get bodyDiagramLow => '少';

  @override
  String get bodyDiagramHigh => '多';

  @override
  String get muscleNoVolumeYet => '尚未記錄此肌群的力量訓練。';

  @override
  String get muscleRecentVolume => '近 4 週';

  @override
  String get muscleAllTimeVolume => '歷史總計';

  @override
  String get muscleWeeklyVolume => '每週訓練量';

  @override
  String get muscleWeeklyHelp => '近 12 週重量 × 次數的總和。';

  @override
  String get muscleExercises => '相關動作';

  @override
  String get muscleNoExercisesYet => '尚未為此肌群記錄動作。';

  @override
  String get profileSectionAbout => '關於你';

  @override
  String get profileSectionTraining => '訓練';

  @override
  String get profileSectionUnits => '單位';

  @override
  String get profileSectionLanguage => '語言';

  @override
  String get profileSectionTheme => '外觀';

  @override
  String get profileThemeHelp =>
      '可以選擇 Warm Editorial（淺色）或 Dark Performance（深色），或跟隨手機設定。';

  @override
  String get profileThemeSystem => '跟隨系統';

  @override
  String get profileThemeLight => '淺色';

  @override
  String get profileThemeDark => '深色';

  @override
  String get profileSectionBodyweight => '體重';

  @override
  String get profileSectionNotifications => '通知';

  @override
  String get profileSectionIntegrations => '整合';

  @override
  String get profileSectionData => '資料';

  @override
  String get profileSectionAbout2 => '關於';

  @override
  String get profileName => '名稱（選填）';

  @override
  String get profileGoal => '目標';

  @override
  String get profileGoalHelp => '用於摘要與回饋說明。';

  @override
  String get profileGoalStrength => '力量';

  @override
  String get profileGoalMuscle => '增肌 / 體型';

  @override
  String get profileGoalGeneral => '一般健身';

  @override
  String get profileGoalEndurance => '耐力';

  @override
  String get profileGoalWeightLoss => '減重';

  @override
  String profileHeight(Object unit) {
    return '身高（$unit）';
  }

  @override
  String get profileExperience => '訓練程度';

  @override
  String get profileExperienceHelp => '在你累積到自己的紀錄前，用作「未夠／再多一組」目標的基準。';

  @override
  String get profileShowRir => '顯示 RIR 欄位';

  @override
  String get profileShowRirHelp => '在記錄組的視窗顯示「保留次數」。';

  @override
  String get profileWeightLabel => '重量';

  @override
  String get profileHeightLabel => '身高';

  @override
  String get profileUnitsHelp => '切換只影響顯示與輸入方式，已記錄的資料會即時換算。';

  @override
  String get profileLanguageHelp => '選擇程式介面顯示的語言。';

  @override
  String get profileLanguageSystem => '跟隨系統';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageZhHK => '繁體中文（香港）';

  @override
  String get profileHealth => '健康整合';

  @override
  String get profileHealthOnMobile => '訓練紀錄會寫入 Apple Health / Health Connect。';

  @override
  String get profileHealthOff => '已關 — 開啟可將訓練寫入手機的健康程式。';

  @override
  String get profileHealthWeb => '網頁版不支援，iOS / Android 可用。';

  @override
  String get profileNotifications => '通知';

  @override
  String get profileNotificationsOn => '休息計時器與懶人提醒已開。';

  @override
  String get profileNotificationsOff => '已關 — 開啟可收到休息與提醒通知。';

  @override
  String get profileNotificationsWeb => '網頁版不支援，iOS / Android 可用。';

  @override
  String get profileNotificationsDenied => '權限被拒 — 請至系統設定開啟通知。';

  @override
  String get profileVersionLine => 'v0.1.0 · Phase 1（MVP）— 未開放登入';

  @override
  String get profileSignInSoon => '登入即將推出';

  @override
  String get profileSignInSoonHelp => '帳戶、同步與 SSO 將會在 Phase 1 末段加入。';

  @override
  String get bodyweightLatest => '最新';

  @override
  String bodyweightInputLabel(Object unit) {
    return '體重（$unit）';
  }

  @override
  String get bodyweightLogTitle => '記錄體重';

  @override
  String get bodyweightEditTitle => '編輯體重';

  @override
  String get bodyweightEmptyHelp => '尚未有體重紀錄。點「記錄體重」加入一筆。';

  @override
  String get dataExportJson => '匯出為 JSON';

  @override
  String get dataExportJsonHelp => '完整備份，可透過匯入還原。';

  @override
  String get dataExportCsv => '匯出組數為 CSV';

  @override
  String get dataExportCsvHelp => '每組一行，方便試算表分析。';

  @override
  String get dataImport => '匯入資料';

  @override
  String get dataImportHelp => '貼上之前匯出的 JSON。會取代現有資料。';

  @override
  String get dataDeleteAll => '刪除所有資料';

  @override
  String get dataDeleteAllHelp => '清除本機所有資料，無法復原。';

  @override
  String get dataDeleteAllPrompt => '刪除所有資料？';

  @override
  String get dataDeleteAllConfirm => '這會清除本機上所有訓練、範本、自訂動作、體重與設定，無法復原。';

  @override
  String get dataAllDeleted => '所有資料已刪除。';

  @override
  String dataExportFailed(Object error) {
    return '匯出失敗：$error';
  }

  @override
  String get dataImportComplete => '匯入完成。';

  @override
  String dataImportFailed(Object error) {
    return '匯入失敗：$error';
  }

  @override
  String get dataDownloaded => '已下載。';

  @override
  String dataSavedTo(Object path) {
    return '已儲存到：$path';
  }

  @override
  String get dataBackupTitle => '備份 JSON';

  @override
  String get dataImportTitle => '匯入備份';

  @override
  String get dataImportWarning => '現有資料會被取代，無法復原。';

  @override
  String get dataImportHint => '在此貼上備份 JSON…';

  @override
  String get dataCopied => '已複製到剪貼簿。';

  @override
  String loadFailed(Object error) {
    return '載入失敗：$error';
  }

  @override
  String genericFailed(Object error) {
    return '失敗：$error';
  }

  @override
  String get bodyPhotosTitle => '身體變化';

  @override
  String get bodyPhotosEmpty => '尚未有身體相片。';

  @override
  String get bodyPhotosEmptyHelp => '建議每週或每兩週影一張，時間線會像翻頁動畫般播放出你的變化。';

  @override
  String get bodyPhotosAdd => '加入相片';

  @override
  String get bodyPhotosAddTitle => '新身體相片';

  @override
  String get bodyPhotosEditTitle => '編輯身體相片';

  @override
  String get bodyPhotosDate => '日期';

  @override
  String get bodyPhotosNoteHint => '備註（例如：減脂開始、旅行）';

  @override
  String bodyPhotosWeightOptional(Object unit) {
    return '當時體重（$unit，選填）';
  }

  @override
  String bodyPhotosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 張相片',
      one: '1 張相片',
    );
    return '$_temp0';
  }

  @override
  String get bodyPhotosPlay => '播放時間線';

  @override
  String get bodyPhotosPlayHint => '點按暫停 · 滑動快搜';

  @override
  String get bodyPhotosNeedTwo => '至少加入兩張相片才能播放時間線。';

  @override
  String get bodyPhotosDeletePrompt => '刪除這張相片？';

  @override
  String get bodyPhotosTimelineTitle => '變化時間線';

  @override
  String get bodyPhotosSlideRate => '速度';

  @override
  String get bodyPhotosSlideRateSlow => '慢';

  @override
  String get bodyPhotosSlideRateNormal => '正常';

  @override
  String get bodyPhotosSlideRateFast => '快';

  @override
  String get bodyPhotosQuotaError =>
      '瀏覽器儲存空間已滿 — 身體相片儲存在 localStorage，上限約 5MB。請刪除一些較舊的相片再試，或匯出資料後改在手機 App 上使用（手機沒有此限制）。';
}
