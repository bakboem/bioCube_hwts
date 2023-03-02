/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/provider/base_one_cell_popup_provider.dart
 * Created Date: 2021-10-17 23:22:48
 * Last Modified: 2023-03-02 19:15:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/view/common/base_popup_list.dart';

typedef AddressSelectedCity = String Function();

class OneCellPopupProvider extends ChangeNotifier {
  String? agencyTextControllerText;
  bool isLoadData = false;
  // bool ismounted = false;
  String? selectedCity;
  List<bool> checkBoxValueList = [];
  Future<bool> initCheckBoxList(List<String> dataList,
      {CheckBoxDefaultValue? checkBoxDefaultValue}) async {
    if (checkBoxDefaultValue != null) {
      var temp = await checkBoxDefaultValue.call();
      checkBoxValueList = temp;
      print(checkBoxValueList);
      return true;
    } else {
      dataList.forEach((data) {
        checkBoxValueList.add(false);
      });
      return true;
    }
  }

  void setAgencyTextControllerText(String str) {
    this.agencyTextControllerText = str;
    notifyListeners();
  }

  void whenTheCheckBoxValueChanged(int index) {
    checkBoxValueList[index] = !checkBoxValueList[index];
    notifyListeners();
  }
}

class BaseOneCellResult {
  bool isSuccessful;
  BaseOneCellResult(this.isSuccessful);
}
