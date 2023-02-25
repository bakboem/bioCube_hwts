/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/service/native_channel_service.dart
 * Created Date: 2023-01-25 11:52:53
 * Last Modified: 2023-02-25 22:26:20
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/buildConfig/biocube_build_config.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/globalProvider/core_verify_process_provider.dart';

class NativeChannelService {
  factory NativeChannelService() => _sharedInstance();
  static NativeChannelService? _instance;
  NativeChannelService._();
  static NativeChannelService _sharedInstance() {
    _instance ??= NativeChannelService._();
    return _instance!;
  }

  static final BasicMessageChannel twoWayChannel = BasicMessageChannel(
      BioCubeBuildConfig.TWO_WAY_MESSAGE_CHANNEL, StringCodec());
  static final EventChannel eventChannel =
      EventChannel(BioCubeBuildConfig.BASE_EVENT_CHANNEL);
  static final MethodChannel methodChannel =
      MethodChannel(BioCubeBuildConfig.BASE_METHOD_CHANNEL);

  static Future<void> init() async {
    if (Platform.isIOS) {
      twoWayChannel.setMessageHandler(iosTwoWayChannelHandler);
    } else {
      twoWayChannel.setMessageHandler(androidTwoWayChannelHandler);
    }
  }

  static Future<void> iosTwoWayChannelHandler(message) async {
    var context = KeyService.baseAppKey.currentContext;
    if (context != null) {
      final cp = context.read<CoreVerifyProcessProvider>();
      final dp = context.read<DeviceStatusProvider>();
      if (message.startsWith('bleSuccess:') ||
          message.startsWith('nfcSuccess:')) {
        pr('1');
        var tid = message.substring(message.indexOf(':') + 1).trim();
        if (CacheService.getTidList() == null ||
            CacheService.getTidList()!
                .where((element) => element.svtid == tid)
                .isNotEmpty) {
          cp.setTid(tid).then((_) async {
            pr(cp.tid);
            await cp.sendDataToSever();
            cp.startTimer(
                duration: message.startsWith('nfcSuccess:')
                    ? Duration(seconds: 5)
                    : null);
          });
        } else {
          cp.setMessage('permisson_for_bidden');
          cp.startTimer();
        }
      } else if (message.startsWith('Is')) {
        pr('NFC::::: Status ${message}');
        if (message == 'Is Powered On') {
          dp.setNfcStatus(true);
        } else {
          dp.setNfcStatus(false);
        }
      } else if (message.contains('Timeout')) {
        cp.setMessage(tr('faild_with_time_out'));
        cp.startTimer();
      } else {
        cp.setMessage(message);
      }
      return message;
    }
  }

  static Future<void> androidTwoWayChannelHandler(message) async {
    var context = KeyService.baseAppKey.currentContext;
    pr('from native :::${message}');
    if (context != null) {
      final cp = context.read<CoreVerifyProcessProvider>();
      final dp = context.read<DeviceStatusProvider>();
      if (message.startsWith('bleSuccess:') ||
          message.startsWith('nfcSuccess:')) {
        var tid = message.substring(message.indexOf(':') + 1).trim();
        if (CacheService.getTidList() == null ||
            CacheService.getTidList()!
                .where((element) => element.svtid == tid)
                .isNotEmpty) {
          cp.setTid(tid).then((_) async {
            pr(cp.tid);
            await cp.sendDataToSever();
            cp.startTimer(
                duration: message.startsWith('nfcSuccess:')
                    ? Duration(seconds: Platform.isAndroid ? 2 : 5)
                    : null);
          });
        } else {
          cp.setMessage('permisson_for_bidden');
          cp.startTimer();
        }
      } else if (message.startsWith('Is')) {
        pr('NFC::::: Status ${message}');
        if (message == 'Is Powered On') {
          dp.setNfcStatus(true);
        } else {
          dp.setNfcStatus(false);
        }
      } else if (message.contains('Timeout')) {
        cp.setMessage(tr('faild_with_time_out'));
        cp.startTimer();
      } else {
        cp.setMessage(message);
      }
      return message;
    }
  }
}
