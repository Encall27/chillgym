// Web stub — flutter_local_notifications has no web platform impl. All
// methods are silent no-ops. Anything user-facing should still gate on
// `kIsWeb` or on the `notificationsEnabled` preference so the UI can explain
// why nothing happens.

Future<void> init() async {}

Future<bool> requestPermissions() async => false;

Future<void> scheduleRestEnd(Duration after, {String? title, String? body}) async {}

Future<void> cancelRest() async {}

Future<void> scheduleInactivityNudge(DateTime when, {String? title, String? body}) async {}

Future<void> cancelInactivity() async {}
