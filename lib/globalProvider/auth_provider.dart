/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/login_provider.dart
 * Created Date: 2022-10-18 00:31:14
 * Last Modified: 2023-03-18 14:17:58
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/view/common/function_of_print.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogedin = false;
  bool? isTermsAgree;
  // UserEnvironmentModel? userEnvironmentModel;
  void setIsLogedIn(bool val) {
    isLogedin = val;
    if (!val) {
      isTermsAgree = false;
    } else {
      CacheService.saveIsAgrred(true);
      pr(' ?????? ${CacheService.getIsAgrred()}');
    }
    notifyListeners();
  }

  // void setUserEnvironment(UserEnvironmentModel evn) {
  //   userEnvironmentModel = evn;
  //   notifyListeners();
  // }

  void checkIsLogedIn(bool mounted) {
    if (CacheService.getUserCard() != null &&
        CacheService.getAccessInfo() != null) {
      isLogedin = true;
    }
  }

  void setIsTermsAgree(bool val) {
    isTermsAgree = val;
    notifyListeners();
  }
}
