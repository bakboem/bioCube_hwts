/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/truepass/lib/view/home/provider/core_process_provider.dart
 * Created Date: 2023-01-25 12:24:10
 * Last Modified: 2023-03-02 22:58:18
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hwst/util/date_util.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:hwst/service/api_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/service/location_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/service/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/model/home/result_authorized_model.dart';
import 'package:hwst/model/home/result_authorized_response_model.dart';

class CoreVerifyProcessProvider extends ChangeNotifier {
  int pos = 0;
  int partial = 100;
  bool hasMore = false;
  bool isLoadData = false;
  bool isShowCamera = false;
  bool isBackgroundMode = false;
  VerifyType lastVerfyType = VerifyType.BLE;
  String? message;
  String tid = '';

  bool? isBleSuccess; // toast
  bool? isNfcSuccess; // toast
  Timer? timer;
  Timer? sessionTimer;
  var verifyType = VerifyType.BLE;
  final _api = ApiService();
  bool get isTimerRunning => timer != null ? timer!.isActive : false;
  ResultAuthorizedResponseModel? resultAuthorizedResponseModel;
  ResultAuthorizedModel? resultAuthorizedModel;
  Position? position;

  void startTimer({Duration? duration}) {
    timer = Timer(duration ?? Duration(seconds: 3), () => reset());
  }

  void setLastVerfyType(VerifyType type) {
    lastVerfyType = type;
    notifyListeners();
  }

  void startSettionTimer() {
    var temp = CacheService.getUserEnvironment()!.sessionTime;
    if (sessionTimer == null) {
      sessionTimer = Timer.periodic(Duration(seconds: 1), (t) {
        if (t == temp) {
          t.cancel();
          sessionTimer = null;
        }
        notifyListeners();
      });
    }
  }

  void setIsBackgroundMode(bool val) {
    isBackgroundMode = val;
  }

  void setMessage(String str) {
    message = str;
    pr(message);
    notifyListeners();
  }

  void reset() {
    isBleSuccess = null;
    isNfcSuccess = null;
    message = null;
    timer = null;
    notifyListeners();
  }

  void setIsShowCamera({bool? val}) {
    isShowCamera = val ?? !isShowCamera;
    notifyListeners();
  }

  void setTid(String? str) {
    tid = str ?? '';
    if (str != null) {
      tid = str.substring(str.lastIndexOf(':') + 1).trim();
    }
  }

  void setVerifyType(VerifyType type) {
    verifyType = type;
  }

  Future<ResultModel> sendDataToSever() async {
    if (await PermissionService.requestPermission(Permission.location)) {
      position = await LocationService.getCurrentPosition();
    } else {
      return ResultModel(false);
    }
    var deviceInfo = CacheService.getDeviceInfo();
    var userCard = CacheService.getUserCard();
    var AccessInfo = CacheService.getAccessInfo()!;
    resultAuthorizedModel = ResultAuthorizedModel(
      lOs: Platform.isIOS ? 'iOS' : 'Android',
      lType: verifyType.code.trim(),
      siteCode: AccessInfo.siteCode?.trim(),
      mobileId: userCard?.mCardKey?.trim(),
      lDate: DateUtil.now(),
      lPhoto: userCard != null ? userCard.mPhoto ?? '' : '',
      lResult: '0',
      lSerial: deviceInfo?.deviceId.trim(),
      lTid: tid.trim(),
      mPerson: userCard != null ? userCard.mPerson?.trim() : '',
      lGps: '${position?.latitude},${position?.longitude}',
    );

    Map<String, dynamic> body = resultAuthorizedModel!.toJson();
    try {
      _api.init(RequestType.SEND_MATCH_RESULT);
      final result = await _api.request(body: body);
      if (result == null || result.statusCode != 200) {
        isLoadData = false;
        notifyListeners();
        return ResultModel(false,
            isNetworkError: result?.statusCode == -2,
            isServerError: result?.statusCode == -1);
      }
      if (result.statusCode == 200 && result.body['result'] == 'success') {
        pr('body:::${result.body}');
        verifyType == VerifyType.BLE
            ? isBleSuccess = true
            : isNfcSuccess = true;
        notifyListeners();
        return ResultModel(true);
      }
    } catch (e) {
      pr(e);
    }
    return ResultModel(false);
  }

  void sendDataToSeverFromBackground() {
    var deviceInfo = CacheService.getDeviceInfo();
    var userCard = CacheService.getUserCard();
    var AccessInfo = CacheService.getAccessInfo()!;
    resultAuthorizedModel = ResultAuthorizedModel(
      lOs: Platform.isIOS ? 'iOS' : 'Android',
      lType: verifyType.code.trim(),
      siteCode: AccessInfo.siteCode?.trim(),
      mobileId: userCard?.mCardKey?.trim(),
      lDate: DateUtil.now(),
      lPhoto: userCard != null ? userCard.mPhoto ?? '' : '',
      lResult: '0',
      lSerial: deviceInfo?.deviceId.trim(),
      lTid: tid.trim(),
      mPerson: userCard != null ? userCard.mPerson?.trim() : '',
      lGps: '${position?.latitude},${position?.longitude}',
    );

    Map<String, dynamic> body = resultAuthorizedModel!.toJson();
    _api.init(RequestType.SEND_MATCH_RESULT);
    _api.request(body: body);
  }

  @override
  void dispose() {
    timer?.cancel();
    sessionTimer?.cancel();
    super.dispose();
  }
}
