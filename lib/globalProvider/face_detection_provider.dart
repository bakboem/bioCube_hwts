/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-02-19 15:22:53
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-02-21 10:25:11
 * @FilePath: /face_kit/truepass/lib/globalProvider/face_detection_provider.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/bioCube/face_kit/truepass/lib/globalProvider/face_detection_provider.dart
 * Created Date: 2023-02-19 15:22:53
 * Last Modified: 2023-02-21 10:25:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

class FaceDetectionProvider extends ChangeNotifier {
  bool isFaceFinded = false;
  void setIsFaceFinded(bool? val) {
    isFaceFinded = val ?? !isFaceFinded;
  }
}
