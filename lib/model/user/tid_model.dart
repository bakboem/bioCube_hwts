/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/user/tid_model.dart
 * Created Date: 2023-02-08 11:44:06
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'tid_model.g.dart';

@JsonSerializable()
class TidModel {
  String? svtid;
  TidModel(this.svtid);
  factory TidModel.fromJson(Object? json) =>
      _$TidModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TidModelToJson(this);
}
