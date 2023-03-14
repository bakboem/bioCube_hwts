/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/user/user_evn_model.dart
 * Created Date: 2023-02-04 11:03:09
 * Last Modified: 2023-03-14 16:23:57
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'user_environment_model.g.dart';

@JsonSerializable()
class UserEnvironmentModel {
  bool? isUseNfc;
  bool? isUseBle;
  bool? isUseFace;
  bool? isUseFaceMore;
  int? useType; // 0 고정설치 1 개인용 2 얼굴+BLE 3 얼굴+NFC  (default 1)
  int? alarmType; // 0 진동 1 안내음성 2 소리.(default 1)
  String? rssi;
  int? sessionTime;

  UserEnvironmentModel(
      this.isUseBle,
      this.alarmType,
      this.isUseFace,
      this.isUseFaceMore,
      this.isUseNfc,
      this.useType,
      this.rssi,
      this.sessionTime);
  factory UserEnvironmentModel.fromJson(Object? json) =>
      _$UserEnvironmentModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserEnvironmentModelToJson(this);
}
