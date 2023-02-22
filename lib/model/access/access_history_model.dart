/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/access/access_history_model.dart
 * Created Date: 2023-01-27 10:41:50
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'access_history_model.g.dart';

@JsonSerializable()
class AccessHistoryModel {
  @JsonKey(name: 'TL_site')
  String? tlSite;
  @JsonKey(name: 'L_date')
  String? lDate;
  @JsonKey(name: 'L_person')
  String? lPerson;
  @JsonKey(name: 'L_type')
  String? lType;
  @JsonKey(name: 'L_Cardkey')
  String? lCardkey;
  @JsonKey(name: 'L_tid')
  String? lTid;
  @JsonKey(name: 'L_result')
  String? lResult;
  @JsonKey(name: 'L_GPS')
  String? lGps;
  @JsonKey(name: 'L_photo')
  String? lPhoto;
  @JsonKey(name: 'L_OS')
  String? lOS;
  @JsonKey(name: 'L_phSerial')
  String? lPhSerial;
  @JsonKey(name: 'L_flag1')
  String? lFlag1;
  @JsonKey(name: 'L_date2')
  String? lDate2;
  @JsonKey(name: 'L_typeNm')
  String? lTypeNm;
  @JsonKey(name: 'L_resultNm')
  String? lResultNm;
  @JsonKey(name: 'L_flag1Nm')
  String? lFlag1Nm;
  @JsonKey(name: 'D_def')
  String? dDef;
  @JsonKey(name: 'D_defNm')
  String? dDefNm;

  AccessHistoryModel(
      this.dDef,
      this.dDefNm,
      this.lCardkey,
      this.lDate,
      this.lDate2,
      this.lFlag1,
      this.lFlag1Nm,
      this.lGps,
      this.lOS,
      this.lPerson,
      this.lPhSerial,
      this.lPhoto,
      this.lResult,
      this.lResultNm,
      this.lTid,
      this.lType,
      this.lTypeNm,
      this.tlSite);
  factory AccessHistoryModel.fromJson(Object? json) =>
      _$AccessHistoryModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccessHistoryModelToJson(this);
}
