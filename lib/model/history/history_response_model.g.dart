// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryResponseModel _$HistoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    HistoryResponseModel(
      json['result'] as String?,
      json['errMsg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => HistoryModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$HistoryResponseModelToJson(
        HistoryResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errMsg': instance.errMsg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };
