import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/home/camera/ffi/native_ffi.dart' as native_ffi;

class InitRequest {
  SendPort toMainThread;
  ByteData markerPng;
  String path;
  InitRequest(
      {required this.toMainThread,
      required this.markerPng,
      required this.path});
}

class Request {
  int reqId;
  String method;
  dynamic params;
  Request({required this.reqId, required this.method, this.params});
}

class Response {
  int reqId;
  dynamic data;
  Response({required this.reqId, this.data});
}

late SendPort _toMainThread;
late _RequestThread _detector;

void init(InitRequest initReq) {
  _detector = _RequestThread(initReq.markerPng, initReq.path);

  _toMainThread = initReq.toMainThread;

  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  _toMainThread.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is Request) {
    dynamic res;
    switch (data.method) {
      case 'detect':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        res = _detector.detectTest(image, rotation);
        break;
      case 'destroy':
        _detector.destroy();
        break;
      default:
        log('Unknown method: ${data.method}');
    }

    _toMainThread.send(Response(reqId: data.reqId, data: res));
  }
}

class _RequestThread {
  _RequestThread(ByteData markerPng, String path) {
    inits(markerPng, path);
  }

  void inits(ByteData markerPng, String path) {
    final pngBytes = markerPng.buffer.asUint8List();
    native_ffi.initDetector(pngBytes, 36, path);
  }

  int? detectTest(CameraImage image, int rotation) {
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
    return native_ffi.detectTest(
        image.width, image.height, rotation, yBuffer, uBuffer, vBuffer);
  }

  destroy() {
    native_ffi.destroy();
  }
}
