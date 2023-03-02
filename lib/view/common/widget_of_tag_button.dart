/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/base_tag_button.dart
 * Created Date: 2021-09-18 16:52:24
 * Last Modified: 2023-03-02 19:15:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/styles/export_common.dart';

class BaseTagButton {
  static Widget build(String text) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteText,
            borderRadius: BorderRadius.all(Radius.circular(13)),
            border: Border.all(color: AppColors.secondGreyColor, width: 1)),
        child: Padding(
          padding: AppSize.tageSidePadding,
          child: AppText.text('$text', style: AppTextStyle.sub_12),
        ));
  }
}
