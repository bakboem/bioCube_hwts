/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/route.dart
 * Created Date: 2022-07-02 14:47:58
 * Last Modified: 2023-03-14 15:57:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:flutter/widgets.dart';
import 'package:hwst/view/card/card_page.dart';
import 'package:hwst/view/home/home_page.dart';
import 'package:hwst/view/info/info_page.dart';
import 'package:hwst/view/signin/signin_page.dart';
import 'package:hwst/view/setting/setting_page.dart';
import 'package:hwst/view/history/history_page.dart';
import 'package:hwst/view/terms/terms_of_user_page.dart';
import 'package:hwst/view/home/camera/camera_view_page.dart';
import 'package:hwst/view/terms/terms_of_privacy_policy.dart';

Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (context) => const HomePage(),
  CardPage.routeName: (context) => const CardPage(),
  InfoPage.routeName: (context) => const InfoPage(),
  SigninPage.routeName: (context) => const SigninPage(),
  SettingPage.routeName: (context) => const SettingPage(),
  HistoryPage.routeName: (context) => const HistoryPage(),
  TermsOfUserPage.routeName: (context) => const TermsOfUserPage(),
  TermsOfPrivacyPolicy.routeName: (context) => const TermsOfPrivacyPolicy(),
  CameraViewPage.routeName: (context) => const CameraViewPage()
};
