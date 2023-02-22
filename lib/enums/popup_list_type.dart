/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/list_group_type.dart
 * Created Date: 2021-09-10 09:52:32
 * Last Modified: 2023-02-22 22:42:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/styles/app_size.dart';

typedef CommononeCellDataCallback = Future<List<String>?> Function();

enum OneCellType {
  DO_NOTHING,
  DATE_PICKER,
  DATE_PICKER_FORMONTH,
}

extension OneCellTypeExtension on OneCellType {
  String get title {
    switch (this) {
      default:
        return '${tr('search_condition')}';
    }
  }

  String get buttonText {
    switch (this) {
      default:
        return '${tr('close')}';
    }
  }

  Future<List<String>?> contents() async {
    switch (this) {
      default:
        return [];
    }
  }

  double get contentsHeight {
    switch (this) {
      default:
        return AppSize.secondPopupHeight;
    }
  }
}
