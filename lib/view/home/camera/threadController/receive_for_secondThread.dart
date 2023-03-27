/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/view/home/camera/threadController/receive_thread_one_process copy.dart
 * Created Date: 2023-03-14 12:36:47
 * Last Modified: 2023-03-27 10:14:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:isolate';
import 'dart:developer';
import 'package:hwst/model/db/user_info_table.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/home/camera/ffi/native_ffi.dart' as native_ffi;

class InitRequestTwo {
  SendPort mainSendPortTwo;
  String mnnModelPath;
  String opencvPath;
  InitRequestTwo(
      {required this.mainSendPortTwo,
      required this.mnnModelPath,
      required this.opencvPath});
}

class RequestTwo {
  int reqId;
  String method;
  dynamic params;
  UserInfoTable? userModel;
  RequestTwo(
      {required this.reqId, required this.method, this.userModel, this.params});
}

class ResponseTwo {
  int reqId;
  dynamic data;
  ResponseTwo({required this.reqId, this.data});
}

//
late SendPort _mainReceiveSendPort;
late _ReceiveThreadTwo _receiveThreadTwo;

void initTwo(InitRequestTwo initReq) {
  _receiveThreadTwo =
      _ReceiveThreadTwo(initReq.mnnModelPath, initReq.opencvPath);

  _mainReceiveSendPort = initReq.mainSendPortTwo;

  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  _mainReceiveSendPort.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is RequestTwo) {
    dynamic res;
    switch (data.method) {
      case 'extractFeature':
        res = _receiveThreadTwo.extractFeature(data.userModel!);
        pr('return');

        break;
      case 'destroy':
        _receiveThreadTwo.destroy();
        break;
      default:
        log('Unknown method: ${data.method}');
    }
    _mainReceiveSendPort.send(ResponseTwo(
      reqId: data.reqId,
      data: res,
    ));
  }
}

class _ReceiveThreadTwo {
  _ReceiveThreadTwo(String mnnModelPath, String opencvPath) {
    inits(mnnModelPath, opencvPath);
  }

  void inits(String mnnPath, String opencvPath) {
    pr(mnnPath);
    pr(opencvPath);
    native_ffi.initMnnModel(mnnPath, opencvPath);
    pr('path is ######### loaded!');
  }

  UserInfoTable? extractFeature(UserInfoTable user) {
    return native_ffi.extractFeature(user);
  }

  void destroy() {
    native_ffi.destroy();
  }
}
