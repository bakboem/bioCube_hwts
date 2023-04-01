/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/cache_service.dart
 * Created Date: 2021-08-22 19:45:10
 * Last Modified: 2023-03-31 00:27:12
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hwst/enums/language_type.dart';
import 'package:hwst/model/access/access_info.dart';
import 'package:hwst/model/user/tid_model.dart';
import 'package:hwst/model/user/user_card_model.dart';
import 'package:hwst/model/user/user_device_info.dart';
import 'package:hwst/model/user/user_environment_model.dart';

//*  SharedPreferences Singleton
class CacheService {
  factory CacheService() => _sharedInstance();
  static CacheService? _instance;
  static SharedPreferences? sharedPreferences;
  CacheService._();
  static CacheService _sharedInstance() {
    _instance ??= CacheService._();
    return _instance!;
  }

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static saveData(String key, dynamic data) {
    switch (data.runtimeType) {
      case int:
        sharedPreferences?.setInt(key, data);
        break;
      case String:
        sharedPreferences?.setString(key, data);
        break;
      case bool:
        sharedPreferences?.setBool(key, data);
        break;
      case double:
        sharedPreferences?.setDouble(key, data);
        break;
      case List:
        sharedPreferences?.setStringList(key, data);
        break;
    }
  }

  static void deleteALL() {
    sharedPreferences?.clear();
  }

  static getData(String key) {
    return sharedPreferences?.get(key);
  }

  static bool checkExits(String key) {
    return sharedPreferences!.containsKey(key);
  }

  static void deleteData(String key, {bool? withConstans}) {
    if (withConstans != null) {
      var keys = sharedPreferences?.getKeys();
      keys!.forEach((realKey) {
        if (realKey.contains(key)) {
          sharedPreferences?.remove(realKey);
        }
      });
    } else {
      final exists = checkExits(key);
      if (exists) {
        sharedPreferences?.remove(key);
      }
    }
  }

  static void saveAccessInfo(Map<String, dynamic> info) {
    saveData('AccessInfo', jsonEncode(info));
  }

  static AccessInfo? getAccessInfo() {
    var temp = getData('AccessInfo');
    return temp != null ? AccessInfo.fromJson(jsonDecode(temp)) : null;
  }

  static void saveDeviceInfo(Map<String, dynamic> info) {
    saveData('DeviceInfo', jsonEncode(info));
  }

  static UserDeviceInfo? getDeviceInfo() {
    var temp = getData('DeviceInfo');
    return temp != null ? UserDeviceInfo.fromJson(jsonDecode(temp)) : null;
  }

  static void saveSvUrl(String url) {
    saveData('svUrl', url);
  }

  static String? getSvUrl() {
    return getData('svUrl');
  }

  static void saveTestFilePath(String path) {
    saveData('testFilePath', path);
  }

  static String? getTestFilePath() {
    return getData('testFilePath');
  }

  static void saveLastExtractedFeature(String feat) {
    saveData('lastExtractedFeature', feat);
  }

  static String? getLastExtractedFeature() {
    return getData('lastExtractedFeature');
  }

  static void saveLastVerfyType(VerifyType type) {
    saveData('lastVerfyType', type == VerifyType.BLE ? 0 : 1);
  }

  static VerifyType getLastVerfyType() {
    var result = getData('lastVerfyType');
    if (result == null) {
      return VerifyType.BLE;
    } else {
      return result == 0 ? VerifyType.BLE : VerifyType.NFC;
    }
  }

  static void saveOpencvModelFilePath(String path) {
    saveData('opencvModelPath', path);
  }

  static String? getOpencvModelFilePath() {
    return getData('opencvModelPath');
  }

  static void saveMnnModelFilePath(String path) {
    saveData('mnnModelPath', path);
  }

  static String? getMnnModelFilePath() {
    return getData('mnnModelPath');
  }

  static void saveDeepLearningModelFilePath(String path) {
    saveData('deepLearningModelPath', path);
  }

  static String? getDeepLearningModelFilePath() {
    return getData('deepLearningModelPath');
  }

  static void saveTidList(List<TidModel>? tidList) {
    var temp = <String>[];
    if (tidList != null && tidList.isNotEmpty) {
      temp = [...tidList.map((e) => jsonEncode(e.toJson()))];
    } else {
      temp = [];
    }
    saveData('tidList', temp);
  }

  static List<TidModel>? getTidList() {
    var temp = getData('tidList');
    if (temp != null && temp is List && temp.isNotEmpty) {
      temp as List<String>;
      var tidList = [...temp.map((e) => TidModel.fromJson(jsonDecode(e)))];
      return tidList;
    } else {
      return null;
    }
  }

  static void saveUserCard(Map<String, dynamic> userCard) {
    saveData('userCard', jsonEncode(userCard));
  }

  static UserCardModel? getUserCard() {
    var temp = getData('userCard');
    return temp != null ? UserCardModel.fromJson(jsonDecode(temp)) : null;
  }

  static void saveUserEnvironment(Map<String, dynamic> userEnvrionment) {
    saveData('userEnvrionment', jsonEncode(userEnvrionment));
  }

  static UserEnvironmentModel? getUserEnvironment() {
    var temp = getData('userEnvrionment');
    return temp != null
        ? UserEnvironmentModel.fromJson(jsonDecode(temp))
        : null;
  }

  static void saveIsAgrred(bool val) {
    saveData('isAgrred', val);
  }

  static bool? getIsAgrred() {
    var result = getData('isAgrred');
    return result;
  }

  static void saveLanguage(String contryCode) {
    saveData('language', contryCode);
  }

  static Locale getLocale() {
    var temp = getData('language');
    return temp != null
        ? LanguageType.values
            .where((element) => element.name == temp)
            .single
            .locale
        : LanguageType.KR.locale;
  }
}
