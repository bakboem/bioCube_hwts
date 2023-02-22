import 'package:json_annotation/json_annotation.dart';
part 'user_device_info.g.dart';

@JsonSerializable()
class UserDeviceInfo {
  String deviceId;
  String deviceBrand;
  String deviceName;
  String deviceModel;
  String deviceVersion;
  UserDeviceInfo(this.deviceId, this.deviceBrand, this.deviceName,
      this.deviceModel, this.deviceVersion);

  factory UserDeviceInfo.fromJson(Object? json) =>
      _$UserDeviceInfoFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserDeviceInfoToJson(this);
}
