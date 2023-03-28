/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/bioCube/face_kit/truepass/lib/globalProvider/face_detection_provider.dart
 * Created Date: 2023-02-19 15:22:53
 * Last Modified: 2023-03-28 19:37:47
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
import 'package:hwst/model/db/user_info_table.dart';
import 'package:hwst/util/date_util.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/service/api_service.dart';
import 'package:hwst/enums/hive_box_type.dart';
import 'package:hwst/service/hive_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/model/user/get_user_all_response_model.dart';
import 'package:hwst/view/home/camera/threadController/first_thread_process.dart';
import 'package:hwst/view/home/camera/threadController/second_thread_process.dart';

class FaceDetectionProvider extends ChangeNotifier {
  bool isFaceFinded = false;
  bool isShowFaceLine = false;
  double? cameraScale;
  List<double>? faceInfo;
  int pos = 1;
  int? totalCount;
  int? extractFeatrueCount;
  int extractFeatrueComplateCount = 0;
  bool hasMore = true;
  bool isLoadData = false;
  Duration downloadTime = Duration();
  Duration saveTime = Duration();
  Duration totalTime = Duration();
  GetUserAllResponseModel? responseModel;
  bool? isExtractFeatureDone;
  bool? isDownloadDone;
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

  Future<void> resetData() async {
    ApiService().cancel(RequestType.GET_ALL_USER_INFO.tag);
    pos = 1;
    totalCount = null;
    responseModel = null;
    hasMore = true;
    extractFeatrueComplateCount = 0;
    extractFeatrueCount = null;
    downloadTime = Duration();
    saveTime = Duration();
    totalTime = Duration();
    isExtractFeatureDone = false;

    notifyListeners();
  }

  void setIsExtractedFeature(bool val) {
    isExtractFeatureDone = val;
  }

  void setSaveTime(Duration duration) {
    saveTime += duration;
    totalTime = downloadTime + saveTime;
  }

  Future<ResultModel> requestAllUserInfoData(SecondThread extractThread) async {
    await Future.doWhile(getUserDataForPageing);
    startSaveData(extractThread);
    return ResultModel(true);
  }

  void startMatchData(FirstThread firstThread, String feat1) async {
    HiveService.init(HiveBoxType.USER_INFO);
    List<UserInfoTable>? temp = await HiveService.getData(
        (user) => user.imageData != null && (user.isExtracted ?? false));
    int count = 0;

    UserInfoTable? bestMatchUser;

    if (temp != null) {
      await Future.doWhile(() async {
        if (temp.isEmpty) return false;
        count++;
        var start = DateTime.now();
        var resultUser = await firstThread.matchFeature(temp[0], feat1,
            isReady: count == 0 ? true : null);
        if (resultUser != null) {
          pr('resultUser.score :::${resultUser.score}');
          if (bestMatchUser == null) {
            bestMatchUser = resultUser;
          }
          pr('score: ${resultUser.mPerson == 'MP00000026' ? 'MY:' : ''} ${bestMatchUser!.score}');
          if (resultUser.score! > bestMatchUser!.score!) {
            bestMatchUser = resultUser;
            pr('curren Score : ${bestMatchUser!.score}');
          }
          temp.removeWhere((user) => user.mPerson == resultUser.mPerson);
        }
        var endTime = DateTime.now().difference(start);
        pr('$count WorkTime :: ${endTime.inMilliseconds} inMilliseconds');
        return temp.isNotEmpty;
      }).whenComplete(() => pr(
          'The bestScore User Is : ${bestMatchUser!.mPerson} Score is:: ${bestMatchUser!.score}'));
    }
  }

  void startSaveData(SecondThread extractThread) async {
    if (responseModel != null && responseModel!.data!.isNotEmpty) {
      HiveService.init(HiveBoxType.USER_INFO);
      List<UserInfoTable> temp = responseModel!.data!
          .where(
              (user) => user.imageData!.isNotEmpty && user.mPhoto!.isNotEmpty)
          .toList();
      extractFeatrueCount = temp.length;
      List<UserInfoTable> noneImageList =
          responseModel!.data!.where((user) => user.mPhoto!.isEmpty).toList();

      await Future.doWhile(() async {
        var start = DateTime.now();
        var resultUser = await extractThread.extractFeature(temp[0]);
        if (resultUser != null) {
          HiveService.insert(resultUser);
          saveTime += DateTime.now().difference(start);
          temp.removeWhere((user) => user.mPerson == resultUser.mPerson);
          extractFeatrueComplateCount++;
          notifyListeners();
        } else {
          saveTime += DateTime.now().difference(start);
          notifyListeners();
        }
        return responseModel != null && temp.isNotEmpty;
      });
      await HiveService.save(noneImageList);
      isExtractFeatureDone = true;
      totalTime = downloadTime + saveTime;
      notifyListeners();
    }
  }

  Future<bool> getUserDataForPageing() async {
    if (!hasMore) {
      isDownloadDone = true;
      isExtractFeatureDone = false;
      notifyListeners();
      return false;
    }

    var start = DateTime.now();
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
          copy?.data?.addAll(temp.data!);
          responseModel = GetUserAllResponseModel.fromJson(copy!.toJson());
        }
        pos++;
      }
    }
    downloadTime += DateTime.now().difference(start);
    notifyListeners();
    return true;
  }
}
