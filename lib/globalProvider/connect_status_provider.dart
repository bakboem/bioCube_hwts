/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/connect_status_provider.dart
 * Created Date: 2022-10-26 07:14:36
 * Last Modified: 2023-02-22 22:40:59
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:hwst/view/common/function_of_print.dart';

class ConnectStatusProvider extends ChangeNotifier {
  final streamController = StreamController<ConnectivityResult>();
  late StreamSink<ConnectivityResult>? streamdSink;
  Stream<ConnectivityResult>? stream;
  Future<ConnectivityResult?> get currenStream async =>
      await stream != null ? stream!.last : null;
  Future<bool> get checkFirstStatus async =>
      await InternetConnectionChecker().hasConnection;

  void addSink(ConnectivityResult result) async {
    stream ??= streamController.stream;
    streamdSink ??= streamController.sink;
    streamdSink!.add(result);
    if (await stream!.length > 2) {
      stream!.skip(2);
      pr('stream?.length  ${stream?.length}');
    }
  }

  Future<void> stopListener() async {
    streamController.close();
  }

  @override
  void dispose() {
    streamdSink?.close();
    streamController.close();
    super.dispose();
  }
}
