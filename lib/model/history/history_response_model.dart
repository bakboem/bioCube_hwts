/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/history/history_response_model.dart
 * Created Date: 2023-01-31 09:50:53
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:hwst/model/history/history_model.dart';
part 'history_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HistoryResponseModel {
  String? result;
  String? errMsg;
  List<HistoryModel>? data;
  HistoryResponseModel(this.result, this.errMsg, this.data);
  factory HistoryResponseModel.fromJson(Object? json) =>
      _$HistoryResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$HistoryResponseModelToJson(this);
}
