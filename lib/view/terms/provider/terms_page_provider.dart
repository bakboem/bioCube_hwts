/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/terms/provider/terms_page_provider.dart
 * Created Date: 2023-01-27 22:51:34
 * Last Modified: 2023-02-22 22:44:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class TermsPageProvider extends ChangeNotifier {
  List<bool> checkedList = [false, false];
  bool get isValidate => !checkedList.contains(false);
  void setCheckList(int index) {
    checkedList[index] = !checkedList[index];
    notifyListeners();
  }
}
