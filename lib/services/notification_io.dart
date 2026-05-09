import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

final _plugin = FlutterLocalNotificationsPlugin();

/// IDs are stable across the app so we can cancel/replace by id.
const _restEndId = 1;
const _inactivityId = 2;

const _channelId = 'gym_default';
const _channelName = 'Workout reminders';
const _channelDesc = 'Rest-timer end and inactivity nudges.';

bool _initialized = false;

Future<void> init() async {
  if (_initialized) return;
  tzdata.initializeTimeZones();
  const ios = DarwinInitializationSettings(
    // Don't ask on init — we only request when the user opts in via Profile.
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _plugin.initialize(
    const InitializationSettings(android: android, iOS: ios),
  );
  _initialized = true;
}

Future<bool> requestPermissions() async {
  await init();
  if (Platform.isIOS || Platform.isMacOS) {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final ok = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    return ok ?? false;
  }
  if (Platform.isAndroid) {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? true;
  }
  return false;
}

NotificationDetails _details() {
  const android = AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDesc,
    importance: Importance.high,
    priority: Priority.high,
  );
  const ios = DarwinNotificationDetails();
  return const NotificationDetails(android: android, iOS: ios);
}

Future<void> scheduleRestEnd(
  Duration after, {
  String? title,
  String? body,
}) async {
  await init();
  await _plugin.cancel(_restEndId);
  // We don't depend on flutter_native_timezone — UTC-anchored scheduling fires
  // at the same wall-clock instant on every device.
  final when = tz.TZDateTime.now(tz.UTC).add(after);
  await _plugin.zonedSchedule(
    _restEndId,
    title ?? 'Rest is up',
    body ?? 'Time for the next set.',
    when,
    _details(),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> cancelRest() async {
  await init();
  await _plugin.cancel(_restEndId);
}

Future<void> scheduleInactivityNudge(
  DateTime when, {
  String? title,
  String? body,
}) async {
  await init();
  await _plugin.cancel(_inactivityId);
  final tzWhen = tz.TZDateTime.from(when.toUtc(), tz.UTC);
  await _plugin.zonedSchedule(
    _inactivityId,
    title ?? 'Time to train?',
    body ?? "It's been a while — keep the streak alive.",
    tzWhen,
    _details(),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> cancelInactivity() async {
  await init();
  await _plugin.cancel(_inactivityId);
}
