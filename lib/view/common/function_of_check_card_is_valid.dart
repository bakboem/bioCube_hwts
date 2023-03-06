/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/common/function_of_check_card_is_valid.dart
 * Created Date: 2023-02-04 10:26:09
 * Last Modified: 2023-03-04 10:42:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/view/common/base_app_dialog.dart';

Future<bool> isCardValidate(BuildContext context) async {
  final userCard = CacheService.getUserCard();
  if (userCard == null) return false;
  if (DateTime.parse(userCard.mCardKeyEdate!).isBefore(DateTime.now())) {
    final result =
        await AppDialog.showDangermessage(context, tr('access_key_expired'));
    if (result != null && result) {
      final ap = context.read<AuthProvider>();
      CacheService.deleteALL();
      ap.setIsLogedIn(false);
    }
  } else {
    return true;
  }
  return false;
}
