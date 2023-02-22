// ignore_for_file: deprecated_member_use

import 'app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hwst/styles/app_size.dart';

/// 기본 [ThemeData] 사전 정의 .
/// [AppThemeProvider] 의 base [ThemeData] 이기도 함.
/// .copyWith 함수를 통해 사용자 설정에 맏는 theme를 세팅 해줌.
class Apptheme {
  factory Apptheme() => _sharedInstance();
  static Apptheme? _instance;
  Apptheme._();
  static Apptheme _sharedInstance() {
    if (_instance == null) {
      _instance = Apptheme._();
    }
    return _instance!;
  }

  ThemeData appTheme = ThemeData(
      colorScheme: ColorScheme(
          primary: AppColors.primary,
          primaryVariant: AppColors.primary,
          secondary: AppColors.defaultText,
          secondaryVariant: AppColors.secondGreyColor,
          surface: AppColors.defaultText,
          background: AppColors.whiteText,
          error: AppColors.dangerColor,
          onPrimary: AppColors.whiteText,
          onSecondary: AppColors.primary,
          onSurface: AppColors.defaultText,
          onBackground: AppColors.defaultText,
          onError: AppColors.primary,
          brightness: Brightness.light),
      dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppSize.radius8)))));
}
