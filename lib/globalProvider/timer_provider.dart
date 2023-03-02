/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/timer_provider.dart
 * Created Date: 2022-07-08 14:36:43
 * Last Modified: 2023-03-02 19:14:57
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:hwst/util/date_util.dart';
import 'package:hwst/view/common/function_of_print.dart';

class TimerProvider extends ChangeNotifier {
  String? lastToastText;
  Timer? _timer;
  Timer? _passKitTimer;
  Timer? _exitAppTimer;
  Timer? _toastTimer;
  Timer? get getTimer => _timer;
  bool get isRunning => _timer == null ? false : _timer!.isActive;
  bool get isToastRunnint =>
      _toastTimer == null ? false : _toastTimer!.isActive;
  bool get isPassKitTimerRunning =>
      _passKitTimer == null ? false : _passKitTimer!.isActive;
  // 영업시간 설정
  final startWorkingHour = 00;
  final stopWorkingHour = 23;
  final startMinute = 00;
  final stopMinute = 59;

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  영업시간 제한
  DateTime? lastActionTime;
  bool get isNotWorkingTime {
    var nowHour = DateTime.now().hour;
    var nowMinute = DateTime.now().minute;
    var isWorkingTime = (nowHour >= startWorkingHour) &&
        (nowHour == startWorkingHour
            ? startMinute != 0
                ? nowMinute < startMinute
                : true
            : true) &&
        (nowHour <= stopWorkingHour) &&
        (nowHour == stopWorkingHour
            ? stopMinute != 0
                ? nowMinute < stopMinute
                : true
            : true);
    return !isWorkingTime;
  }

  bool get isOverTime {
    var isToday =
        DateUtil.isToday(lastActionTime ?? DateTime.now(), DateTime.now());
    return !isToday;
  }

  void setLastActionTime() {
    lastActionTime = DateTime.now();
  }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  영업시간 제한
//
  void stopToastTimer() {
    _toastTimer?.cancel();
    notifyListeners();
  }

  void setLastToastText(String str) {
    lastToastText = str;
  }

  Future<void> doExit(Future<void> future) async {
    if (_exitAppTimer == null) {
      _exitAppTimer = Timer(Duration(seconds: 3), () {});
      future.then((_) => null);
    } else {
      if (_exitAppTimer!.isActive) {
        exit(0);
      } else {
        _exitAppTimer = Timer(Duration(seconds: 3), () {});
        future.then((_) => null);
      }
    }
  }

  void passKitProcess(Function process, {Duration? duration}) {
    _passKitTimer = Timer.periodic(duration ?? const Duration(seconds: 3), (t) {
      process.call();
      t.cancel();
      pr('_passkitTimer stoped');
      _passKitTimer = null;
    });
  }

  void toastProcess(Function process, {Duration? duration}) {
    process.call();
    _toastTimer = Timer.periodic(duration ?? const Duration(seconds: 3), (t) {
      t.cancel();
      _toastTimer = null;
    });
    notifyListeners();
  }

  Future<void> perdict(Future<void> future, {Duration? duration}) async {
    if (_timer == null) {
      _timer = Timer.periodic(duration ?? const Duration(milliseconds: 1600),
          (t) async {
        future.then((value) {
          t.cancel();
          _timer?.cancel();
        });
      });
      notifyListeners();
    } else {
      _timer =
          Timer.periodic(duration ?? const Duration(milliseconds: 1600), (t) {
        t.cancel();
        _timer?.cancel();
        pr('timer canceld');
      });
    }
  }

  Future<void> executeLastAction(Future func, {Duration? duration}) async {
    _timer?.cancel();
    _timer = null;
    var counter = duration != null ? duration.inSeconds : 3;
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      counter--;
      if (counter == 0) {
        func.then((_) {
          _timer?.cancel();
          _timer = null;
          pr('complete');
        });
      } else if (duration != null ? t.tick > duration.inSeconds : t.tick > 3) {
        _timer?.cancel();
        _timer = null;
        pr('auto complete');
      }
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _exitAppTimer?.cancel();
    _toastTimer?.cancel();
    _passKitTimer?.cancel();
    super.dispose();
  }
}
