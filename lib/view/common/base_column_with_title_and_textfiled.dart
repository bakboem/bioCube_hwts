/*
 * Filename: /Users/bakbeom/work/hwst/lib/view/common/base_
 * Path: /Users/bakbeom/work/hwst/lib/view/common
 * Created Date: Sunday, October 3rd 2021, 3:43:31 pm
 * Author: bakbeom
 * 
 * Copyright (c) 2021 KOLON GROUP.
 */

import 'package:flutter/widgets.dart';
import 'package:hwst/styles/export_common.dart';

class BaseColumWithTitleAndTextFiled {
  static Widget buildRowWithStart(String text,
      {bool? isNotshowStart, TextStyle? style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppText.listViewText('$text', style: style ?? AppTextStyle.h4),
        isNotshowStart != null
            ? Container(
                height: AppSize.zero,
              )
            : AppText.text(' *',
                style: AppTextStyle.color_16(AppColors.dangerColor)),
      ],
    );
  }

  static Widget build(
    String text,
    Widget input, {
    bool? isNotShowStar,
    TextStyle? style,
    Widget? input2,
  }) {
    // isNotShowStar   true : 필수 옵션 * 보여짐,  false: 필수 옵션 * 안보여짐.
    // isTextSize14 true: 폰트 크기 14, false 폰트 크기 16
    // input2 잠재고객페이지에서만 사용. 주소가 2줄일 경우 input 1개 추가.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRowWithStart(text, isNotshowStart: isNotShowStar, style: style),
        Padding(
          padding: EdgeInsets.only(
              top: AppSize.defaultSpacingForTitleAndTextField,
              bottom: AppSize.buttomPaddingForTitleAndTextField),
          child: input2 != null
              ? Column(
                  children: [
                    input,
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppSize.defaultListItemSpacing)),
                    input2
                  ],
                )
              : input,
        )
      ],
    );
  }
}
