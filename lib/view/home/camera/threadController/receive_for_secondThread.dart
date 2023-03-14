/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/view/home/camera/threadController/receive_thread_one_process copy.dart
 * Created Date: 2023-03-14 12:36:47
 * Last Modified: 2023-03-14 13:11:52
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'dart:isolate';
import 'dart:developer';
import 'dart:typed_data';
import 'package:camera/camera.dart';
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

late SendPort _mainReceiveSendPort;
late _ReceiveThreadTwo _receiveThreadOne;

void initTwo(InitRequestTwo initReq) {
  _receiveThreadOne = _ReceiveThreadTwo();

  _mainReceiveSendPort = initReq.mainSendPortOne;

  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  _mainReceiveSendPort.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is RequestTwo) {
    dynamic res;
    switch (data.method) {
      case 'detect':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        res = _receiveThreadOne.detect(image, rotation);
        break;
      case 'destroy':
        _receiveThreadOne.destroy();
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

  List<double>? detect(CameraImage image, int rotation) {
    // in iOS the format is BGRA and we get a single buffer for all channels.
    // So the yBuffer variable on Android will be just the Y channel but on iOS it will be
    var planes = image.planes;
    var yBuffer = planes[0].bytes;

    Uint8List? uBuffer;
    Uint8List? vBuffer;
    if (Platform.isAndroid) {
      uBuffer = planes[1].bytes;
      vBuffer = planes[2].bytes;
    }
    var result = native_ffi.detectFrame(
        image.width, image.height, rotation, yBuffer, uBuffer, vBuffer);

    return result.toList();
  }

  destroy() {
    native_ffi.destroy();
  }
}
