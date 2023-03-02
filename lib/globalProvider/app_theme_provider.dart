/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/provider/app_theme_provider.dart
 * Created Date: 2021-09-01 20:12:58
 * Last Modified: 2023-03-02 19:15:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/enums/app_theme_type.dart';
import 'package:hwst/enums/language_type.dart';
import 'package:hwst/styles/app_theme.dart';

class AppThemeProvider with ChangeNotifier {
  AppThemeType themeType = AppThemeType.CARD_1;
  ThemeData themeData = Apptheme().appTheme;
  LanguageType? languageType;
  void setLanguageType({LanguageType? type, String? text}) {
    if (type != null) {
      languageType = type;
    }
    if (text != null) {
      languageType =
          LanguageType.values.where((item) => item.localText == text).single;
    }
    notifyListeners();
  }

  void setThemeType(AppThemeType type) {
    themeType = type;
    themeData = themeType.theme;
    notifyListeners();
  }
}
