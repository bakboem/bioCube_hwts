/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/common/method_of_show_location_faild_popup.dart
 * Created Date: 2023-01-29 11:19:38
 * Last Modified: 2023-03-02 19:00:03
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hwst/view/common/base_app_dialog.dart';

void showLocationFaildPopup(BuildContext context) async {
  final result = await AppDialog.showDangermessage(
      context, tr('not_use_location_permission_text'));
  if (result != null && result) {
    AppSettings.openLocationSettings();
  }
}
