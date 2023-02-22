/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/provider/next_page_loading_provider.dart
 * Created Date: 2022-01-24 23:04:07
 * Last Modified: 2023-02-22 22:42:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class NextPageLoadingProvider extends ChangeNotifier {
  bool isShowLoading = false;
  void show() {
    isShowLoading = true;
    notifyListeners();
  }

  void stop() {
    isShowLoading = false;
    notifyListeners();
  }
}
