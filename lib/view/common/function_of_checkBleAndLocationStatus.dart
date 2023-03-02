/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/hwst/lib/view/common/function_of_checkBleAndLocationStatus.dart
 * Created Date: 2023-03-02 20:39:54
 * Last Modified: 2023-03-02 20:43:06
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void checkBleAndLocationStatus() async {
  final context = KeyService.baseAppKey.currentContext;
  if (context == null) return;
  var dp = context.read<DeviceStatusProvider>();
  PermissionService.requestPermission(Permission.location)
      .then(dp.setLocationStatus);
  PermissionService.checkBlePermission().then(dp.setBleStatus);
}
