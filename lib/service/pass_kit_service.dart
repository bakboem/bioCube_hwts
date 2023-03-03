/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/sm/koreajob/lib/service/pass_kit_service.dart
 * Created Date: 2023-01-22 10:14:14
 * Last Modified: 2023-03-03 11:00:21
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/service/native_channel_service.dart';
import 'package:hwst/globalProvider/core_verify_process_provider.dart';

class PassKitService {
  factory PassKitService() => _sharedInstance();
  static PassKitService? _instance;
  PassKitService._();
  static PassKitService _sharedInstance() {
    _instance ??= PassKitService._();
    return _instance!;
  }

  static Future<void> initKit({required bool isWithStartBle}) async {
    await NativeChannelService.methodChannel.invokeMethod('initState');
    setRssi();
    setSessionTime();
    isNfcOk();
    Platform.isAndroid ? await updateToken() : await saveToken();
    Platform.isAndroid ? await activeToken() : DoNothingAction();
    isWithStartBle
        ? Future.delayed(Duration(seconds: 1), () => startBle())
        : DoNothingAction();
  }

  static Future<String?> getToken() async {
    return await NativeChannelService.methodChannel.invokeMethod('getToken');
  }

  static Future<void> deleteToken() async {
    await NativeChannelService.methodChannel.invokeMethod('deleteToken');
  }

  static Future<void> saveToken() async {
    if (CacheService.getUserCard() != null) {
      await NativeChannelService.methodChannel.invokeMethod(
          'saveToken', CacheService.getUserCard()!.mCardKey ?? '');
      Platform.isAndroid ? await activeToken() : DoNothingAction();
    }
  }

  static Future<void> updateToken() async {
    setRssi();
    if (CacheService.getUserCard() != null) {
      await NativeChannelService.methodChannel.invokeMethod(
          'updateToken', CacheService.getUserCard()!.mCardKey ?? '');
      Platform.isAndroid ? await getToken() : DoNothingAction();
      Platform.isAndroid ? await activeToken() : DoNothingAction();
    }
  }

  static Future<void> isNfcOk() async {
    await NativeChannelService.methodChannel.invokeMethod('isNfcOk');
  }

  static Future<void> startBle() async {
    setRssi();
    setSessionTime();
    Platform.isAndroid ? updateToken() : saveToken();
    Platform.isAndroid ? activeToken() : DoNothingAction();
    final cp =
        KeyService.baseAppKey.currentContext!.read<CoreVerifyProcessProvider>();
    cp.setVerifyType(VerifyType.BLE);

    await NativeChannelService.methodChannel.invokeMethod('startBle');
  }

  static Future<void> startNfc() async {
    setRssi();
    setSessionTime();
    Platform.isAndroid ? updateToken() : saveToken();
    Platform.isAndroid ? activeToken() : DoNothingAction();
    final cp =
        KeyService.baseAppKey.currentContext!.read<CoreVerifyProcessProvider>();
    cp.setVerifyType(VerifyType.NFC);
    await NativeChannelService.methodChannel.invokeMethod('startNfc');
  }

  static Future<void> dispose() async {
    await NativeChannelService.methodChannel.invokeMethod('dispose');
  }

  static Future<void> activeToken() async {
    if (Platform.isAndroid) {
      await NativeChannelService.methodChannel.invokeMethod('activeToken');
    }
  }

  static Future<void> setRssi() async {
    if (Platform.isAndroid) {
      await NativeChannelService.methodChannel.invokeMethod(
          'setRssi',
          CacheService.getUserEnvironment() != null
              ? CacheService.getUserEnvironment()!.rssi ?? '-80'
              : '-80');
    }
  }

  static Future<void> setSessionTime() async {
    if (Platform.isAndroid) {
      await NativeChannelService.methodChannel.invokeMethod(
          'setSessionTime',
          CacheService.getUserEnvironment() != null
              ? CacheService.getUserEnvironment()!.sessionTime ?? 60
              : 60);
    }
  }

  static Future<void> disableToken() async {
    if (Platform.isAndroid) {
      await NativeChannelService.methodChannel.invokeMethod('disableToken');
    }
  }
}
