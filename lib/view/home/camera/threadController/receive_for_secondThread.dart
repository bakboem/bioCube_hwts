/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/view/home/camera/threadController/receive_thread_one_process copy.dart
 * Created Date: 2023-03-14 12:36:47
 * Last Modified: 2023-03-14 14:29:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:isolate';
import 'dart:developer';
import 'package:hwst/view/home/camera/ffi/native_ffi.dart' as native_ffi;

class InitRequestTwo {
  SendPort mainSendPortOne;

  InitRequestTwo({
    required this.mainSendPortOne,
  });
}

class RequestTwo {
  int reqId;
  String method;
  dynamic params;
  RequestTwo({required this.reqId, required this.method, this.params});
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
  _receiveThreadTwo = _ReceiveThreadTwo();

  _mainReceiveSendPort = initReq.mainSendPortOne;

  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  _mainReceiveSendPort.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is RequestTwo) {
    dynamic res;
    switch (data.method) {
      case 'match':
        var list = data.params['data'] as List;
        // request match
        break;
      case 'destroy':
        _receiveThreadTwo.destroy();
        break;
      default:
        log('Unknown method: ${data.method}');
    }
    _mainReceiveSendPort.send(ResponseTwo(reqId: data.reqId, data: res));
  }
}

class _ReceiveThreadTwo {
  _ReceiveThreadTwo() {
    inits();
  }

  void inits() {
    // final pngBytes = markerPng.buffer.asUint8List();
    // native_ffi.initDetector(
    //     pngBytes, 36, opencvModlePath, mnnModlePath, testOutputPath);
  }

  destroy() {
    native_ffi.destroy();
  }
}