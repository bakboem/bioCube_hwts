/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/globalProvider/device_status_provider.dart
 * Created Date: 2023-01-29 15:28:13
 * Last Modified: 2023-02-28 13:01:57
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/foundation.dart';

class DeviceStatusProvider extends ChangeNotifier {
  bool isBleOk = false;
  bool isNfcOk = false;
  bool isSuppertNfc = true;
  bool isFaceOk = false;
  bool isLocationOk = false;

  void setBleStatus(bool val) {
    isBleOk = val;
    notifyListeners();
  }

  void setIsSuppertNfc(bool val) {
    isSuppertNfc = val;
    notifyListeners();
  }

  void setNfcStatus(bool val) {
    isNfcOk = val;
    notifyListeners();
  }

  void setFaceStatus(bool val) {
    isFaceOk = val;
    notifyListeners();
  }

  void setLocationStatus(bool val) {
    isLocationOk = val;
    notifyListeners();
  }
}
