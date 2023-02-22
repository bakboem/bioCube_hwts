/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/function_of_print.dart
 * Created Date: 2022-07-02 15:05:58
 * Last Modified: 2023-02-22 22:40:56
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/foundation.dart';

pr(dynamic str) {
  if (kDebugMode) {
    print('\n \n############\n' '$str' '\n' '############ \n\n');
  }
}
