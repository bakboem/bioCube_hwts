import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:hwst/view/home/camera/threadController/receive_for_secondThread.dart';

class SecondThread {
  bool isSecondThreadReady = false;
  late Isolate _secondThreadIsolate;
  late SendPort _secondThreadSendPort;
  int _secondReqId = 0;
  final Map<int, Completer> _cbs = {};
  final Map<int, Completer> _secondCbs = {};

  SecondThread() {
    _initSecondThread();
  }
  void _initSecondThread() async {
    ReceivePort secondThreadReceiver = ReceivePort();

    secondThreadReceiver.listen(_handleSecondThreadMessage, onDone: () {
      isSecondThreadReady = false;
    });
// captrue full screen

    final initReqTwo = InitRequestTwo(
      mainSendPortOne: secondThreadReceiver.sendPort,
    );
    _secondThreadIsolate = await Isolate.spawn(
      initTwo,
      initReqTwo,
    );
  }

  void secondThreadDestroy() async {
    if (!isSecondThreadReady) {
      return;
    }
    isSecondThreadReady = false;
    var reqId = ++_secondReqId;
    var res = Completer();
    _cbs[reqId] = res;
    var msg = RequestTwo(reqId: reqId, method: 'destroy');
    _secondThreadSendPort.send(msg);
    await res.future;
    _secondThreadIsolate.kill();
  }

  void _handleSecondThreadMessage(data) {
    if (data is SendPort) {
      _secondThreadSendPort = data;
      isSecondThreadReady = true;
      return;
    }
    if (data is ResponseTwo) {
      var reqId = data.reqId;
      _secondCbs[reqId]?.complete(data.data);
      _secondCbs.remove(reqId);
      return;
    }
    log('Unknown message from , got: $data');
  }
}
