// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_all_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserAllResponseModel _$GetUserAllResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetUserAllResponseModel(
      json['result'] as String?,
      json['errMsg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => UserInfoTable.fromJson(e as Object))
          .toList(),
      json['totalCount'] as String?,
      json['pageSize'] as int?,
    );

Map<String, dynamic> _$GetUserAllResponseModelToJson(
        GetUserAllResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errMsg': instance.errMsg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'totalCount': instance.totalCount,
      'pageSize': instance.pageSize,
    };
