import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:hwst/model/db/user_info_table.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/home/camera/threadController/receive_for_secondThread.dart';

class SecondThread {
  bool isSecondThreadReady = false;
  late Isolate _secondThreadIsolate;
  late SendPort _secondThreadSendPort;
  int _secondReqId = 0;
  final Map<int, Completer> _cbs = {};

  SecondThread() {
    _initSecondThread();
  }
  void _initSecondThread() async {
    ReceivePort secondThreadReceiver = ReceivePort();
    secondThreadReceiver.listen(_handleSecondThreadMessage, onDone: () {
      isSecondThreadReady = false;
    });

    final initReqTwo = InitRequestTwo(
        mainSendPortTwo: secondThreadReceiver.sendPort,
        mnnModelPath: CacheService.getMnnModelFilePath()!,
        opencvPath: CacheService.getOpencvModelFilePath()!);
    _secondThreadIsolate = await Isolate.spawn(
      initTwo,
      initReqTwo,
    );
  }

  Future<UserInfoTable?> extractFaeture(UserInfoTable user) {
    if (!isSecondThreadReady) {
      pr('??? not ready!');
      return Future.value(null);
    }
    var reqId = ++_secondReqId;
    var res = Completer<UserInfoTable?>();
    _cbs[reqId] = res;
    var msg = RequestTwo(
      reqId: reqId,
      method: 'extractFeature',
      userModel: user,
    );
    _secondThreadSendPort.send(msg);
    return res.future;
  }

  void secondThreadDestroy({bool? killOnly}) async {
    if (!isSecondThreadReady) {
      return;
    }
    if (killOnly != null) {
      isSecondThreadReady = false;
      _secondThreadIsolate.kill();
    } else {
      isSecondThreadReady = false;
      var reqId = ++_secondReqId;
      var res = Completer();
      _cbs[reqId] = res;
      var msg = RequestTwo(reqId: reqId, method: 'destroy');
      _secondThreadSendPort.send(msg);
      await res.future;
      _secondThreadIsolate.kill();
    }
  }

  void _handleSecondThreadMessage(data) {
    if (data is SendPort) {
      pr('sendPort');
      _secondThreadSendPort = data;
      isSecondThreadReady = true;
      return;
    }
    if (data is ResponseTwo) {
      var reqId = data.reqId;
      _cbs[reqId]?.complete(data.data);
      _cbs.remove(reqId);
      return;
    }
    log('Unknown message from , got: $data');
  }
}
