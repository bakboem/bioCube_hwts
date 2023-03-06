/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/permission_service.dart
 * Created Date: 2021-08-13 11:38:37
 * Last Modified: 2023-03-04 12:42:23
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hwst/service/deviceInfo_service.dart';
import 'package:provider/provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';

typedef PermissionCallBack = bool Function(bool);

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
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
  ];

  // 권한 요청.
  static Future<bool> requestPermission(Permission permission) async {
    return await permission.request().isGranted;
  }

  static Future<void> requestLocationAndBle() async {
    await requestMore([
      ...getLocationPermisson,
      ...(Platform.isAndroid ? getAndroidBlePermission : getIosBlePermission)
    ]);
  }

  static Future<void> checkLocationAndBle() async {
    var context = KeyService.baseAppKey.currentContext;
    if (context == null) return;
    var dp = context.read<DeviceStatusProvider>();

    // ble
    var isGrantedBle = false;
    var isGrantedBleScan = false;
    var isGrantedBleConnect = false;
    var isGrantedBleAdvertise = false;
    // location
    var isGrantedLocation = false;
    var isGrantedLocationAlways = false;
    var isGrantedLocationWhenInUse = false;
    if (Platform.isAndroid) {
      final deviceInfo = CacheService.getDeviceInfo() ??
          await DeviceInfoService.getDeviceInfo();
      final isLessThan30 = int.parse(deviceInfo.deviceVersion) <= 30;
      await checkMore([
        ...getLocationPermisson,
        ...(isLessThan30 ? [Permission.bluetooth] : getAndroidBlePermission)
        // [Permission.bluetooth]:...getAndroidBlePermission)
      ], [
        (rs) => isGrantedLocation = rs,
        (rs) => isGrantedLocationAlways = rs,
        (rs) => isGrantedLocationWhenInUse = rs,
        ...(isLessThan30
            ? [(rs) => isGrantedBle = rs]
            : [
                (rs) => isGrantedBleScan = rs,
                (rs) => isGrantedBleConnect = rs,
                (rs) => isGrantedBleAdvertise = rs,
              ])
      ]);
      dp.setBleStatus(isLessThan30
          ? isGrantedBle
          : isGrantedBleConnect && isGrantedBleScan && isGrantedBleAdvertise);
      dp.setLocationStatus(isGrantedLocation ||
          isGrantedLocationAlways ||
          isGrantedLocationWhenInUse);
    } else {
      await checkMore([
        ...getLocationPermisson,
        Permission.bluetooth
        // [Permission.bluetooth]:...getAndroidBlePermission)
      ], [
        (rs) => isGrantedLocation = rs,
        (rs) => isGrantedLocationAlways = rs,
        (rs) => isGrantedLocationWhenInUse = rs,
        (rs) => isGrantedBle = rs
      ]);
      dp.setBleStatus(isGrantedBle);
      dp.setLocationStatus(isGrantedLocation ||
          isGrantedLocationAlways ||
          isGrantedLocationWhenInUse);
    }
  }

  static Future<void> checkMore(
      List<Permission> pmsList, List<PermissionCallBack> callback) async {
    await Future.forEach(
        pmsList,
        (pms) async =>
            await callback[pmsList.indexOf(pms)].call(await pms.isGranted));
  }

  static Future<void> requestMore(List<Permission> pmsList) async {
    var temp = <Permission>[];
    await Future.forEach(
        pmsList,
        (pms) async =>
            await pms.status.isGranted || await pms.status.isPermanentlyDenied
                ? DoNothingAction()
                : temp.add(pms));
    await Future.forEach(temp, (pms) async => await pms.request());
  }

  //  권한 상태 체크.
  static Future<bool> checkPermissionStatus(Permission permission) async {
    return await permission.status.isGranted;
  }
}
