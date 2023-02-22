/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/function_of_pop_to_first.dart
 * Created Date: 2022-10-07 15:16:07
 * Last Modified: 2023-02-22 22:40:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

void popToFirst(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
