/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/buildConfig/kolon_build_config.dart
 * Created Date: 2022-07-04 13:56:13
 * Last Modified: 2023-04-16 23:43:22
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:hwst/enums/language_type.dart';

class BioCubeBuildConfig {
  static const APP_VERSION_NAME = "1.0.0";
  static const APP_NAME = "HWST";
  static const APP_BASE_URL = "http://175.118.126.139/TruePass1.0/api";
  static const APP_BUILD_TYPE = "dev";
  static const SDK_VERSION = "1.2.0";
  static final TWO_WAY_MESSAGE_CHANNEL = 'myapp/twoWay';
  static final BASE_EVENT_CHANNEL = 'myapp/baseEventChannel';
  static final BASE_METHOD_CHANNEL = 'myapp/baseMethodChannel';
  static List<Locale> get appLocale =>
      [...LanguageType.values.map((type) => type.locale)];
}
