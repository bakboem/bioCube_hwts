/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/service/location_service.dart
 * Created Date: 2023-01-24 08:24:46
 * Last Modified: 2023-02-22 22:44:41
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:geolocator/geolocator.dart';

class LocationService {
  factory LocationService() => _sharedInstance();
  static LocationService? _instance;
  LocationService._();
  static LocationService _sharedInstance() {
    _instance ??= LocationService._();
    return _instance!;
  }

  static final GeolocatorPlatform geolocatorPlatform =
      GeolocatorPlatform.instance;
  static Future<Position> getCurrentPosition() async {
    final position = await geolocatorPlatform.getCurrentPosition();
    return position;
  }
}
