// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessHistoryResponseModel _$AccessHistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    AccessHistoryResponseModel(
      json['result'] as String?,
      json['errMsg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => AccessHistoryModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$AccessHistoryResponseModelToJson(
        AccessHistoryResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errMsg': instance.errMsg,
      'data': instance.data,
    };
