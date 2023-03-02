// ignore_for_file: deprecated_member_use

/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/styles/app_text.dart
 * Created Date: 2022-07-03 14:42:12
 * Last Modified: 2023-03-02 19:14:57
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/globalProvider/app_theme_provider.dart';

class AppText {
  static text(
    String data, {
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) =>
      Text(data,
          style: style ?? AppTextStyle.default_16,
          textAlign: textAlign ?? TextAlign.center,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.ellipsis);

  static listViewText(String data,
          {TextStyle? style,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign,
          bool? isSubTitle}) =>
      Consumer<AppThemeProvider>(builder: (context, provider, _) {
        return Text(
          data,
          style: style != null
              ? style.copyWith(fontSize: AppTextStyle.h4.fontSize)
              : isSubTitle != null && style != null
                  ? style.copyWith(
                      fontSize:
                          provider.themeData.textTheme.headline4!.fontSize! - 2,
                      color: AppColors.subText)
                  : isSubTitle != null
                      ? provider.themeData.textTheme.headline4!.copyWith(
                          fontSize: provider
                                  .themeData.textTheme.headline4!.fontSize! -
                              2,
                          color: AppColors.subText)
                      : provider.themeData.textTheme.headline4,
          textAlign: textAlign ?? TextAlign.center,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.ellipsis,
        );
      });
}
