/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/permission_service.dart
 * Created Date: 2021-08-13 11:38:37
 * Last Modified: 2023-03-02 19:24:45
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/service/deviceInfo_service.dart';
import 'package:hwst/service/key_service.dart';

//*  앱 권한 요청.
class PermissionService {
  static var getCameraAndPhotoLibrayPermisson = [
    Permission.camera,
    Permission.mediaLibrary
  ];
  static var getLocationPermisson = [
    Permission.location,
    Permission.locationAlways,
    Permission.locationWhenInUse
  ];
  static var getIosBlePermission = [
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
  ];
  static var getAndroidBlePermission = [
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
  ];
  // 위치 권한 상태 체크 및 요청.
  // static Future<bool?> checkLocationPermisson() async {
  //   return await requestPermission(Permission.location);
  // }

  // 포토 & 라이브러리 권한 부여상태 체크 및 요청.
  static Future<bool?> checkPhotoAndLibrayPermisson() async {
    List<bool> canUse = [];
    await Future.forEach(getCameraAndPhotoLibrayPermisson, (permission) async {
      // 권한 필요시 요청.
      if (await permission.isGranted) {
        canUse.add(true);
      } else {
        await requestPermission(permission).then((value) => canUse.add(true));
      }
    });
    return canUse.contains(false) ? false : true;
  }

  // 권한 요청.
  static Future<bool> requestPermission(Permission permission) async {
    return await permission.request().isGranted;
  }

  static Future<bool> checkLocationPermission() async {
    var temp1 =
        await PermissionService.checkPermissionStatus(Permission.location);
    var temp2 = await PermissionService.checkPermissionStatus(
        Permission.locationAlways);
    var temp3 = await PermissionService.checkPermissionStatus(
        Permission.locationWhenInUse);
    if (temp3) {
      Future.delayed(Duration(milliseconds: 200), () async {
        var baseContext = KeyService.baseAppKey.currentContext;
        final dp = baseContext?.read<DeviceStatusProvider>();
        await PermissionService.requestPermission(Permission.locationWhenInUse)
            .then((status) => baseContext != null
                ? dp!.setLocationStatus(status)
                : DoNothingAction());
      });
    }
    return temp1 || temp2 || temp3;
  }

  // BLE 체크.
  static Future<bool> checkBlePermission() async {
    var isGranted = false;
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    if (Platform.isAndroid) {
      if (int.parse(deviceInfo.deviceVersion) <= 30) {
        isGranted = await Permission.bluetooth.isGranted;
      }
      if (int.parse(deviceInfo.deviceVersion) > 30) {
        var scanGranted = await checkPermissionStatus(Permission.bluetoothScan);
        var connectGranted =
            await checkPermissionStatus(Permission.bluetoothConnect);
        var advertiseGranted =
            await checkPermissionStatus(Permission.bluetoothAdvertise);
        if (!scanGranted) {
          await Future.delayed(Duration(milliseconds: 300), () async {
            scanGranted = await requestPermission(Permission.bluetoothScan);
          });
        }
        if (!connectGranted) {
          await Future.delayed(Duration(milliseconds: 600), () async {
            connectGranted =
                await requestPermission(Permission.bluetoothConnect);
          });
        }

        if (!advertiseGranted) {
          await Future.delayed(Duration(milliseconds: 900), () async {
            advertiseGranted =
                await requestPermission(Permission.bluetoothAdvertise);
          });
        }
        isGranted = scanGranted && connectGranted && advertiseGranted;
      }
    } else {
      isGranted = await checkPermissionStatus(Permission.bluetooth);
    }
    return isGranted;
  }

  //  권한 상태 체크.
  static Future<bool> checkPermissionStatus(Permission permission) async {
    return await permission.status.isGranted;
  }
}
