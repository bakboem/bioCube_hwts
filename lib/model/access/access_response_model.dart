/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/home/access_key_response_model.dart
 * Created Date: 2023-01-24 00:20:31
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:hwst/model/user/user_card_model.dart';
part 'access_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AccessKeyResponseModel {
  String? result;
  String? errMsg;
  UserCardModel? data;
  AccessKeyResponseModel(this.result, this.errMsg, this.data);
  factory AccessKeyResponseModel.fromJson(Object? json) =>
      _$AccessKeyResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccessKeyResponseModelToJson(this);
}
