/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/fountion_of_hidden_key_borad.dart
 * Created Date: 2022-07-06 10:50:08
 * Last Modified: 2023-02-22 22:40:57
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

Future<void> hideKeyboard(BuildContext context) async {
  var currentFocus = FocusScope.of(context);
  currentFocus.unfocus();
}
