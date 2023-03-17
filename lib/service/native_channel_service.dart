/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/truepass/lib/service/native_channel_service.dart
 * Created Date: 2023-01-25 11:52:53
 * Last Modified: 2023-03-17 17:17:13
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hwst/service/pass_kit_service.dart';
import 'package:provider/provider.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:hwst/globalProvider/timer_provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/service/thread_service.dart';
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

  static final BasicMessageChannel twoWayChannel = Platform.isAndroid
      ? BasicMessageChannel(
          BioCubeBuildConfig.TWO_WAY_MESSAGE_CHANNEL, StringCodec())
      : BasicMessageChannel(
          BioCubeBuildConfig.TWO_WAY_MESSAGE_CHANNEL, StandardMessageCodec());
  static final EventChannel eventChannel =
      EventChannel(BioCubeBuildConfig.BASE_EVENT_CHANNEL);
  static final MethodChannel methodChannel =
      MethodChannel(BioCubeBuildConfig.BASE_METHOD_CHANNEL);

  static Future<void> init() async {
    if (Platform.isIOS) {
      twoWayChannel.setMessageHandler(twoWayChannelHandler);
    } else {
      twoWayChannel.setMessageHandler(twoWayChannelHandler);
    }
  }

  static Future<void> twoWayChannelHandler(message) async {
    var context = KeyService.baseAppKey.currentContext;
    if (context != null) {
      final cp = context.read<CoreVerifyProcessProvider>();
      final dp = context.read<DeviceStatusProvider>();
      final tp = context.read<TimerProvider>();
      final isBlueSuccess = message.startsWith('bleSuccess:');
      final isNfcSuccess = message.startsWith('nfcSuccess:');
      if (isBlueSuccess || isNfcSuccess) {
        // if (!tp.isPassKitTimerRunning && isNfcSuccess) {
        //   tp.passKitProcess(PassKitService.updateToken,
        //       duration: Duration(seconds: 3));
        // }
        pr(message);
        cp.setLastVerfyType(isBlueSuccess ? VerifyType.BLE : VerifyType.NFC);
        final tid = message.substring(message.indexOf(':') + 1).trim();
        final isAuthorized = CacheService.getTidList() == null ||
            CacheService.getTidList()!
                .where((element) => element.svtid == tid)
                .isNotEmpty;
        if (isAuthorized) {
          cp.setTid(tid);
          pr(tid);
          var setType = () {
            if (isBlueSuccess) {
              cp.setVerifyType(VerifyType.BLE);
            } else if (isNfcSuccess) {
              cp.setVerifyType(VerifyType.NFC);
            }
          };
          final thread = ThreadService.one();
          Platform.isAndroid ? setType.call() : DoNothingAction();

          if (cp.isBackgroundMode && Platform.isAndroid && !tp.isRunning) {
            thread.reuqest(Future.delayed(
                Duration.zero, () => cp.sendDataToSeverFromBackground()));
          } else {
            if (!tp.isRunning) {
              tp.perdict(cp.sendDataToSever().then((result) {
                if (result.isSuccessful) {
                  cp.startTimer(
                      duration: message.startsWith('nfcSuccess:')
                          ? Duration(seconds: Platform.isAndroid ? 2 : 5)
                          : null);
                }
              }));
            }
          }
        } else {
          cp.setMessage('permisson_for_bidden');
          cp.startTimer();
        }
      } else if (message.startsWith('Is')) {
        pr('NFC::::: Status ${message}');
        if (message == 'Is Powered On') {
          dp.setNfcStatus(true);
        } else if (message == 'Is Not Support') {
          dp.setIsSuppertNfc(false);
        } else {
          dp.setNfcStatus(false);
        }
      } else {
        cp.setMessage(message);
      }
      return message;
    }
  }
}
