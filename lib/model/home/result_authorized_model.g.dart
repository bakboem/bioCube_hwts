// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_authorized_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultAuthorizedModel _$ResultAuthorizedModelFromJson(
        Map<String, dynamic> json) =>
    ResultAuthorizedModel(
      lDate: json['l_date'] == null
          ? null
          : DateTime.parse(json['l_date'] as String),
      lGps: json['l_gps'] as String?,
      lOs: json['l_os'] as String?,
      lPhoto: json['l_photo'] as String?,
      lResult: json['l_result'] as String?,
      lSerial: json['l_serial'] as String?,
      lTid: json['l_tid'] as String?,
      lType: json['l_type'] as String?,
      mPerson: json['m_person'] as String?,
      mobileId: json['mobile_id'] as String?,
      siteCode: json['site_code'] as String?,
      p1: json['p1'] as int?,
      p2: json['p2'] as int?,
      p3: json['p3'] as int?,
      p4: json['p4'] as int?,
      p5: json['p5'] as int?,
      p6: json['p6'] as int?,
      p7: json['p7'] as int?,
      p8: json['p8'] as int?,
      p9: json['p9'] as int?,
      p10: json['p10'] as int?,
      p11: json['p11'] as int?,
      p12: json['p12'] as int?,
      p13: json['p13'] as int?,
      p14: json['p14'] as String?,
    );

Map<String, dynamic> _$ResultAuthorizedModelToJson(
        ResultAuthorizedModel instance) =>
    <String, dynamic>{
      'site_code': instance.siteCode,
      'm_person': instance.mPerson,
      'mobile_id': instance.mobileId,
      'l_tid': instance.lTid,
      'l_type': instance.lType,
      'l_date': instance.lDate?.toIso8601String(),
      'l_gps': instance.lGps,
      'l_result': instance.lResult,
      'l_os': instance.lOs,
      'l_serial': instance.lSerial,
      'l_photo': instance.lPhoto,
      'p1': instance.p1,
      'p2': instance.p2,
      'p3': instance.p3,
      'p4': instance.p4,
      'p5': instance.p5,
      'p6': instance.p6,
      'p7': instance.p7,
      'p8': instance.p8,
      'p9': instance.p9,
      'p10': instance.p10,
      'p11': instance.p11,
      'p12': instance.p12,
      'p13': instance.p13,
      'p14': instance.p14,
    };
