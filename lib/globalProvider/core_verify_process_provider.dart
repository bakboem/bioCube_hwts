/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/home/provider/core_process_provider.dart
 * Created Date: 2023-01-25 12:24:10
 * Last Modified: 2023-02-22 22:44:51
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
import 'package:hwst/service/deviceInfo_service.dart';
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

  String? message;
  String tid = '';
  bool? isBleSuccess; // toast
  bool? isNfcSuccess; // toast
  Timer? timer;
  var verifyType = VerifyType.BLE;
  final _api = ApiService();
  bool get isTimerRunning => timer != null ? timer!.isActive : false;
  ResultAuthorizedResponseModel? resultAuthorizedResponseModel;
  ResultAuthorizedModel? resultAuthorizedModel;
  Position? position;

  void startTimer({Duration? duration}) {
    timer = Timer(duration ?? Duration(seconds: 3), () => reset());
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

  Future<void> setTid(String? str) async {
    tid = str ?? '';
    if (str != null) {
      tid = str.substring(str.lastIndexOf(':') + 1).trim();
    }
  }

  Future<void> setVerifyType(VerifyType type) async {
    verifyType = type;
  }

  Future<ResultModel> sendDataToSever() async {
    if (await PermissionService.requestPermission(Permission.location)) {
      position = await LocationService.getCurrentPosition();
    } else {
      return ResultModel(false);
    }
    pr(CacheService.getUserCard()?.toJson());
    var deviceInfo = await DeviceInfoService.getDeviceInfo();
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
      lSerial: deviceInfo.deviceId.trim(),
      lTid: tid.trim(),
      mPerson: userCard != null ? userCard.mPerson?.trim() : '',
      lGps: '${position?.latitude},${position?.longitude}',
    );

    Map<String, dynamic> body = resultAuthorizedModel!.toJson();
    pr(body);
    try {
      _api.init(RequestType.SEND_MATCH_RESULT);
      pr('${CacheService.getSvUrl()}send_auth_result.php');
      final result = await _api.request(body: body);
      if (result == null || result.statusCode != 200) {
        isLoadData = false;
        notifyListeners();
        return ResultModel(false,
            isNetworkError: result?.statusCode == -2,
            isServerError: result?.statusCode == -1);
      }
      if (result.statusCode == 200) {
        pr(result.body);
        verifyType == VerifyType.BLE
            ? isBleSuccess = true
            : isNfcSuccess = true;

        return ResultModel(true);
      }
    } catch (e) {
      pr(e);
    }
    return ResultModel(false);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
