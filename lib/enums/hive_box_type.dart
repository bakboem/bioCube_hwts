/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/hive_box_type.dart
 * Created Date: 2021-09-09 13:28:48
 * Last Modified: 2023-02-22 22:42:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// * box == DB
// * DB 구분자.
enum HiveBoxType {
  T_CODE,
  T_VALUE,
  T_VALUE_COUNTRY,
  ET_CUSTOMER_CATEGORY,
  ET_CUSTOMER_CUSTOMS_INFO
}

//* DB name 사전 정의 후  Hive.OpenBox(dbName){} 으로 사용.
extension HiveBoxTypeExtension on HiveBoxType {
  String get boxName {
    switch (this) {
      case HiveBoxType.T_CODE:
        return 't_code';
      case HiveBoxType.T_VALUE:
        return 't_value';
      case HiveBoxType.T_VALUE_COUNTRY:
        return 'one_time';
      case HiveBoxType.ET_CUSTOMER_CATEGORY:
        return 'et_customer_category';
      case HiveBoxType.ET_CUSTOMER_CUSTOMS_INFO:
        return 'et_customer_customs_info';
    }
  }
}
