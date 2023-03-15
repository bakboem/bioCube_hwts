/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/setting/provider/setting_page_provider.dart
 * Created Date: 2023-01-27 12:15:53
 * Last Modified: 2023-03-15 00:14:21
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hwst/enums/hive_box_type.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/model/user/get_user_all_response_model.dart';
import 'package:hwst/service/api_service.dart';
import 'package:hwst/service/hive_service.dart';
import 'package:hwst/util/date_util.dart';
import 'package:provider/provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/model/user/user_environment_model.dart';

class SettinPageProivder extends ChangeNotifier {
  bool bleSwichVal = false;
  bool nfcSwichVal = false;
  bool faceSwichVal = false;
  bool faceMoreSwichVal = false;

  String? currenGuideMethod;
  String? currenVeirfyRadioStr;
  String? combinationVeifyRadioStr;
  String? cameraRadioStr;
  String? rssi;
  int? sessionSettingTime;

  var veifyRadioList = [];
  var combinationVeifyRadioList = [];
  var guideMethodRadioList = [];
  var cameraRadioList = [];

  void setUserEnvrionment() {
    final ap = KeyService.baseAppKey.currentContext!.read<AuthProvider>();
    var temp = UserEnvironmentModel(
        bleSwichVal,
        guideMethodRadioList.indexOf(currenGuideMethod!),
        faceSwichVal,
        faceMoreSwichVal,
        nfcSwichVal,
        combinationVeifyRadioStr == null
            ? veifyRadioList.indexOf(currenVeirfyRadioStr!)
            : combinationVeifyRadioList.indexOf(combinationVeifyRadioStr!) + 2,
        rssi,
        sessionSettingTime);
    pr(temp.toJson());
    CacheService.saveUserEnvironment(temp.toJson());
    ap.setUserEnvironment(temp);
  }

  void setCurrenVeirfyRadioStr(List<String> list, int index) {
    currenVeirfyRadioStr = list[index];
    index == 0 ? combinationVeifyRadioStr = null : DoNothingAction();
    notifyListeners();
  }

  void setCurrenGuideMethodStr(List<String> list, int index) {
    currenGuideMethod = list[index];
    notifyListeners();
  }

  void setCameraRadioStr(List<String> list, int index) {
    cameraRadioStr = list[index];
    notifyListeners();
  }

  void setCombinationVeifyRadioStr(List<String> list, int index) {
    combinationVeifyRadioStr = list[index];
    notifyListeners();
  }

  void setRssi(String val) {
    rssi = val;
    notifyListeners();
  }

  void setSessionTime(int val) {
    sessionSettingTime = val;
    notifyListeners();
  }

  void setBleSwich() {
    bleSwichVal = !bleSwichVal;
    notifyListeners();
  }

  void setNfcSwich() {
    nfcSwichVal = !nfcSwichVal;
    notifyListeners();
  }

  void setFaceSwich() {
    faceSwichVal = !faceSwichVal;
    notifyListeners();
  }

  void setFaceMoreSwich() {
    faceMoreSwichVal = !faceMoreSwichVal;
    notifyListeners();
  }

  Future<ResultModel> init() async {
    final userEvn = CacheService.getUserEnvironment();
    print(userEvn?.toJson());
    veifyRadioList = [tr('fixed_type'), tr('personal')];
    guideMethodRadioList = [tr('vibration'), tr('system_voice'), tr('sound')];
    combinationVeifyRadioList = [tr('face_and_ble'), tr('face_and_nfc')];
    cameraRadioList = [tr('one_to_one'), tr('one_to_more')];
    if (userEvn == null) {
      currenGuideMethod = tr('system_voice');
      currenVeirfyRadioStr = tr('personal');
      bleSwichVal = true;
      nfcSwichVal = true;
      faceMoreSwichVal = false;
      faceSwichVal = false;
      sessionSettingTime = 20;
      rssi = '-80';
    } else {
      nfcSwichVal = userEvn.isUseNfc!;
      bleSwichVal = userEvn.isUseBle!;
      faceSwichVal = userEvn.isUseFace!;
      faceMoreSwichVal = userEvn.isUseFaceMore ?? false;
      currenGuideMethod = guideMethodRadioList[userEvn.alarmType!];
      currenVeirfyRadioStr = userEvn.useType! > 1
          ? veifyRadioList[1]
          : veifyRadioList[userEvn.useType!];
      combinationVeifyRadioStr = userEvn.useType! > 1
          ? combinationVeifyRadioList[userEvn.useType! - veifyRadioList.length]
          : null;
      sessionSettingTime = userEvn.sessionTime;
      rssi = userEvn.rssi;
    }
    return ResultModel(true);
  }
}
