/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-02-17 10:31:28
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-02-28 13:27:32
 * @FilePath: /face_kit/truepass/lib/view/home/provider/home_page_provider.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/home/provider/home_page_provider.dart
 * Created Date: 2023-01-24 00:03:34
 * Last Modified: 2023-02-21 10:38:46
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:provider/provider.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/model/user/user_environment_model.dart';
import 'package:hwst/service/api_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/model/user/user_device_info.dart';
import 'package:hwst/service/deviceInfo_service.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/model/access/access_response_model.dart';

class HomePageProvider extends ChangeNotifier {
  int pos = 0;
  int partial = 100;
  bool hasMore = false;
  bool isLoadData = false;
  UserDeviceInfo? userDeviceInfo;

  void initUserEnvironment() {
    Future.delayed(Duration.zero, () async {
      final dp =
          KeyService.baseAppKey.currentContext!.read<DeviceStatusProvider>();
      dp.setIsOverThanIphone10();
      final ap = KeyService.baseAppKey.currentContext!.read<AuthProvider>();
      final userEvn = CacheService.getUserEnvironment() != null
          ? CacheService.getUserEnvironment()!
          : UserEnvironmentModel(true, 1, false, true, false, 1, '-80', 20);
      print('@@@@@${CacheService.getUserEnvironment()?.toJson()}');
      ap.setUserEnvironment(userEvn);
    });
  }

  Future<ResultModel> getUserCard() async {
    initUserEnvironment();
    userDeviceInfo = await DeviceInfoService.getDeviceInfo();
    try {
      isLoadData = true;
      notifyListeners();
    } catch (e) {
      pr(e);
    }
    final _api = ApiService();
    var info = CacheService.getAccessInfo()!;
    Map<String, dynamic> body = {
      'site_code': info.siteCode,
      'login_type': info.loginType,
      'login_value': info.loginAccount,
      'access_key': info.accessKey,
    };
    _api.init(RequestType.GET_USER_CARD);
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
        temp.data!.createDateByLocal = DateTime.now();
        CacheService.saveUserCard(temp.data!.toJson());
        pr('success');
        isLoadData = false;
        try {
          notifyListeners();
        } catch (e) {}
        return ResultModel(true);
      } else {
        isLoadData = false;
        try {
          notifyListeners();
        } catch (e) {}
        return ResultModel(false, errorMassage: temp.errMsg);
      }
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false);
  }
}
