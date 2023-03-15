/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/model/user/get_user_all_response_model.dart
 * Created Date: 2023-03-14 21:45:24
 * Last Modified: 2023-03-14 23:57:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hwst/model/db/user_info_table.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_user_all_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GetUserAllResponseModel {
  String? result;
  String? errMsg;
  List<UserInfoTable>? data;
  String? totalCount;
  int? pageSize;
  GetUserAllResponseModel(
      this.result, this.errMsg, this.data, this.totalCount, this.pageSize);
  factory GetUserAllResponseModel.fromJson(Object? json) =>
      _$GetUserAllResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GetUserAllResponseModelToJson(this);
}
