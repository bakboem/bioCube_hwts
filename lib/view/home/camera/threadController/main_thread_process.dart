import 'dart:io';
import 'dart:isolate';
import 'dart:developer';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:hwst/view/home/camera/ffi/native_ffi.dart' as native_ffi;

class InitRequestOne {
  SendPort mainSendPortOne;
  ByteData markerPng;
  String opencvModelPath;
  String mnnModelPath;
  String testOutputPath;
  InitRequestOne(
      {required this.mainSendPortOne,
      required this.markerPng,
      required this.opencvModelPath,
      required this.mnnModelPath,
      required this.testOutputPath});
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

late SendPort _requestThread;
late _RequestThreadOne _requestThreadOne;

void initOne(InitRequestOne initReq) {
  _requestThreadOne = _RequestThreadOne(initReq.markerPng,
      initReq.opencvModelPath, initReq.mnnModelPath, initReq.testOutputPath);

  _requestThread = initReq.mainSendPortOne;

  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  _requestThread.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is Request) {
    dynamic res;
    switch (data.method) {
      case 'detect':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        res = _requestThreadOne.detectTest(image, rotation);
        break;
      case 'destroy':
        _requestThreadOne.destroy();
        break;
      default:
        log('Unknown method: ${data.method}');
    }
    _requestThread.send(Response(reqId: data.reqId, data: res));
  }
}

class _RequestThreadOne {
  _RequestThreadOne(ByteData markerPng, String opencvModlePath,
      String mnnModelPath, String testOutputPath) {
    inits(markerPng, opencvModlePath, mnnModelPath, testOutputPath);
  }

  void inits(ByteData markerPng, String opencvModlePath, String mnnModlePath,
      String testOutputPath) {
    final pngBytes = markerPng.buffer.asUint8List();
    native_ffi.initDetector(
        pngBytes, 36, opencvModlePath, mnnModlePath, testOutputPath);
  }

  List<double>? detectTest(CameraImage image, int rotation) {
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
