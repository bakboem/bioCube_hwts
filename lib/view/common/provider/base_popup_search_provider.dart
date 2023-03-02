/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/provider/base_popup_search_provider.dart
 * Created Date: 2021-09-11 17:15:06
 * Last Modified: 2023-03-02 19:15:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/enums/popup_list_type.dart';
import 'package:hwst/model/common/result_model.dart';

class BasePopupSearchProvider extends ChangeNotifier {
  bool isLoadData = false;
  bool isFirestRun = true;
  bool isSingleData = false;
  bool? isShhowNotResultText;
  String? personInputText;
  String? keymanInputText;
  String? customerInputTextForAddActivityPage;
  String? suggetionItemNameInputText;
  String? suggetionItemGroupInputText;
  String? customerInputText;
  String? endCustomerInputText;
  String? selectedProductCategory;
  String? selectedProductFamily;
  String? selectedSalesGroup;
  String? seletedMaterialSearchKey;
  // String? seletedMateriaFamily;

  List<String>? productCategoryDataList;
  List<String>? productBusinessDataList;
  List<String>? productFamilyDataList;
  List<String>? materalItemDataList;
  OneCellType? type;
  Map<String, dynamic>? bodyMap;

//--------------- plant Code----------
  String? selectedOrganizationCode;
  String? seletedCirculationCode;
  bool get isOneRowValue2Selected => personInputText != null;

//------ pageing ----------
  int pos = 0;
  int partial = 30;
  bool hasMore = true;
  Future<void> refresh() async {
    pos = 0;
    hasMore = true;
    onSearch(type!, true);
  }

  Future<bool?> nextPage() async {
    if (hasMore) {
      pos = partial + pos;
      return onSearch(type!, false).then((result) => result.isSuccessful);
    }
    return null;
  }

  Future<ResultModel> onSearch(OneCellType typee, bool isMounted,
      {Map<String, dynamic>? bodyMaps}) async {
    type = typee;
    if (bodyMaps != null && bodyMaps != bodyMap && isFirestRun) {
      this.bodyMap = bodyMaps;
    }
    switch (type) {
      default:
        return ResultModel(false);
    }
  }
}
