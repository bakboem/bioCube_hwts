// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessInfo _$AccessInfoFromJson(Map<String, dynamic> json) => AccessInfo(
      json['siteCode'] as String?,
      json['loginAccount'] as String?,
      json['loginType'] as String?,
      json['accessKey'] as String?,
    );

Map<String, dynamic> _$AccessInfoToJson(AccessInfo instance) =>
    <String, dynamic>{
      'siteCode': instance.siteCode,
      'loginType': instance.loginType,
      'loginAccount': instance.loginAccount,
      'accessKey': instance.accessKey,
    };
