/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/permission_service.dart
 * Created Date: 2021-08-13 11:38:37
 * Last Modified: 2023-03-02 22:06:25
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:hwst/service/deviceInfo_service.dart';

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
  ];
  static var getAndroidBlePermission = [
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
  ];

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
    var isGranted = await checkPermissionStatus(Permission.location);
    if (isGranted) return true;
    isGranted = await checkPermissionStatus(Permission.locationAlways);
    if (isGranted) return true;
    isGranted = await checkPermissionStatus(Permission.locationWhenInUse);
    if (isGranted) {
      return true;
    } else {
      return await requestPermission(Permission.locationWhenInUse);
    }
  }

  // BLE 체크.
  static Future<bool> checkBlePermission() async {
    var isGranted = false;
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    if (Platform.isAndroid) {
      if (int.parse(deviceInfo.deviceVersion) <= 30) isGranted = true;
      if (int.parse(deviceInfo.deviceVersion) > 30) {
        var scanGranted = await checkPermissionStatus(Permission.bluetoothScan);
        var connectGranted =
            await checkPermissionStatus(Permission.bluetoothConnect);
        if (!scanGranted)
          scanGranted = await Permission.bluetoothScan
              .request()
              .then((status) => status.isGranted);
        if (!connectGranted)
          connectGranted = await Permission.bluetoothConnect
              .request()
              .then((status) => status.isGranted);
        isGranted = scanGranted && connectGranted;
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
