import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/enums/app_theme_type.dart';
import 'package:hwst/globalProvider/app_theme_provider.dart';
import 'package:hwst/service/key_service.dart';

class AppColors {
  static ThemeData get appTheme => KeyService.baseAppKey.currentContext!
      .read<AppThemeProvider>()
      .themeType
      .theme;
  static const Color primary = Color.fromARGB(255, 39, 151, 189);
  static const Color secondColor = Color(0xff7B1FA2);
  static Color themePrimary = appTheme.primaryColor;
  static const Color deepIconColor = Color(0xff193C5C);
  static const Color defaultText = Color(0xde141618);
  static const Color subText = Color(0x99141618);
  static const Color appBarIconColor = Color(0xff666666);
  static const Color accessKeyTextColor = Color.fromARGB(255, 78, 201, 223);
  static const Color whiteText = Color(0xffffffff);
  static const Color unReadyText = Color(0x4d141618);
  static const Color unReadyBg = Color(0xffecf1ff);
  static const Color unReadySigninBg = Color(0xfff0f0f0);
  static const Color cancelIcon = Color(0xff999999);
  static const Color textFieldUnfoucsColor = Color(0xff999999);
  static const Color textGrey = Color.fromRGBO(190, 190, 190, 1);
  static const Color unReadyButton = Color(0xfff0f0f0);
  static const Color hintText = Color(0x4d141618);
  static const Color dangerColor = Color.fromRGBO(233, 89, 80, 1);
  static const Color suggestionBorderColor = Color(0xcccccccc);
  static const Color homeBgColor = Color(0xfff2f4f7);
  static const Color secondGreyColor = Color.fromARGB(255, 194, 193, 193);
  static const Color defaultBoxBgColor = Color(0xfff5f5f5);
  static const Color lightBlueColor = Color(0xffecf1ff);
  static const Color blueTextColor = Color(0xff4A95C0);
  static const Color blueBorderColor = Color(0xffa9befc);
  static const Color showAllTextColor = Color(0xff4A95C0);
  static const Color tableBackgroundColor = Color.fromARGB(0, 234, 232, 232);
  static const Color tableBorderColor = Color(0x66cccccc);
  static const Color unReadyButtonBorderColor = Color(0xffcccccc);
  static const Color card1BgColor = Color.fromARGB(255, 225, 229, 229);
  static const Color shadowColor = Color(0x47000000);
  static const Color secondHintColor = Color(0x99141618);
}
