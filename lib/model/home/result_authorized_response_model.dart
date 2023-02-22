/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/home/authorized_response_model.dart
 * Created Date: 2023-01-24 11:03:52
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'result_authorized_response_model.g.dart';

@JsonSerializable()
class ResultAuthorizedResponseModel {
  String? result;
  String? errMsg;
  ResultAuthorizedResponseModel(this.result, this.errMsg);
  factory ResultAuthorizedResponseModel.fromJson(Object? json) =>
      _$ResultAuthorizedResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ResultAuthorizedResponseModelToJson(this);
}
