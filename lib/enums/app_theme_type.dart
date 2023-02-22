/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/app_theme.dart
 * Created Date: 2021-09-01 20:12:58
 * Last Modified: 2023-02-22 22:42:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/styles/app_theme.dart';

enum AppThemeType {
  CARD_1,
  CARD_2,
  CARD_3,
}

extension ThemeTypeExtension on AppThemeType {
  ThemeData get theme {
    switch (this) {
      case AppThemeType.CARD_1:
        return Apptheme().appTheme.copyWith(
              textTheme: TextTheme(
                titleLarge: AppTextStyle.bold_18,
                headlineMedium: AppTextStyle.w500_16,
                headlineSmall: AppTextStyle.bold_16,
                displayLarge: AppTextStyle.default_14,
                displayMedium: AppTextStyle.sub_14,
                displaySmall: AppTextStyle.sub_12,
              ),
              colorScheme: Apptheme()
                  .appTheme
                  .colorScheme
                  .copyWith(primary: Color.fromARGB(255, 211, 209, 209)),
            );
      case AppThemeType.CARD_2:
        return Apptheme().appTheme.copyWith(
              textTheme: TextTheme(
                titleLarge: AppTextStyle.bold_18,
                headlineMedium: AppTextStyle.w500_16,
                headlineSmall: AppTextStyle.bold_16,
                displayLarge: AppTextStyle.default_14,
                displayMedium: AppTextStyle.sub_14,
                displaySmall: AppTextStyle.sub_12,
              ),
              colorScheme: Apptheme()
                  .appTheme
                  .colorScheme
                  .copyWith(primary: Color.fromARGB(255, 238, 201, 201)),
            );
      case AppThemeType.CARD_3:
        return Apptheme().appTheme.copyWith(
              textTheme: TextTheme(
                titleLarge: AppTextStyle.bold_18,
                headlineMedium: AppTextStyle.w500_16,
                headlineSmall: AppTextStyle.bold_16,
                displayLarge: AppTextStyle.default_14,
                displayMedium: AppTextStyle.sub_14,
                displaySmall: AppTextStyle.sub_12,
              ),
              colorScheme: Apptheme()
                  .appTheme
                  .colorScheme
                  .copyWith(primary: Color.fromARGB(255, 211, 238, 168)),
            );
    }
  }
}
