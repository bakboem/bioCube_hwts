/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/key_service.dart
 * Created Date: 2022-07-02 14:53:52
 * Last Modified: 2023-02-22 22:40:53
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

class KeyService {
  factory KeyService() => _sharedInstance();
  static KeyService? _instance;
  KeyService._();
  static KeyService _sharedInstance() {
    _instance ??= KeyService._();
    return _instance!;
  }

  static GlobalKey<NavigatorState> baseAppKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> activityPageKey =
      GlobalKey<NavigatorState>();
  static GlobalKey screenKey = GlobalKey();
}
