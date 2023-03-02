/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/truepass/lib/service/vibration_service.dart
 * Created Date: 2023-01-29 10:57:32
 * Last Modified: 2023-01-29 12:21:29
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:vibration/vibration.dart';

class ViBrationService {
  factory ViBrationService() => _sharedInstance();
  static ViBrationService? _instance;
  ViBrationService._();
  static ViBrationService _sharedInstance() {
    _instance ??= ViBrationService._();
    return _instance!;
  }

  static Future<bool> hasVibrator() async {
    return await Vibration.hasVibrator() ?? false;
  }

  static Future<bool> hasAmplitudeControl() async {
    return await Vibration.hasAmplitudeControl() ?? false;
  }

  static Future<bool> hasCustomVibrations() async {
    return await await Vibration.hasCustomVibrationsSupport() ?? false;
  }

  static void viberateOnly() {
    Vibration.vibrate();
  }

  static void viberateWithControl({int? val}) {
    Vibration.vibrate(amplitude: val ?? 128);
  }

  static void viberateWithDuration({Duration? duration}) {
    Vibration.vibrate(duration: duration != null ? duration.inSeconds : 1000);
  }

  static void viberateWithPattern({List<int>? pattern}) {
    if (pattern != null) {
      assert(pattern.length > 2);
    }
    Vibration.vibrate(pattern: pattern ?? [500, 1000, 500, 2000]);
  }

  static void cancel() {
    Vibration.cancel();
  }
}
