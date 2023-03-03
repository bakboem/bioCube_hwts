import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:hwst/service/cache_service.dart';
import 'request_thread_process.dart' as aruco_detector;

class ReceiveThread {
  bool arThreadReady = false;
  late Isolate _detectorThread;
  late SendPort _toDetectorThread;
  int _reqId = 0;
  final Map<int, Completer> _cbs = {};

  ReceiveThread() {
    _initDetectionThread();
  }

  void _initDetectionThread() async {
    ReceivePort fromDetectorThread = ReceivePort();
    fromDetectorThread.listen(_handleMessage, onDone: () {
      arThreadReady = false;
    });

    final bytes = await rootBundle.load('assets/images/marker.png');
    final initReq = aruco_detector.InitRequest(
        toMainThread: fromDetectorThread.sendPort,
        markerPng: bytes,
        path: CacheService.getFaceModelFilePath()!);
    _detectorThread = await Isolate.spawn(
      aruco_detector.init,
      initReq,
    );
  }

  Future<int?> detect(CameraImage image, int rotation) {
    if (!arThreadReady) {
      return Future.value(null);
    }

    var reqId = ++_reqId;
    var res = Completer<int?>();
    _cbs[reqId] = res;
    var msg = aruco_detector.Request(
      reqId: reqId,
      method: 'detect',
      params: {'image': image, 'rotation': rotation},
    );

    _toDetectorThread.send(msg);
    return res.future;
  }

  void destroy() async {
    if (!arThreadReady) {
      return;
    }

    arThreadReady = false;
    var reqId = ++_reqId;
    var res = Completer();
    _cbs[reqId] = res;
    var msg = aruco_detector.Request(reqId: reqId, method: 'destroy');
    _toDetectorThread.send(msg);

    await res.future;
    _detectorThread.kill();
  }

  void _handleMessage(data) {
    if (data is SendPort) {
      _toDetectorThread = data;
      arThreadReady = true;
      return;
    }

    if (data is aruco_detector.Response) {
      var reqId = data.reqId;

      _cbs[reqId]?.complete(data.data);
      _cbs.remove(reqId);
      return;
    }

    log('Unknown message from , got: $data');
  }
}
