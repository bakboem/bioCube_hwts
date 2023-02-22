/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/popup_search_type.dart
 * Created Date: 2021-09-10 21:38:04
 * Last Modified: 2023-02-22 22:42:50
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/styles/app_size.dart';

import 'popup_list_type.dart';

// 팝업에 검색기능이 들어있을 경우 그 기능을 공통으로 사용 하기 위해 만든 enum.
enum PopupSearchType { SEARCH_SALSE_PERSON }

extension PopupSearchTypeExtension on PopupSearchType {
  List<String>? get hintText {
    switch (this) {
      default:
        return [];
    }
  }

// 팝업창 버튼의 문구를 설정해줍니다.
  String get buttonText {
    switch (this) {
      default:
        return '${tr('close')}'; // 디폴트 > 닫기 <
    }
  }

  List<OneCellType> get popupStrListType {
    switch (this) {
      default:
        return [];
    }
  }

  double get height {
    switch (this) {
      default:
        return AppSize.popHeight;
    }
  }

  double get appBarHeight {
    switch (this) {
      default:
        return AppSize.popupAppbarHeight + AppSize.secondButtonHeight;
    }
  }
}
