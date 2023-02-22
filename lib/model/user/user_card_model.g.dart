// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCardModel _$UserCardModelFromJson(Map<String, dynamic> json) =>
    UserCardModel(
      json['C_name'] as String?,
      json['M_Cardcode'] as String?,
      json['M_Cardkey'] as String?,
      json['M_cardkey_Edate'] as String?,
      json['M_Cardkey_Sdate'] as String?,
      json['M_CoCode'] as String?,
      json['M_CoName'] as String?,
      json['M_DPCode'] as String?,
      json['M_DpName'] as String?,
      json['M_Edate'] as String?,
      json['M_Level'] as String?,
      json['M_Mail'] as String?,
      json['M_Name'] as String?,
      json['M_Phone'] as String?,
      json['M_photo'] as String?,
      json['M_PoCode'] as String?,
      json['M_PoName'] as String?,
      json['M_Sdate'] as String?,
      json['M_TiCode'] as String?,
      json['M_TiName'] as String?,
      json['M_person'] as String?,
      (json['Sv_Tid'] as List<dynamic>?)
          ?.map((e) => TidModel.fromJson(e as Object))
          .toList(),
      json['Sv_url'] as String?,
      json['createDateByLocal'] == null
          ? null
          : DateTime.parse(json['createDateByLocal'] as String),
    );

Map<String, dynamic> _$UserCardModelToJson(UserCardModel instance) =>
    <String, dynamic>{
      'M_person': instance.mPerson,
      'M_Level': instance.mLevel,
      'M_Name': instance.mName,
      'M_CoName': instance.mCoName,
      'M_DpName': instance.mDpName,
      'M_PoName': instance.mPoName,
      'M_TiName': instance.mTiName,
      'M_CoCode': instance.mCoCode,
      'M_DPCode': instance.mDPCode,
      'M_PoCode': instance.mPoCode,
      'M_TiCode': instance.mTiCode,
      'M_Phone': instance.mPhone,
      'M_photo': instance.mPhoto,
      'M_Mail': instance.mMail,
      'M_Sdate': instance.mSdate,
      'M_Edate': instance.mEdate,
      'M_Cardkey': instance.mCardKey,
      'M_Cardcode': instance.mCardCode,
      'M_Cardkey_Sdate': instance.mCardKeySdate,
      'M_cardkey_Edate': instance.mCardKeyEdate,
      'C_name': instance.cName,
      'createDateByLocal': instance.createDateByLocal?.toIso8601String(),
      'Sv_Tid': instance.svTidList,
      'Sv_url': instance.svUrl,
    };
