/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/bioCube/face_kit/truepass/lib/globalProvider/face_detection_provider.dart
 * Created Date: 2023-02-19 15:22:53
 * Last Modified: 2023-03-13 21:33:16
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
  bool isShowFaceLine = false;
  double? cameraScale;
  List<double>? faceInfo;
  void setIsFaceFinded(bool? val) {
    isFaceFinded = val ?? !isFaceFinded;
    notifyListeners();
  }

  void setCameraScale(double scale) {
    cameraScale = scale;
    notifyListeners();
  }

  void setFaceInfo(List<double> res) {
    faceInfo = res;
    notifyListeners();
  }

  void setIsShowFaceLine(bool val) {
    isShowFaceLine = val;
    notifyListeners();
  }
}
