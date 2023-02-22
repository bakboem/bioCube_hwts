// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDeviceInfo _$UserDeviceInfoFromJson(Map<String, dynamic> json) =>
    UserDeviceInfo(
      json['deviceId'] as String,
      json['deviceBrand'] as String,
      json['deviceName'] as String,
      json['deviceModel'] as String,
      json['deviceVersion'] as String,
    );

Map<String, dynamic> _$UserDeviceInfoToJson(UserDeviceInfo instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceBrand': instance.deviceBrand,
      'deviceName': instance.deviceName,
      'deviceModel': instance.deviceModel,
      'deviceVersion': instance.deviceVersion,
    };
