/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/signin_type.dart
 * Created Date: 2023-01-25 19:36:47
 * Last Modified: 2023-02-22 22:44:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';

enum SigninType {
  EMAIL,
  PHONE_NUMBER,
}

extension VerifyTypeExtension on SigninType {
  String get code {
    switch (this) {
      case SigninType.EMAIL:
        return '1';
      case SigninType.PHONE_NUMBER:
        return '2';
    }
  }

  String get title {
    switch (this) {
      case SigninType.EMAIL:
        return tr('signin_with_email');
      case SigninType.PHONE_NUMBER:
        return tr('signin_with_phone_number');
    }
  }
}
