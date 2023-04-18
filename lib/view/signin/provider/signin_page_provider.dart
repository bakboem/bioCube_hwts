/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/signin/provider/signin_page_provider.dart
 * Created Date: 2023-01-25 12:36:45
 * Last Modified: 2023-04-18 12:22:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/enums/signin_type.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/model/user/user_environment_model.dart';
import 'package:hwst/service/api_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/model/access/access_info.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/service/deviceInfo_service.dart';
import 'package:hwst/util/regular.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/model/access/access_response_model.dart';

class SigninPageProvider extends ChangeNotifier {
  bool isLoadData = false;
  final _api = ApiService();
  SigninType signinType = SigninType.EMAIL;
  String? siteCodeInputStr;
  String? loginAccountInputStr;
  String? accessKeyInputStr;
  bool get isEmail => signinType == SigninType.EMAIL
      ? RegExpUtil.isMatch(loginAccountInputStr!, RegExpUtil.matchEmail)
      : true;
  List<SigninType> radioList = [SigninType.EMAIL, SigninType.PHONE_NUMBER];
  bool get isValidate =>
      (loginAccountInputStr != null && loginAccountInputStr!.isNotEmpty) &&
      (accessKeyInputStr != null && accessKeyInputStr!.isNotEmpty) &&
      (siteCodeInputStr != null && siteCodeInputStr!.isNotEmpty);
  AccessKeyResponseModel? accessKeyResponseModel;

  void setAccessKey(String? str) {
    accessKeyInputStr = str;
    if ((str != null && str.isEmpty) || str == null) {
      accessKeyInputStr = null;
      notifyListeners();
    }
    if (str != null && str.length < 2) {
      notifyListeners();
    }
  }

  void resetInputStr() {
    siteCodeInputStr = null;
    loginAccountInputStr = null;
    accessKeyInputStr = null;
    notifyListeners();
  }

  void setLoginAccount(String? str) {
    loginAccountInputStr = str;
    if ((str != null && str.isEmpty) || str == null) {
      loginAccountInputStr = null;
      notifyListeners();
    }
    if (str != null && str.length < 2) {
      notifyListeners();
    }
  }

  void setSigninType(SigninType type) {
    signinType = type;
    notifyListeners();
  }

  void setSiteCode(String? str) {
    siteCodeInputStr = str;
    if ((str != null && str.isEmpty) || str == null) {
      siteCodeInputStr = null;
      notifyListeners();
    }
    if (str != null && str.length < 2) {
      notifyListeners();
    }
  }

  Future<ResultModel> signIn() async {
    if (!isValidate) {
      pr('not validate');
      return ResultModel(false);
    }
    var userDeviceInfo = await DeviceInfoService.getDeviceInfo();
    Map<String, dynamic> body = {
      'site_code': siteCodeInputStr,
      'login_type': '${signinType.code}',
      'login_value': loginAccountInputStr,
      'access_key': accessKeyInputStr,
      'l_serial': userDeviceInfo.deviceId
    };

    pr(body);
    _api.init(RequestType.REGIST_ACCESS_KEY);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      var temp = AccessKeyResponseModel.fromJson(result.body);
      if (temp.result != 'error') {
        if (DateTime.parse(temp.data!.mCardKeyEdate!)
            .isBefore(DateTime.now())) {
          return ResultModel(false, errorMassage: 'accessKeyExpired');
        }

        if (accessKeyResponseModel == null) {
          accessKeyResponseModel = temp;
        }
        temp.data!.createDateByLocal = DateTime.now();
        var accessInfo = AccessInfo(siteCodeInputStr, loginAccountInputStr,
            signinType.code, accessKeyInputStr);
        var userEvn =
            UserEnvironmentModel(true, 1, false, false, true, 1, '-80', 20, 75);
        var deviceInfo = await DeviceInfoService.getDeviceInfo();
        CacheService.saveUserEnvironment(userEvn.toJson());
        CacheService.saveDeviceInfo(deviceInfo.toJson());
        CacheService.saveAccessInfo(accessInfo.toJson());
        CacheService.saveUserCard(temp.data!.toJson());
        CacheService.saveTidList(temp.data!.svTidList);
        if (temp.data!.svUrl != null && temp.data!.svUrl!.isNotEmpty) {
          CacheService.saveSvUrl(temp.data!.svUrl!);
        } else {
          return ResultModel(false, errorMassage: tr('sv_url_error'));
        }
        if (temp.data!.svTidList != null && temp.data!.svTidList!.isNotEmpty) {
          CacheService.saveTidList(temp.data!.svTidList);
        }
        try {
          notifyListeners();
        } catch (e) {}
        return ResultModel(true);
      } else {
        return ResultModel(false, errorMassage: temp.errMsg);
      }
    }
    return ResultModel(false);
  }
}
