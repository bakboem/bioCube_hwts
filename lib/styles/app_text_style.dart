import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/globalProvider/app_theme_provider.dart';

// 각종 text 스타일 사전 정의.
class AppTextStyle {
  static TextTheme get currentTheme => KeyService.baseAppKey.currentContext!
      .watch<AppThemeProvider>()
      .themeData
      .textTheme;
  static TextStyle get h1 => currentTheme.titleLarge!;
  static TextStyle get h2 => currentTheme.displayLarge!;
  static TextStyle get h3 => currentTheme.displayMedium!;
  static TextStyle get h4 => currentTheme.displaySmall!;
  static TextStyle get h5 => currentTheme.bodyMedium!;
  static TextStyle get h6 => currentTheme.bodySmall!;

  static TextStyle get default_12 => TextStyle(
      fontSize: AppSize.fontSize(13),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText);
  static TextStyle get sub_12 => TextStyle(
      fontSize: AppSize.fontSize(13),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.subText);
  static TextStyle get small_sub => TextStyle(
      fontSize: AppSize.fontSize(10),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.subText);
  static TextStyle get default_14 => TextStyle(
      fontSize: AppSize.fontSize(15),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText);
  static TextStyle color14(Color color) => TextStyle(
      fontSize: AppSize.fontSize(15),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color);
  static TextStyle get sub_14 => TextStyle(
      fontSize: AppSize.fontSize(15),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.subText);
  static TextStyle get sub_16 => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.subText);
  static TextStyle get w500_14 => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      letterSpacing: -0.6,
      color: AppColors.subText);
  static TextStyle get w700_14 => TextStyle(
      fontSize: AppSize.fontSize(15),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      letterSpacing: -0.6,
      color: AppColors.subText);
  static TextStyle get spacing_14 => TextStyle(
      fontSize: AppSize.fontSize(15),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.subText,
      letterSpacing: -.5);
  static TextStyle get danger_14 => TextStyle(
        fontSize: AppSize.fontSize(15),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        color: AppColors.dangerColor,
      );
  static TextStyle get w500_16 => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.5);
  static TextStyle get bold_16 => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.5);
  static TextStyle get default_16 => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -0.4);
  static TextStyle get spacing_16 => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.5);
  static TextStyle color_16(Color color) => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color);
  static TextStyle colorW500_16(Color color) => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      letterSpacing: -0.4,
      color: color);
  static TextStyle get hint_16 => TextStyle(
      fontSize: AppSize.fontSize(17),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.textFieldUnfoucsColor,
      letterSpacing: -0.3);
  static TextStyle get w500_18 => TextStyle(
      fontSize: AppSize.fontSize(19),
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -0.4);

  static TextStyle menu_18(Color color) => TextStyle(
      fontSize: AppSize.fontSize(19),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color);
  static TextStyle get default_18 => TextStyle(
      fontSize: AppSize.fontSize(19),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText);
  static TextStyle color_18(Color color) => TextStyle(
      fontSize: AppSize.fontSize(19),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color);
  static TextStyle get hint_18 => TextStyle(
      fontSize: AppSize.fontSize(19),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.secondHintColor,
      letterSpacing: -0.3);
  static TextStyle get bold_18 => TextStyle(
      fontSize: AppSize.fontSize(19),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -0.4);
  static TextStyle get textField_18 => TextStyle(
      fontSize: AppSize.fontSize(19),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -0.4);
  static TextStyle get w500_20 => TextStyle(
      fontSize: AppSize.fontSize(21),
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.5);

  static TextStyle get default_20 => TextStyle(
      fontSize: AppSize.fontSize(22),
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText);
  static TextStyle get bold_20 => TextStyle(
      fontSize: AppSize.fontSize(22),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.5);
  static TextStyle get bold_22 => TextStyle(
      fontSize: AppSize.fontSize(22),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.5);
  static TextStyle get w500_22 => TextStyle(
      fontSize: AppSize.fontSize(24),
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.5);
  static TextStyle get bold30 => TextStyle(
      fontSize: AppSize.fontSize(32),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: AppColors.defaultText,
      letterSpacing: -.58);
  static TextStyle bold_20Color(Color color) => TextStyle(
      fontSize: AppSize.fontSize(22),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      letterSpacing: -0.48,
      color: color);
}
