/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/widget_of_table_box.dart
 * Created Date: 2023-01-28 13:20:03
 * Last Modified: 2023-02-22 22:44:44
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/styles/export_common.dart';

Widget buildTableBox(BuildContext context, String text, int index,
    {bool? isBody,
    AlignmentGeometry? alignmentt,
    bool? isTotalRow,
    bool? isWithRightPadding,
    bool? isLandSpace,
    double? leftPadding,
    double? rightPadding,
    bool? isHidenBottmBorder}) {
  var tempWidget = () {
    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: null,
            color: isBody != null && isBody
                ? isTotalRow != null && isTotalRow
                    ? AppColors.tableBorderColor.withOpacity(.2)
                    : AppColors.whiteText
                : AppColors.tableBorderColor.withOpacity(.2)),
        alignment: alignmentt != null
            ? alignmentt
            : isBody != null && isBody
                ? Alignment.centerLeft
                : Alignment.center,
        child: alignmentt != null
            ? Align(
                alignment: alignmentt,
                child: AppText.text(text,
                    style: isBody != null && isBody
                        ? AppTextStyle.default_14
                        : AppTextStyle.default_14.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 15),
                    textAlign: TextAlign.left,
                    maxLines: 100),
              )
            : AppText.text(text,
                style: isBody != null && isBody
                    ? AppTextStyle.default_14
                    : AppTextStyle.default_14
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                textAlign: TextAlign.left,
                maxLines: 100));
  };

  text = text.trim();
  return Tooltip(
    message: text,
    child: tempWidget(),
  );
}
