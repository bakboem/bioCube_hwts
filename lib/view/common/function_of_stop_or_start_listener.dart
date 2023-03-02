/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/function_of_stop_or_start_listener.dart
 * Created Date: 2022-10-26 08:36:49
 * Last Modified: 2023-03-02 18:58:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hwst/service/connect_service.dart';

Future<void> stopAllListener() async {
  ConnectService.stopListener();
}

void startAllListener() {
  ConnectService.startListener();
}
