import 'dart:io';
import 'dart:isolate';
import 'dart:developer';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:hwst/model/db/user_info_table.dart';
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

class RequestOne {
  int reqId;
  String method;
  dynamic params;
  RequestOne({required this.reqId, required this.method, this.params});
}

class ResponseOne {
  int reqId;
  dynamic data;
  ResponseOne({required this.reqId, this.data});
}

late SendPort _mainReceiveSendPort;
late _ReceiveThreadOne _receiveThreadOne;

void initOne(InitRequestOne initReq) {
  _receiveThreadOne = _ReceiveThreadOne(initReq.markerPng,
      initReq.opencvModelPath, initReq.mnnModelPath, initReq.testOutputPath);

  _mainReceiveSendPort = initReq.mainSendPortOne;

  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  _mainReceiveSendPort.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is RequestOne) {
    dynamic res;
    switch (data.method) {
      case 'detect':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        res = _receiveThreadOne.detect(image, rotation);
        break;
      case 'matchFeature':
        var user = data.params['user'] as UserInfoTable;
        var feat = data.params['feat'] as String;
        res = _receiveThreadOne.matchFeature(user, feat);
        break;
      case 'startRecord':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        res = _receiveThreadOne.startRecord(image, rotation);
        break;
      case 'destroy':
        _receiveThreadOne.destroy();
        break;
      default:
        log('Unknown method: ${data.method}');
    }
    _mainReceiveSendPort.send(ResponseOne(reqId: data.reqId, data: res));
  }
}

class _ReceiveThreadOne {
  _ReceiveThreadOne(ByteData markerPng, String opencvModlePath,
      String mnnModelPath, String testOutputPath) {
    inits(markerPng, opencvModlePath, mnnModelPath, testOutputPath);
  }

  void inits(ByteData markerPng, String opencvModlePath, String mnnModlePath,
      String testOutputPath) {
    final pngBytes = markerPng.buffer.asUint8List();
    native_ffi.initDetector(
        pngBytes, 36, opencvModlePath, mnnModlePath, testOutputPath);
  }

  Map<String, dynamic>? detect(CameraImage image, int rotation) {
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

    return result;
  }

  bool? startRecord(CameraImage image, int rotation) {
    // in iOS the format is BGRA and we get a single buffer for all channels.
    // So the yBuffer variable on Android will be just the Y channel but on iOS it will be
    return true;
  }

  UserInfoTable? matchFeature(UserInfoTable user, String feat) {
    return native_ffi.matchFeature(user, feat);
  }

  void destroy() {
    native_ffi.destroy();
  }
}
