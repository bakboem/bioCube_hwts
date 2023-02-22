/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/connect_service.dart
 * Created Date: 2022-10-26 05:30:46
 * Last Modified: 2023-02-22 22:40:53
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'package:provider/provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hwst/globalProvider/connect_status_provider.dart';

class ConnectService {
  factory ConnectService() => _sharedInstance();
  static ConnectService? _instance;
  ConnectService._();
  static ConnectService _sharedInstance() {
    _instance ??= ConnectService._();
    return _instance!;
  }

  static final Connectivity _connectivity = Connectivity();
  static late StreamSubscription<ConnectivityResult>? _connectSubscription;
  static stopListener() {
    _connectSubscription?.cancel();
  }

  static Future<void> startListener() async {
    _connectSubscription =
        _connectivity.onConnectivityChanged.listen((status) async {
      if (status == ConnectivityResult.mobile ||
          status == ConnectivityResult.wifi) {
        final cp =
            KeyService.baseAppKey.currentContext!.read<ConnectStatusProvider>();
        if (cp.streamController.hasListener) {
          cp.addSink(status);
        }
      }
    });
  }
}
