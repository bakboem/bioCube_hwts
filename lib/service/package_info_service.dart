/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/package_info_service.dart
 * Created Date: 2021-08-17 00:11:38
 * Last Modified: 2023-03-02 19:15:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:package_info_plus/package_info_plus.dart';

// 앱 Package 정보 호출.
class PackageInfoService {
  factory PackageInfoService() => _sharedInstance();
  static PackageInfoService? _instance;
  PackageInfoService._();
  static PackageInfoService _sharedInstance() {
    _instance ??= PackageInfoService._();
    return _instance!;
  }

  static Future<PackageInfo> getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
