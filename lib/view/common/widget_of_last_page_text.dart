/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/last_page_text.dart
 * Created Date: 2022-01-24 23:57:34
 * Last Modified: 2023-02-22 22:42:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/styles/app_text.dart';
import 'package:hwst/styles/app_text_style.dart';

Widget lastPageText() {
  return Padding(
    padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing),
    child: Center(
      child:
          AppText.text('${tr('is_last_item')}', style: AppTextStyle.default_12),
    ),
  );
}
