/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-02-01 10:23:22
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-02-26 15:52:44
 * @FilePath: /hwst/lib/service/pass_kit_service.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/hwst/lib/service/pass_kit_service.dart
 * Created Date: 2023-01-22 10:14:14
 * Last Modified: 2023-02-22 22:43:39
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';

import 'package:flutter/widgets.dart';
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

  static Future<void> initKit() async {
    await NativeChannelService.methodChannel.invokeMethod('initState');
    await setRssi();
    await isNfcOk();
    Platform.isAndroid ? await updateToken() : await saveToken();
    Platform.isAndroid ? await activeToken() : DoNothingAction();
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
    await setRssi();
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
    await setRssi();
    Platform.isAndroid ? await updateToken() : await saveToken();
    Platform.isAndroid ? await activeToken() : DoNothingAction();
    final cp =
        KeyService.baseAppKey.currentContext!.read<CoreVerifyProcessProvider>();
    cp.setVerifyType(VerifyType.BLE);

    await NativeChannelService.methodChannel.invokeMethod('startBle');
  }

  static Future<void> startNfc() async {
    await setRssi();
    Platform.isAndroid ? await updateToken() : await saveToken();
    Platform.isAndroid ? await activeToken() : DoNothingAction();
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
              ? CacheService.getUserEnvironment()!.rssi.toString()
              : '-40');
    }
  }

  static Future<void> disableToken() async {
    if (Platform.isAndroid) {
      await NativeChannelService.methodChannel.invokeMethod('disableToken');
    }
  }
}
