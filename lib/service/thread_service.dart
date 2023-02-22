/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/bioCube/face_kit/truepass/lib/util/thread_service.dart
 * Created Date: 2023-02-20 22:29:57
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

class ThreadService {
  late SendPort _sendPort;
  late Isolate _isolate;
  bool isOne = false;
  final _isolateReady = Completer<void>();
  final Map<Capability, Completer> _completers = {};
  ThreadService.one() {
    isOne = true;
    init();
  }

  ThreadService() {
    init();
  }

  void dispose() => _isolate.kill();

  Future reuqest(dynamic message) async {
    await _isolateReady.future;
    final completer = Completer();
    final requestId = Capability();
    _completers[requestId] = completer;
    _sendPort.send(new _RequestBody(requestId, message));
    return completer.future.then((_) => isOne ? dispose() : DoNothingAction());
  }

  Future<void> init() async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    errorPort.listen(print);
    receivePort.listen(_handleMessage);
    _isolate = await Isolate.spawn(
      _isolateEntry,
      receivePort.sendPort,
      onError: errorPort.sendPort,
    );
  }

  void _handleMessage(message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }
    if (message is _ResponseBody) {
      final completer = _completers[message.requestId];
      if (completer == null) {
        print("Invalid request ID received.");
      } else if (message.success) {
        completer.complete(message.message);
      } else {
        completer.completeError(message.message);
      }
      return;
    }
    throw UnimplementedError("Undefined behavior for message: $message");
  }

  static void _isolateEntry(dynamic message) {
    SendPort? sendPort;
    final receivePort = ReceivePort();
    receivePort.listen((dynamic message) async {
      if (message is _RequestBody) {
        print('receive message :${message.message}');
        sendPort?.send(_ResponseBody.ok(message.requestId, 'from receivePort'));
        return;
      }
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }
}

class _RequestBody {
  final Capability requestId;
  final dynamic message;
  const _RequestBody(this.requestId, this.message);
}

class _ResponseBody {
  final Capability requestId;
  final bool success;
  final dynamic message;
  const _ResponseBody.ok(this.requestId, this.message) : success = true;
}
