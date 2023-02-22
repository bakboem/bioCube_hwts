/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/signIn/signin_info.dart
 * Created Date: 2023-01-24 12:10:46
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'access_info.g.dart';

@JsonSerializable()
class AccessInfo {
  String? siteCode;
  String? loginType;
  String? loginAccount;
  String? accessKey;
  AccessInfo(this.siteCode, this.loginAccount, this.loginType, this.accessKey);
  factory AccessInfo.fromJson(Object? json) =>
      _$AccessInfoFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccessInfoToJson(this);
}
