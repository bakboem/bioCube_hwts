/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/history/provider/history_page_provider.dart
 * Created Date: 2023-01-30 21:13:01
 * Last Modified: 2023-02-22 22:44:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/util/date_util.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:hwst/service/api_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/view/common/base_app_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/model/history/history_response_model.dart';

class HistoryPageProvider extends ChangeNotifier {
  int pos = 1;
  int partial = 50;
  bool hasMore = false;
  bool isLoadData = false;
  bool isCheckedAll = false;
  String? selectedStartDate;
  String? selectedEndDate;
  List<Map<VerifyType, bool>> checkBoxList = [
    {VerifyType.NFC: true},
    {VerifyType.BLE: true},
    {VerifyType.FACE: false},
    {VerifyType.QR_CODE: false},
    {VerifyType.FACE_BLE: false},
    {VerifyType.FACE_NFC: false},
  ];
  void reset() {
    responseModel = null;
    notifyListeners();
  }

  void setCheckBoxList(int index) {
    isCheckedAll = false;
    var temp = [...checkBoxList];
    var map = temp[index];
    temp.removeAt(index);
    temp.insert(index, {map.keys.single: !map.values.single});
    checkBoxList = [...temp];
    if (checkBoxList.where((element) => element.values.single).length ==
        checkBoxList.length) {
      isCheckedAll = true;
    }
    responseModel = null;
    pr(checkBoxList);
    notifyListeners();
  }

  void setIsCheckedAll() {
    isCheckedAll = !isCheckedAll;
    if (isCheckedAll) {
      var temp = [
        {VerifyType.NFC: true},
        {VerifyType.BLE: true},
        {VerifyType.FACE: true},
        {VerifyType.QR_CODE: true},
        {VerifyType.FACE_BLE: true},
        {VerifyType.FACE_NFC: true},
      ];
      checkBoxList = [...temp];
    } else {
      var temp = [
        {VerifyType.NFC: false},
        {VerifyType.BLE: false},
        {VerifyType.FACE: false},
        {VerifyType.QR_CODE: false},
        {VerifyType.FACE_BLE: false},
        {VerifyType.FACE_NFC: false},
      ];
      checkBoxList = [...temp];
    }
    responseModel = null;
    notifyListeners();
  }

  HistoryResponseModel? responseModel;
  final _api = ApiService();
  Future<void> init() async {
    selectedStartDate = DateUtil.prevWeek();
    selectedEndDate = DateUtil.today();
  }

  Future<ResultModel?> nextPage() async {
    if (hasMore) {
      pos++;
      return getHistoryData();
    }
    return null;
  }

  Future<ResultModel> refresh() async {
    pos = 1;
    hasMore = true;
    responseModel = null;
    return getHistoryData();
  }

  void setEndDate(BuildContext context, String? str) {
    DateUtil.checkDateIsBefore(context, selectedStartDate, str).then((before) {
      if (before) {
        var startData = DateUtil.getDate(selectedStartDate!);
        var endData = DateUtil.getDate(str!);
        var isOverThanOneYear = endData.difference(startData).inDays > 365;
        if (isOverThanOneYear) {
          AppToast().show(context, tr('cannot_be_older_than_one_year'));
          selectedEndDate = str;
          selectedStartDate = DateUtil.getDateStr('',
              dt: DateTime(endData.year - 1, endData.month, endData.day));
        } else {
          selectedEndDate =
              DateUtil.getDateStr(DateUtil.getDate(str).toIso8601String());
        }
        responseModel = null;
        notifyListeners();
      }
    });
  }

  void setStartDate(BuildContext context, String? str) {
    DateUtil.checkDateIsBefore(context, str, selectedEndDate).then((before) {
      if (before) {
        var startData = DateUtil.getDate(str!);
        var endData = DateUtil.getDate(selectedEndDate!);
        var isOverThanOneYear = endData.difference(startData).inDays > 365;
        if (isOverThanOneYear) {
          AppToast().show(context, tr('cannot_be_older_than_one_year'));
          selectedStartDate = str;
          selectedEndDate = DateUtil.getDateStr('',
              dt: DateTime(startData.year + 1, startData.month, startData.day));
        } else {
          selectedStartDate =
              DateUtil.getDateStr(DateUtil.getDate(str).toIso8601String());
        }
        responseModel = null;
        notifyListeners();
      }
    });
  }

  Future<ResultModel> getHistoryData() async {
    isLoadData = true;
    notifyListeners();
    final accessInfo = CacheService.getAccessInfo()!;
    final userCard = CacheService.getUserCard()!;
    // var index = radioList.indexOf(currenRadioStr!);
    if (checkBoxList.where((map) => map.values.single).isEmpty) {
      return ResultModel(false);
    }
    Map<String, dynamic> body = {
      'site_code': accessInfo.siteCode,
      'Search1': checkBoxList[0].values.single ? '1' : '0',
      'Search2': checkBoxList[1].values.single ? '1' : '0',
      'Search3': checkBoxList[2].values.single ? '1' : '0',
      'Search4': checkBoxList[3].values.single ? '1' : '0',
      'Search5': checkBoxList[4].values.single ? '1' : '0',
      'Search6': checkBoxList[5].values.single ? '1' : '0',
      'm_person': userCard.mPerson,
      'from_date': DateUtil.getDateStr(selectedStartDate!),
      'to_date': DateUtil.getDateStr(selectedEndDate!),
      'page': pos,
    };
    pr(body);
    _api.init(RequestType.ACCESS_HISTORY);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }

    if (result.statusCode == 200 && result.body['result'] == 'success') {
      var temp = HistoryResponseModel.fromJson(result.body);
      if (temp.data?.length != partial) {
        hasMore = false;
        pr('hasMore?????${hasMore}');
      }
      if (temp.data != null && temp.data!.isNotEmpty) {
        if (responseModel == null) {
          responseModel = temp;
        } else {
          var copy = responseModel;
          copy!.data!.addAll(temp.data!);
          responseModel = HistoryResponseModel.fromJson(copy.toJson());
        }
      }
      isLoadData = false;
      notifyListeners();
      return ResultModel(true);
    }
    responseModel = null;
    isLoadData = false;
    notifyListeners();
    return ResultModel(false);
  }
}
