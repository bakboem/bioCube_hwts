/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/hive_service.dart
 * Created Date: 2021-08-17 13:17:07
 * Last Modified: 2023-03-15 20:59:48
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hwst/enums/hive_box_type.dart';
import 'package:hwst/model/db/user_info_table.dart';

typedef SearchUserinfoConditional = bool Function(UserInfoTable);

class HiveService {
  factory HiveService() => _sharedInstance();
  static HiveService? _instance;
  HiveService._();
  static HiveService _sharedInstance() {
    _instance ??= HiveService._();
    return _instance!;
  }

  static HiveBoxType? cureenBoxType;
  static init(HiveBoxType boxType) {
    cureenBoxType = boxType;
  }

// * HiveBoxType 에 맞는 DB를 open 하기.
//* Hive특성 :
//* - 1개 이상 box를 open 할수 없다.
//* - 다른 box를 open 하기전에 현재 사용중인 box를 close 해야한다.
//* - box open 시 반드시 box Type을 지정해줘야한다.

  static Future<Box> getBox() async {
    switch (cureenBoxType!) {
      case HiveBoxType.USER_INFO:
        return await Hive.boxExists(cureenBoxType!.boxName)
            ? Hive.isBoxOpen(cureenBoxType!.boxName)
                ? Hive.box<UserInfoTable>(cureenBoxType!.boxName)
                : await Hive.openBox<UserInfoTable>(cureenBoxType!.boxName)
            : await Hive.openBox<UserInfoTable>(cureenBoxType!.boxName);
      default:
        return await Hive.box('${cureenBoxType!.boxName}');
    }
  }

  static Future<void> save(dynamic data) async {
    switch (cureenBoxType) {
      case HiveBoxType.USER_INFO:
        await getBox().then((box) {
          box as Box<UserInfoTable>;
          data as List<UserInfoTable>;
          box.addAll(data);
        });
        break;
      default:
        await getBox().then((box) {
          box as Box<String>;
          data as List<String>;
          box.addAll(data);
        });
    }
  }

  static Future<bool> isNeedUpdate() async {
    HiveService.init(HiveBoxType.USER_INFO);
    var box = await HiveService.getBox() as Box<UserInfoTable>;
    return box.values.isNotEmpty
        ? box.values.first.updateDate!.isAtSameMomentAs(DateTime.now())
        : true;
  }

  static Future<void> updateAll(List<UserInfoTable>? data) async {
    var tempNull = UserInfoTable(null, null, null, null);
    switch (cureenBoxType) {
      case HiveBoxType.USER_INFO:
        await getBox().then((box) {
          box as Box<UserInfoTable>;
          if (box.isEmpty && data != null) {
            box.addAll(data);
          } else {
            for (var table in data!) {
              var item = box.values.firstWhere(
                (element) => element.mPerson == table.mPerson,
                orElse: () => tempNull,
              );
              if (item != tempNull) {
                box.delete(item);
                box.add(table);
              }
            }
          }
        });
        break;
      default:
    }
  }

  static Future<List<UserInfoTable>?> getData(
      SearchUserinfoConditional conditional) async {
    if (!Hive.isBoxOpen(cureenBoxType!.boxName)) return null;
    switch (cureenBoxType) {
      case HiveBoxType.USER_INFO:
        return Hive.box<UserInfoTable>(cureenBoxType!.boxName)
            .values
            .where(conditional)
            .toList();
      default:
        return null;
    }
  }

  static Future<void> closeBox() async {
    if (Hive.isBoxOpen(cureenBoxType!.boxName))
      await Hive.box(cureenBoxType!.boxName).close();
  }

  static Future<void> deleteBox() async {
    if (await Hive.boxExists(cureenBoxType!.boxName)) {
      await Hive.deleteBoxFromDisk(cureenBoxType!.boxName);
    }
  }

  static Future<void> clearBox() async {
    if (Hive.isBoxOpen(cureenBoxType!.boxName))
      await Hive.box(cureenBoxType!.boxName).clear();
  }
}
