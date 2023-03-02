/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/base_info_row_by_key_and_value.dart
 * Created Date: 2021-10-03 02:10:59
 * Last Modified: 2023-03-02 19:15:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:hwst/enums/string_fomate_type.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/widget_of_text_row_model_by_key_value.dart';

/// [TextRowModelByKeyValue]
class BaseInfoRowByKeyAndValue {
  static Widget build(String title, String body,
      {bool? isWithShimmer,
      String? body2,
      String? body3,
      String? body4,
      int? shimmerRow,
      StringFormateType? formatType,
      bool? isWithShowAllButton,
      String? showAllButtonText,
      Widget? icon,
      bool? isWithEndShowAllButton,
      bool? isLeftIcon,
      Function? callback,
      bool? isTitleTowRow,
      bool? isWithMoneyAndUnit,
      String? discription2,
      double? leadingTextWidth,
      double? contentsTextWidth,
      double? showAllButtonWidth,
      int? maxLine,
      Color? exceptionColor,
      bool? isWithStar,
      TextStyle? style}) {
    return Padding(
      padding: AppSize.textRowModelLinePadding,
      child: TextRowModelByKeyValue(
        '$title',
        formatType != null
            ? isWithMoneyAndUnit != null
                ? formatType.formate('$body',
                    body2: body2, body3: body3, body4: body4)
                : body2 != null
                    ? formatType.formate('$body', body2: body2)
                    : formatType.formate('$body')
            : '$body',
        isWithShowAllButton ?? false,
        showAllButtonWidth: showAllButtonWidth,
        isWithEndShowAllButton ?? false,
        isLeftIcon: isLeftIcon,
        isWithShimmer: isWithShimmer,
        shimmerRow: shimmerRow,
        style: style,
        icon: icon,
        maxLine: maxLine,
        callback: callback,
        exceptionColor: exceptionColor != null
            ? exceptionColor
            : title == '${tr('office')}' ||
                    title == '${tr('driver')}' ||
                    title == '${tr('phone_number')}'
                ? AppColors.showAllTextColor
                : null,
        showAllButtonText: showAllButtonText,
        isTitleTwoRow: isTitleTowRow,
        discription2: discription2,
        isWithStar: isWithStar,
        leadingTextWidth: leadingTextWidth,
        contentsTextWidth: contentsTextWidth,
      ),
    );
  }
}
