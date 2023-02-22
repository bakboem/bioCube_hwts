/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/verify_type.dart
 * Created Date: 2023-01-24 13:16:21
 * Last Modified: 2023-02-22 22:44:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';

enum VerifyType {
  NFC,
  BLE,
  FACE,
  FACE_BLE,
  FACE_NFC,
  QR_CODE,
}

extension VerifyTypeExtension on VerifyType {
  String get code {
    switch (this) {
      case VerifyType.NFC:
        return '1';
      case VerifyType.BLE:
        return '2';
      case VerifyType.FACE:
        return '3';
      case VerifyType.FACE_NFC:
        return '4';
      case VerifyType.FACE_BLE:
        return '5';
      case VerifyType.QR_CODE:
        return '6';
    }
  }

  String get title {
    switch (this) {
      case VerifyType.NFC:
        return 'NFC';
      case VerifyType.BLE:
        return 'BLE';
      case VerifyType.FACE:
        return tr('face');
      case VerifyType.FACE_NFC:
        return tr('face_and_nfc');
      case VerifyType.FACE_BLE:
        return tr('face_and_ble');
      case VerifyType.QR_CODE:
        return tr('qr_code');
    }
  }
}
