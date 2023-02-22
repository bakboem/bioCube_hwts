/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/model/user/user_card_model.dart
 * Created Date: 2023-01-24 00:08:30
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:hwst/model/user/tid_model.dart';
part 'user_card_model.g.dart';

@JsonSerializable()
class UserCardModel {
  @JsonKey(name: 'M_person')
  String? mPerson;
  @JsonKey(name: 'M_Level')
  String? mLevel;
  @JsonKey(name: 'M_Name')
  String? mName;
  @JsonKey(name: 'M_CoName')
  String? mCoName;
  @JsonKey(name: 'M_DpName')
  String? mDpName;
  @JsonKey(name: 'M_PoName')
  String? mPoName;
  @JsonKey(name: 'M_TiName')
  String? mTiName;
  @JsonKey(name: 'M_CoCode')
  String? mCoCode;
  @JsonKey(name: 'M_DPCode')
  String? mDPCode;
  @JsonKey(name: 'M_PoCode')
  String? mPoCode;
  @JsonKey(name: 'M_TiCode')
  String? mTiCode;
  @JsonKey(name: 'M_Phone')
  String? mPhone;
  @JsonKey(name: 'M_photo')
  String? mPhoto;
  @JsonKey(name: 'M_Mail')
  String? mMail;
  @JsonKey(name: 'M_Sdate')
  String? mSdate;
  @JsonKey(name: 'M_Edate')
  String? mEdate;
  @JsonKey(name: 'M_Cardkey')
  String? mCardKey;
  @JsonKey(name: 'M_Cardcode')
  String? mCardCode;
  @JsonKey(name: 'M_Cardkey_Sdate')
  String? mCardKeySdate;
  @JsonKey(name: 'M_cardkey_Edate')
  String? mCardKeyEdate;
  @JsonKey(name: 'C_name')
  String? cName;
  @JsonKey(name: 'createDateByLocal')
  DateTime? createDateByLocal;
  @JsonKey(name: 'Sv_Tid')
  List<TidModel>? svTidList;
  @JsonKey(name: 'Sv_url')
  String? svUrl;
  UserCardModel(
      this.cName,
      this.mCardCode,
      this.mCardKey,
      this.mCardKeyEdate,
      this.mCardKeySdate,
      this.mCoCode,
      this.mCoName,
      this.mDPCode,
      this.mDpName,
      this.mEdate,
      this.mLevel,
      this.mMail,
      this.mName,
      this.mPhone,
      this.mPhoto,
      this.mPoCode,
      this.mPoName,
      this.mSdate,
      this.mTiCode,
      this.mTiName,
      this.mPerson,
      this.svTidList,
      this.svUrl,
      this.createDateByLocal);
  factory UserCardModel.fromJson(Object? json) =>
      _$UserCardModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserCardModelToJson(this);
}
