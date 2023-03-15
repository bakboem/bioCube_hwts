/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/bioCube/face_kit/truepass/lib/globalProvider/face_detection_provider.dart
 * Created Date: 2023-02-19 15:22:53
 * Last Modified: 2023-03-15 02:47:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hwst/util/date_util.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/service/api_service.dart';
import 'package:hwst/enums/hive_box_type.dart';
import 'package:hwst/service/hive_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/model/user/get_user_all_response_model.dart';

class FaceDetectionProvider extends ChangeNotifier {
  bool isFaceFinded = false;
  bool isShowFaceLine = false;
  double? cameraScale;
  List<double>? faceInfo;

  int pos = 1;
  int? totalCount;
  bool hasMore = true;
  bool isLoadData = false;
  String? downloadTime;
  String? saveTime;
  String? getDbDataTime;
  String? totalTime;
  String? dataLength;

  GetUserAllResponseModel? responseModel;
  void setIsFaceFinded(bool? val) {
    isFaceFinded = val ?? !isFaceFinded;
    notifyListeners();
  }

  void setCameraScale(double scale) {
    cameraScale = scale;
    notifyListeners();
  }

  void setFaceInfo(List<double> res) {
    faceInfo = res;
    notifyListeners();
  }

  void setIsShowFaceLine(bool val) {
    isShowFaceLine = val;
    notifyListeners();
  }

  void resetData() {
    responseModel = null;
    downloadTime = null;
    saveTime = null;
    getDbDataTime = null;
    notifyListeners();
  }

  Future<ResultModel> requestAllUserInfoData() async {
    // var complate = Completer();
    var time = DateTime.now();
    print('Http start at ::  ${time.toIso8601String()}');
    // complate.complete([await Future.doWhile(getUserDataForPageing)]);
    // await complate.future;
    await Future.doWhile(getUserDataForPageing);
    downloadTime = '${DateTime.now().difference(time).inMilliseconds}';
    print('Http stop at ::  $downloadTime');

    if (responseModel != null && responseModel!.data!.isNotEmpty) {
      pr(responseModel?.data?.length);
      time = DateTime.now();
      print('Hive Save start at ::  ${time.toIso8601String()}');
      HiveService.init(HiveBoxType.USER_INFO);
      await HiveService.updateAll(responseModel?.data);
      saveTime = '${DateTime.now().difference(time).inMilliseconds}';
      print('Hive Save stop at :: $saveTime');
      time = DateTime.now();
      print('Hive Get start at ::  ${time.toIso8601String()}');
      var result = await HiveService.getData((e) => e.imageData!.isNotEmpty);
      getDbDataTime = '${DateTime.now().difference(time).inMilliseconds}';
      print('Hive Get stop at ::  $getDbDataTime');
    }
    notifyListeners();
    return ResultModel(true);
  }

  Future<bool> getUserDataForPageing() async {
    if (!hasMore) return false;
    final _api = ApiService();
    final accessInfo = CacheService.getAccessInfo()!;
    HiveService.init(HiveBoxType.USER_INFO);
    var dbData = await HiveService.getData(
        (table) => table.mPhoto != null && table.mPhoto!.isNotEmpty);
    final lastUpdateDate =
        dbData != null && dbData.isNotEmpty ? dbData.first.updateDate : null;
    Map<String, dynamic> body = {
      'site_code': accessInfo.siteCode,
      'search_type': lastUpdateDate == null ? 1 : 2,
      'last_date': DateUtil.getDateStr(lastUpdateDate == null
          ? DateTime.now().toIso8601String()
          : lastUpdateDate.toIso8601String()),
      'current_page': pos,
    };
    pr('currnt Page $pos');
    _api.init(RequestType.GET_ALL_USER_INFO);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      responseModel = null;
      return false;
    }
    if (result.statusCode == 200 && result.body['result'] == 'success') {
      var temp = GetUserAllResponseModel.fromJson(result.body);
      totalCount ??= int.parse(temp.totalCount!);
      notifyListeners();
      print('totalCount  ${totalCount}');
      print('response Lenght :${responseModel?.data?.length}');
      if (totalCount != null &&
          responseModel != null &&
          responseModel!.data!.length + 1 == totalCount! - 1) {
        hasMore = false;
        pr('hasMore?????${hasMore}');
      }
      if (temp.data != null && temp.data!.isNotEmpty) {
        if (responseModel == null) {
          responseModel = temp;
        } else {
          var copy = responseModel;
          copy!.data!.addAll(temp.data!);
          responseModel = GetUserAllResponseModel.fromJson(copy.toJson());
          dataLength = '${responseModel!.data!.length}';
        }
        pos++;
      }
    }
    notifyListeners();
    return true;
  }
}
