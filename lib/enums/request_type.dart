/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-01-28 15:03:49
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-02-23 00:22:56
 * @FilePath: /hwst/lib/enums/request_type.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/request_type.dart
 * Created Date: 2021-08-27 10:22:15
 * Last Modified: 2023-02-23 00:22:56
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hwst/buildConfig/biocube_build_config.dart';
import 'package:hwst/service/cache_service.dart';

enum RequestType {
  REGIST_ACCESS_KEY,
  SEND_MATCH_RESULT,
  ACCESS_HISTORY,
  GET_USER_CARD
}

extension RequestTypeExtension on RequestType {
  String get baseURL => BioCubeBuildConfig.APP_BASE_URL;
  String url({String? params}) {
    switch (this) {
      case RequestType.REGIST_ACCESS_KEY:
        return '$baseURL/regist_access_key.php';
      case RequestType.SEND_MATCH_RESULT:
        return '${CacheService.getSvUrl()}/api/send_auth_result.php';
      case RequestType.ACCESS_HISTORY:
        return '$baseURL/auth_list.php';
      case RequestType.GET_USER_CARD:
        return '$baseURL/get_mobile_user.php';
    }
  }

  String get httpMethod {
    switch (this) {
      default:
        return 'POST';
    }
  }

  bool get is_x_www_form_urlencoded {
    switch (this) {
      default:
        return true;
    }
  }

// api cancel시 사용 된는 구분자.
  String get tag {
    switch (this) {
      default:
        return "tag_${this.runtimeType}";
    }
  }

// 토큰 사용여부
  bool get isWithAccessToken {
    switch (this) {
      default:
        return false;
    }
  }
}
