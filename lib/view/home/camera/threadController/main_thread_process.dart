/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/view/home/camera/threadController/main_thread_process copy.dart
 * Created Date: 2023-03-14 13:29:53
 * Last Modified: 2023-03-14 13:36:33
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/service/local_file_servicer.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/common/fuction_of_capture_full_screen.dart';
import 'package:hwst/view/home/camera/threadController/receive_for_mainThread.dart';

class MainThread {
  bool isMainThreadReady = false;
  late Isolate _mainThreadIsolate;
  late SendPort _mainThreadSendPort;
  int _mainReqId = 0;
  final Map<int, Completer> _cbs = {};

  MainThread() {
    _initMainThread();
  }

  void _initMainThread() async {
    ReceivePort mainThreadReceiver = ReceivePort();
    mainThreadReceiver.listen(_handleMainThreadMessage, onDone: () {
      isMainThreadReady = false;
    });
// captrue full screen

    final bytes = await getBitmapFromContext();
    final dir = await LocalFileService().getLocalDirectory();
    final testOutputFile =
        await LocalFileService().createFile('${dir!.path}/test/test.png');
    pr(testOutputFile.path);
    final initReq = InitRequestOne(
        mainSendPortOne: mainThreadReceiver.sendPort,
        markerPng: bytes,
        opencvModelPath: CacheService.getOpencvModelFilePath()!,
        mnnModelPath: CacheService.getMnnModelFilePath()!,
        testOutputPath: testOutputFile.path);
    _mainThreadIsolate = await Isolate.spawn(
      initOne,
      initReq,
    );
  }

  Future<List<double>?> detectByMainThread(CameraImage image, int rotation) {
    if (!isMainThreadReady) {
      return Future.value(null);
    }

    var reqId = ++_mainReqId;
    var res = Completer<List<double>?>();
    _cbs[reqId] = res;
    var msg = RequestOne(
      reqId: reqId,
      method: 'detect',
      params: {'image': image, 'rotation': rotation},
    );

    _mainThreadSendPort.send(msg);
    return res.future;
  }

  void destroy() async {
    if (!isMainThreadReady) {
      return;
    }
    isMainThreadReady = false;
    var reqId = ++_mainReqId;
    var res = Completer();
    _cbs[reqId] = res;
    var msg = RequestOne(reqId: reqId, method: 'destroy');
    _mainThreadSendPort.send(msg);

    await res.future;
    _mainThreadIsolate.kill();
  }

  void _handleMainThreadMessage(data) {
    if (data is SendPort) {
      _mainThreadSendPort = data;
      isMainThreadReady = true;
      return;
    }

    if (data is ResponseOne) {
      var reqId = data.reqId;
      _cbs[reqId]?.complete(data.data);
      _cbs.remove(reqId);
      return;
    }
    log('Unknown message from , got: $data');
  }
}
