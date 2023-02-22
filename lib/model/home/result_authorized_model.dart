/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/home/authorized_model.dart
 * Created Date: 2023-01-24 11:06:35
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'result_authorized_model.g.dart';

@JsonSerializable()
class ResultAuthorizedModel {
  @JsonKey(name: 'site_code')
  String? siteCode;
  @JsonKey(name: 'm_person')
  String? mPerson;
  @JsonKey(name: 'mobile_id')
  String? mobileId;
  @JsonKey(name: 'l_tid')
  String? lTid;
  @JsonKey(name: 'l_type')
  String? lType;
  @JsonKey(name: 'l_date')
  DateTime? lDate;
  @JsonKey(name: 'l_gps')
  String? lGps;
  @JsonKey(name: 'l_result')
  String? lResult;
  @JsonKey(name: 'l_os')
  String? lOs;
  @JsonKey(name: 'l_serial')
  String? lSerial;
  @JsonKey(name: 'l_photo')
  String? lPhoto;
  int? p1;
  int? p2;
  int? p3;
  int? p4;
  int? p5;
  int? p6;
  int? p7;
  int? p8;
  int? p9;
  int? p10;
  int? p11;
  int? p12;
  int? p13;
  String? p14;

  ResultAuthorizedModel(
      {this.lDate,
      this.lGps,
      this.lOs,
      this.lPhoto,
      this.lResult,
      this.lSerial,
      this.lTid,
      this.lType,
      this.mPerson,
      this.mobileId,
      this.siteCode,
      this.p1,
      this.p2,
      this.p3,
      this.p4,
      this.p5,
      this.p6,
      this.p7,
      this.p8,
      this.p9,
      this.p10,
      this.p11,
      this.p12,
      this.p13,
      this.p14});
  factory ResultAuthorizedModel.fromJson(Object? json) =>
      _$ResultAuthorizedModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ResultAuthorizedModelToJson(this);
}
