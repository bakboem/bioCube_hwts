/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/access/access_history_response_model.dart
 * Created Date: 2023-01-27 10:46:51
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:hwst/model/access/access_history_model.dart';
part 'access_history_response_model.g.dart';

@JsonSerializable()
class AccessHistoryResponseModel {
  String? result;
  String? errMsg;
  List<AccessHistoryModel>? data;

  AccessHistoryResponseModel(this.result, this.errMsg, this.data);
  factory AccessHistoryResponseModel.fromJson(Object? json) =>
      _$AccessHistoryResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccessHistoryResponseModelToJson(this);
}
