/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/image_type.dart
 * Created Date: 2021-08-20 14:37:40
 * Last Modified: 2023-03-29 09:50:25
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

//* 이미지 url 사전 등록후 사용.

enum ImageType {
  SPLASH_ICON,
  TEXT_LOGO,
  COMPANY,
  APP_ACTIVITY_MANEGER,
  APP_ACTIVITY_SEARCH,
  APP_ORDER_MANEGER,
  APP_ORDER_SEARCH,
  APP_SALSE_REPORT,
  APP_BULK_ORDER_SEARCH,
  APP_DETAIL_BOOK,
  SETTINGS_ICON,
  EMPTY,
  SEARCH,
  SELECT,
  DELETE,
  DATA_PICKER,
  PLUS,
  MENU,
  PLUS_SMALL,
  INFO,
  SCROLL_TO_TOP,
  SCREEN_ROTATION,
  LAND_SPACE_PAGE_ICON,
  LAND_SPACE_PAGE_APPBAR_ICON,
  L_ICON,
  SELECT_RIGHT,
  DELETE_BOX,
  HWST,
  LOGO,
  PEOPLE,
  PEOPLE_WHITE,
  // BLE,
  // NFC,
  // LOCATION,
  // FACE,
  // TERMS1,
  // TERMS2,
  // LICENCE,
  DRAWER_HOME,
  DRAWER_HISTORY,
  DRAWER_MOBILE_CARD_ADD,
  DRAWER_MOBILE_CARD_INFO,
  DRAWER_HOME_ENVIRONMENT,
  DRAWER_HOME_TERMS_OF_USER,
  DRAWER_HOME_PRIVACY_POLICY,
  DRAWER_HOME_LICENCE,
  DRAWER_HOME_INFO,
  CARD_ONE,
  CARD_TWO,
  CARD_THREE,
  SUCCESS,
  FAILD
}

extension RequestTypeExtension on ImageType {
  String get path {
    switch (this) {
      case ImageType.INFO:
        return 'assets/images/info.svg';
      case ImageType.SUCCESS:
        return 'assets/images/success.png';
      case ImageType.FAILD:
        return 'assets/images/note.png';
      case ImageType.SETTINGS_ICON:
        return 'assets/images/icon_outlined_24_lg_1_settings.svg';
      case ImageType.SEARCH:
        return 'assets/images/icon_outlined_18_lg_3_search.svg';
      case ImageType.SELECT:
        return 'assets/images/icon_outlined_18_lg_3_down.svg';
      case ImageType.DELETE:
        return 'assets/images/icon_filled_18_lg_3_misuse.svg';
      case ImageType.DATA_PICKER:
        return 'assets/images/icon_outlined_18_lg_3_calendar.svg';
      case ImageType.PLUS:
        return 'assets/images/icon_outlined_24_lbp_3_add.svg';
      case ImageType.MENU:
        return 'assets/images/icon_outlined_24_lg_3_menu.svg';
      case ImageType.PLUS_SMALL:
        return 'assets/images/icon_outlined_18_lg_3_add.svg';
      case ImageType.HWST:
        return 'assets/images/hwst_full_logo.png';
      case ImageType.LOGO:
        return 'assets/images/hwst_color_full_logo.png';
      case ImageType.PEOPLE:
        return 'assets/images/people.png';
      case ImageType.PEOPLE_WHITE:
        return 'assets/images/people_white.png';
      case ImageType.SCROLL_TO_TOP:
        return 'assets/images/icon_outlined_24_lg_2_go_to_top.svg';
      // case ImageType.BLE:
      //   return 'assets/images/ble.png';
      // case ImageType.NFC:
      //   return 'assets/images/nfc.png';
      // case ImageType.LOCATION:
      //   return 'assets/images/location.png';
      case ImageType.SELECT_RIGHT:
        return 'assets/images/icon_outlined_18_lg_3_right.svg';
      // case ImageType.FACE:
      //   return 'assets/images/face.png';
      // case ImageType.TERMS1:
      //   return 'assets/images/terms1.png';
      // case ImageType.TERMS2:
      //   return 'assets/images/terms2.png';
      // case ImageType.LICENCE:
      //   return 'assets/images/licence.png';
      case ImageType.COMPANY:
        return 'assets/images/hwst_color_full_logo.png';
      case ImageType.CARD_ONE:
        return 'assets/images/background_one.png';
      case ImageType.CARD_TWO:
        return 'assets/images/background_two.png';
      case ImageType.CARD_THREE:
        return 'assets/images/background_three.png';
      default:
        return '';
    }
  }

// 홈화면에 icon을 텝 했을 때 route 하는 경로 사전 등록.
  String get routeName {
    switch (this) {
      default:
        return '';
    }
  }

  bool get isSvg {
    switch (this) {
      case ImageType.HWST:
        return false;
      case ImageType.LOGO:
        return false;
      case ImageType.PEOPLE:
        return false;
      case ImageType.PEOPLE_WHITE:
        return false;
      case ImageType.SUCCESS:
        return false;
      case ImageType.FAILD:
        return false;
      // case ImageType.BLE:
      //   return false;
      // case ImageType.NFC:
      //   return false;
      // case ImageType.LOCATION:
      //   return false;
      // case ImageType.FACE:
      //   return false;
      // case ImageType.TERMS1:
      //   return false;
      // case ImageType.TERMS2:
      //   return false;
      // case ImageType.LICENCE:
      //   return false;
      case ImageType.COMPANY:
        return false;
      default:
        return true;
    }
  }
}
