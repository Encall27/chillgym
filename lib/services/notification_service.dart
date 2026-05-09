import 'package:flutter/foundation.dart';

import 'notification_io_stub.dart'
    if (dart.library.io) 'notification_io.dart' as impl;

/// Façade over `flutter_local_notifications`. Web is a no-op.
///
/// Two notifications are managed: rest-timer end (per set) and
/// inactivity nudge (after `finishSession`). Both are canceled-and-replaced;
/// only one of each is ever pending. Title / body strings are passed in by
/// callers so they can be localized — the service holds no UI copy.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool get isPlatformSupported => !kIsWeb;

  Future<void> init() => impl.init();

  /// Returns true if the user granted permission. iOS shows the system
  /// dialog; Android 13+ asks for `POST_NOTIFICATIONS`.
  Future<bool> requestPermissions() => impl.requestPermissions();

  Future<void> scheduleRestEnd(
    Duration after, {
    String? title,
    String? body,
  }) =>
      impl.scheduleRestEnd(after, title: title, body: body);

  Future<void> cancelRest() => impl.cancelRest();

  /// Schedules a single nudge at [when]. Re-call to replace the existing one.
  Future<void> scheduleInactivityNudge(
    DateTime when, {
    String? title,
    String? body,
  }) =>
      impl.scheduleInactivityNudge(when, title: title, body: body);

  Future<void> cancelInactivity() => impl.cancelInactivity();
}
