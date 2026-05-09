import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

/// Thin wrapper around the `health` package. All entry points are safe to call
/// on web (they no-op and return false) and on mobile when permissions haven't
/// been granted (they return false rather than throw).
///
/// **Mobile setup still required** before write actually lands:
/// - **iOS**: enable HealthKit capability in Xcode + add `NSHealthShareUsageDescription`
///   and `NSHealthUpdateUsageDescription` to `ios/Runner/Info.plist`.
/// - **Android**: add Health Connect permissions to `android/app/src/main/AndroidManifest.xml`
///   (the package's README has the canonical snippet).
///
/// Until those are in place the service silently returns false on mobile.
class HealthService {
  HealthService._();
  static final HealthService instance = HealthService._();

  final Health _health = Health();
  bool _configured = false;

  static const _writeTypes = <HealthDataType>[
    HealthDataType.WORKOUT,
  ];
  static const _permissions = <HealthDataAccess>[
    HealthDataAccess.WRITE,
  ];

  bool get isPlatformSupported => !kIsWeb;

  Future<bool> _ensureConfigured() async {
    if (kIsWeb) return false;
    if (_configured) return true;
    try {
      await _health.configure();
      _configured = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns true iff the user accepted (or had previously accepted) the write
  /// permission for workouts.
  Future<bool> requestPermissions() async {
    if (!await _ensureConfigured()) return false;
    try {
      return await _health.requestAuthorization(
        _writeTypes,
        permissions: _permissions,
      );
    } catch (_) {
      return false;
    }
  }

  /// Write a strength workout. Returns true on success. Silently returns false
  /// on web, missing permissions, missing native config, or any plugin error.
  Future<bool> writeStrengthWorkout({
    required DateTime start,
    required DateTime end,
  }) async {
    if (!await _ensureConfigured()) return false;
    try {
      return await _health.writeWorkoutData(
        activityType: HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING,
        start: start,
        end: end,
      );
    } catch (_) {
      return false;
    }
  }
}
