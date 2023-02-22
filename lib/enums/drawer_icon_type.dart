/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/drawer_icon_type.dart
 * Created Date: 2023-02-02 13:42:00
 * Last Modified: 2023-02-22 22:44:50
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/card/card_page.dart';
import 'package:hwst/view/history/history_page.dart';
import 'package:hwst/view/info/info_page.dart';
import 'package:hwst/view/setting/setting_page.dart';
import 'package:hwst/view/terms/terms_of_privacy_policy.dart';
import 'package:hwst/view/terms/terms_of_user_page.dart';

enum DrawerIconType {
  HOME,
  HISTORY,
  MOBILE_CARD_INFO,
  ENVIRONMENT,
  TERMS_OF_USER,
  PRIVACY_POLICY,
  LICENCE,
  INFO,
}

extension DrawerIconTypeExtension on DrawerIconType {
  String get title {
    switch (this) {
      case DrawerIconType.HOME:
        return tr('home');
      case DrawerIconType.HISTORY:
        return tr('my_history');
      case DrawerIconType.MOBILE_CARD_INFO:
        return tr('mobile_card_info');
      case DrawerIconType.ENVIRONMENT:
        return tr('set_user_env');
      case DrawerIconType.TERMS_OF_USER:
        return tr('end_user_license_agreement_terms');
      case DrawerIconType.PRIVACY_POLICY:
        return tr('user_privacy_policy');
      case DrawerIconType.LICENCE:
        return tr('licence');
      case DrawerIconType.INFO:
        return tr('info');
      default:
        return '';
    }
  }

  String get routeName {
    switch (this) {
      case DrawerIconType.HISTORY:
        return HistoryPage.routeName;
      case DrawerIconType.MOBILE_CARD_INFO:
        return CardPage.routeName;
      case DrawerIconType.ENVIRONMENT:
        return SettingPage.routeName;
      case DrawerIconType.TERMS_OF_USER:
        return TermsOfUserPage.routeName;
      case DrawerIconType.PRIVACY_POLICY:
        return TermsOfPrivacyPolicy.routeName;
      case DrawerIconType.INFO:
        return InfoPage.routeName;
      default:
        return '';
    }
  }
}
