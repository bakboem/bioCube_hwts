// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_environment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEnvironmentModel _$UserEnvironmentModelFromJson(
        Map<String, dynamic> json) =>
    UserEnvironmentModel(
      json['isUseBle'] as bool?,
      json['alarmType'] as int?,
      json['isUseFace'] as bool?,
      json['isUseFaceMore'] as bool?,
      json['isUseNfc'] as bool?,
      json['useType'] as int?,
      json['rssi'] as String?,
      json['sessionTime'] as int?,
    );

Map<String, dynamic> _$UserEnvironmentModelToJson(
        UserEnvironmentModel instance) =>
    <String, dynamic>{
      'isUseNfc': instance.isUseNfc,
      'isUseBle': instance.isUseBle,
      'isUseFace': instance.isUseFace,
      'isUseFaceMore': instance.isUseFaceMore,
      'useType': instance.useType,
      'alarmType': instance.alarmType,
      'rssi': instance.rssi,
      'sessionTime': instance.sessionTime,
    };
