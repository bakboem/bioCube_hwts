/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/deviceInfo_service.dart
 * Created Date: 2021-08-16 21:01:02
 * Last Modified: 2023-03-02 19:15:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:hwst/model/user/user_device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  factory DeviceInfoService() => _sharedInstance();
  static DeviceInfoService? _instance;
  DeviceInfoService._();
  static DeviceInfoService _sharedInstance() {
    _instance ??= DeviceInfoService._();
    return _instance!;
  }

  static Future<bool> isOverThanIphone10() async {
    var smallScreen = [
      'iPhone 6 Plus',
      'iPhone 6',
      'iPhone 6s',
      'iPhone 6s Plus',
      'iPhone SE (GSM)',
      'iPhone 7',
      'iPhone 7 Plus',
      'iPhone 8',
      'iPhone 8 Plus',
      'iPhone X Global',
      'iPhone X GSM',
    ];
    return await getDeviceInfo()
        .then((info) => !smallScreen.contains(info.deviceModel));
  }

  static Future<UserDeviceInfo> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    AndroidDeviceInfo androidInfo;
    IosDeviceInfo iosDeviceInfo;
    UserDeviceInfo? userDeviceInfo;
    if (Platform.isIOS) {
      var model = '';
      iosDeviceInfo = await deviceInfo.iosInfo;
      switch (iosDeviceInfo.utsname.machine) {
        case 'iPhone7,1':
          model = 'iPhone 6 Plus';
          break;
        case 'iPhone7,2':
          model = 'iPhone 6';
          break;
        case 'iPhone8,1':
          model = 'iPhone 6s';
          break;
        case 'iPhone8,2':
          model = 'iPhone 6s Plus';
          break;
        case 'iPhone8,4':
          model = 'iPhone SE (GSM)';
          break;
        case 'iPhone9,1':
          model = 'iPhone 7';
          break;
        case 'iPhone9,2':
          model = 'iPhone 7 Plus';
          break;
        case 'iPhone9,3':
          model = 'iPhone 7';
          break;
        case 'iPhone9,4':
          model = 'iPhone 7 Plus';
          break;
        case 'iPhone10,1':
          model = 'iPhone 8';
          break;
        case 'iPhone10,2':
          model = 'iPhone 8 Plus';
          break;
        case 'iPhone10,3':
          model = 'iPhone X Global';
          break;
        case 'iPhone10,4':
          model = 'iPhone 8';
          break;
        case 'iPhone10,5':
          model = 'iPhone 8 Plus';
          break;
        case 'iPhone10,6':
          model = 'iPhone X GSM';
          break;
        case 'iPhone11,2':
          model = 'iPhone XS';
          break;
        case 'iPhone11,4':
          model = 'iPhone XS Max';
          break;
        case 'iPhone11,6':
          model = 'iPhone XS Max Global';
          break;
        case 'iPhone11,8':
          model = 'iPhone XR';
          break;
        case 'iPhone12,1':
          model = 'iPhone 11';
          break;
        case 'iPhone12,3':
          model = 'iPhone 11 Pro';
          break;
        case 'iPhone12,5':
          model = 'iPhone 11 Pro Max';
          break;
        case 'iPhone12,8':
          model = 'iPhone SE 2nd Gen';
          break;
        case 'iPhone13,1':
          model = 'iPhone 12 Mini';
          break;
        case 'iPhone13,2':
          model = 'iPhone 12';
          break;
        case 'iPhone13,3':
          model = 'iPhone 12 Pro';
          break;
        case 'iPhone13,4':
          model = 'iPhone 12 Pro Max';
          break;
        case 'iPhone14,2':
          model = 'iPhone 13 Pro';
          break;
        case 'iPhone14,3':
          model = 'iiPhone 13 Pro Max';
          break;
        case 'iPhone14,4':
          model = 'iPhone 13 Mini';
          break;
        case 'iPhone14,5':
          model = 'iPhone 13';
          break;
        case 'iPhone14,6':
          model = 'iPhone SE 3rd Gen';
          break;
        case 'iPhone14,7':
          model = 'iPhone 14';
          break;
        case 'iPhone14,8 ':
          model = 'iPhone 14 Plus';
          break;
        case 'iPhone15,2':
          model = 'iPhone 14 Pro';
          break;
        case 'iPhone15,3':
          model = 'iPhone 14 Pro Max';
          break;
        default:
          model = 'iPhone';
      }
      userDeviceInfo = UserDeviceInfo(
          '${iosDeviceInfo.identifierForVendor}',
          'apple',
          '${iosDeviceInfo.utsname.nodename}',
          '${model}',
          '${iosDeviceInfo.systemVersion}');
    }
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;

      userDeviceInfo = UserDeviceInfo(
          '${androidInfo.id}',
          '${androidInfo.brand}',
          '${androidInfo.device}',
          '${androidInfo.model}',
          '${androidInfo.version.sdkInt}');
    }
    return userDeviceInfo!;
  }
}
