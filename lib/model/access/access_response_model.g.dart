// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessKeyResponseModel _$AccessKeyResponseModelFromJson(
        Map<String, dynamic> json) =>
    AccessKeyResponseModel(
      json['result'] as String?,
      json['errMsg'] as String?,
      json['data'] == null
          ? null
          : UserCardModel.fromJson(json['data'] as Object),
    );

Map<String, dynamic> _$AccessKeyResponseModelToJson(
        AccessKeyResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errMsg': instance.errMsg,
      'data': instance.data?.toJson(),
    };
