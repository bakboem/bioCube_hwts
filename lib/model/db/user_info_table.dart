/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/model/db/user_info_table.dart
 * Created Date: 2023-03-14 20:10:24
 * Last Modified: 2023-03-17 14:40:25
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_info_table.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class UserInfoTable {
  @HiveField(1)
  @JsonKey(name: 'M_person')
  String? mPerson;
  @HiveField(2)
  @JsonKey(name: 'M_photo')
  String? mPhoto;
  @HiveField(3)
  @JsonKey(name: 'Adate')
  DateTime? updateDate;
  @HiveField(4)
  @JsonKey(name: 'M_photo_base64')
  String? imageData;
  @HiveField(5)
  List<double>? feature;
  @HiveField(6)
  bool? isExtracted;
  UserInfoTable(this.mPerson, this.mPhoto, this.updateDate, this.imageData,
      this.feature, this.isExtracted);
  factory UserInfoTable.fromJson(Object? json) =>
      _$UserInfoTableFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserInfoTableToJson(this);
}
