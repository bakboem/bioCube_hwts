/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/hive_box_type.dart
 * Created Date: 2021-09-09 13:28:48
 * Last Modified: 2023-03-14 20:02:03
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// * box == DB
enum HiveBoxType { USER_INFO }

extension HiveBoxTypeExtension on HiveBoxType {
  String get boxName {
    switch (this) {
      case HiveBoxType.USER_INFO:
        return 'user_info';
    }
  }
}
