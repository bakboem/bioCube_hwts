import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/view/common/fuction_of_capture_full_screen.dart';
import 'request_thread_process.dart' as request_thread;

class ReceiveThread {
  bool arThreadReady = false;
  late Isolate _receiveThread;
  late SendPort _receiveThreadSendPort;
  int _reqId = 0;
  final Map<int, Completer> _cbs = {};

  ReceiveThread() {
    _initDetectionThread();
  }

  void _initDetectionThread() async {
    ReceivePort fromRequestThread = ReceivePort();
    fromRequestThread.listen(_handleMessage, onDone: () {
      arThreadReady = false;
    });
// captrue full screen

    final bytes = await getBitmapFromContext();
    final initReq = request_thread.InitRequest(
        requestThread: fromRequestThread.sendPort,
        markerPng: bytes,
        path: CacheService.getFaceModelFilePath()!);
    _receiveThread = await Isolate.spawn(
      request_thread.init,
      initReq,
    );
  }

  Future<List<double>?> detect(CameraImage image, int rotation) {
    if (!arThreadReady) {
      return Future.value(null);
    }

    var reqId = ++_reqId;
    var res = Completer<List<double>?>();
    _cbs[reqId] = res;
    var msg = request_thread.Request(
      reqId: reqId,
      method: 'detect',
      params: {'image': image, 'rotation': rotation},
    );

    _receiveThreadSendPort.send(msg);
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
    var msg = request_thread.Request(reqId: reqId, method: 'destroy');
    _receiveThreadSendPort.send(msg);

    await res.future;
    _receiveThread.kill();
  }

  void _handleMessage(data) {
    if (data is SendPort) {
      _receiveThreadSendPort = data;
      arThreadReady = true;
      return;
    }

    if (data is request_thread.Response) {
      var reqId = data.reqId;

      _cbs[reqId]?.complete(data.data);
      _cbs.remove(reqId);
      return;
    }

    log('Unknown message from , got: $data');
  }
}
