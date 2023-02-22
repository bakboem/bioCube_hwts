// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
      json['D_def'] as String?,
      json['D_defNm'] as String?,
      json['L_Cardkey'] as String?,
      json['L_date'] as String?,
      json['L_date2'] as String?,
      json['L_flag1'] as String?,
      json['L_flag1Nm'] as String?,
      json['L_GPS'] as String?,
      json['L_OS'] as String?,
      json['L_person'] as String?,
      json['L_phSerial'] as String?,
      json['L_photo'] as String?,
      json['L_result'] as String?,
      json['L_resultNm'] as String?,
      json['L_tid'] as String?,
      json['L_type'] as String?,
      json['L_typeNm'] as String?,
      json['TL_site'] as String?,
    );

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'TL_site': instance.tlSite,
      'L_date': instance.lDate,
      'L_person': instance.lPerson,
      'L_type': instance.lType,
      'L_Cardkey': instance.lCardKey,
      'L_tid': instance.lTid,
      'L_result': instance.lResult,
      'L_GPS': instance.lGps,
      'L_photo': instance.lPhoto,
      'L_OS': instance.lOs,
      'L_phSerial': instance.lPhSerial,
      'L_flag1': instance.lFlag1,
      'L_date2': instance.lDate2,
      'L_typeNm': instance.lTypeNm,
      'L_resultNm': instance.lResultNm,
      'L_flag1Nm': instance.lFlag1Nm,
      'D_def': instance.dDef,
      'D_defNm': instance.dDefNm,
    };
