/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-02-24 16:22:08
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-02-26 12:49:38
 * @FilePath: /hwst/lib/service/native_channel_service.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/service/native_channel_service.dart
 * Created Date: 2023-01-25 11:52:53
 * Last Modified: 2023-02-25 23:58:20
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:hwst/globalProvider/timer_provider.dart';
import 'package:hwst/service/pass_kit_service.dart';
import 'package:hwst/service/thread_service.dart';
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
      if (message.startsWith('bleSuccess:') ||
          message.startsWith('nfcSuccess:')) {
        if (!tp.isPassKitTimerRunning) {
          tp.passKitProcess(PassKitService.updateToken,
              duration: Duration(seconds: 3));
        }
        var tid = message.substring(message.indexOf(':') + 1).trim();
        if (CacheService.getTidList() == null ||
            CacheService.getTidList()!
                .where((element) => element.svtid == tid)
                .isNotEmpty) {
          cp.setTid(tid);
          pr(tid);
          var setType = () {
            if (message.startsWith('nfcSuccess:')) {
              cp.setVerifyType(VerifyType.NFC);
            } else if (message.startsWith('bleSuccess:')) {
              cp.setVerifyType(VerifyType.BLE);
            }
          };
          final thread = ThreadService.one();
          Platform.isAndroid ? setType.call() : DoNothingAction();
          if (cp.isBackgroundMode && Platform.isAndroid) {
            thread.reuqest(Future.delayed(
                Duration.zero, () => cp.sendDataToSeverFromBackground()));
          } else {
            if (!tp.isRunning) {
              tp.perdict(
                Future.delayed(Duration.zero, () async {
                  cp.sendDataToSever().then((result) {
                    if (result.isSuccessful) {
                      cp.startTimer(
                          duration: message.startsWith('nfcSuccess:')
                              ? Duration(seconds: Platform.isAndroid ? 2 : 5)
                              : null);
                    }
                  });
                }),
              );
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
