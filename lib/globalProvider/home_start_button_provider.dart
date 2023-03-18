/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/test/bioCube_truePass/lib/globalProvider/home_start_button_provider.dart
 * Created Date: 2023-03-17 20:40:05
 * Last Modified: 2023-03-18 10:58:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

class HomeStartButtonPorvider extends ChangeNotifier {
  int currenPage = 0;
  void setCurrenPage(int index) {
    currenPage = index;
    notifyListeners();
  }
}
