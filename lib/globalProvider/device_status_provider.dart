/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-01-29 15:28:13
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-02-28 12:07:05
 * @FilePath: /truepass/lib/globalProvider/device_status_provider.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/truepass/lib/globalProvider/device_status_provider.dart
 * Created Date: 2023-01-29 15:28:13
 * Last Modified: 2023-02-28 12:07:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/foundation.dart';
import 'package:hwst/service/deviceInfo_service.dart';

class DeviceStatusProvider extends ChangeNotifier {
  bool isBleOk = false;
  bool isNfcOk = false;
  bool isSuppertNfc = true;
  bool isFaceOk = false;
  bool isLocationOk = false;
  bool isOverThanIphone10 = false;
  bool updateSwich = true;
  void setBleStatus(bool val) {
    isBleOk = val;
    notifyListeners();
  }

  void doUpdateStatus() {
    updateSwich = !updateSwich;
    notifyListeners();
  }

  void setIsOverThanIphone10() async {
    isOverThanIphone10 = await DeviceInfoService.isOverThanIphone10();
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
  }

  void setLocationStatus(bool val) {
    isLocationOk = val;
    notifyListeners();
  }
}
