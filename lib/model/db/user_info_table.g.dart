// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoTableAdapter extends TypeAdapter<UserInfoTable> {
  @override
  final int typeId = 1;

  @override
  UserInfoTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoTable(
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as DateTime?,
      fields[4] as String?,
      fields[5] as String?,
      fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoTable obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.mPerson)
      ..writeByte(2)
      ..write(obj.mPhoto)
      ..writeByte(3)
      ..write(obj.updateDate)
      ..writeByte(4)
      ..write(obj.imageData)
      ..writeByte(5)
      ..write(obj.feature)
      ..writeByte(6)
      ..write(obj.isExtracted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoTable _$UserInfoTableFromJson(Map<String, dynamic> json) =>
    UserInfoTable(
      json['M_person'] as String?,
      json['M_photo'] as String?,
      json['Adate'] == null ? null : DateTime.parse(json['Adate'] as String),
      json['M_photo_base64'] as String?,
      json['feature'] as String?,
      json['isExtracted'] as bool?,
      (json['score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserInfoTableToJson(UserInfoTable instance) =>
    <String, dynamic>{
      'M_person': instance.mPerson,
      'M_photo': instance.mPhoto,
      'Adate': instance.updateDate?.toIso8601String(),
      'M_photo_base64': instance.imageData,
      'feature': instance.feature,
      'isExtracted': instance.isExtracted,
      'score': instance.score,
    };
