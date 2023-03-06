/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/bioCube/face_kit/hwst/lib/view/common/fuction_of_capture_full_screen.dart
 * Created Date: 2023-03-06 12:58:11
 * Last Modified: 2023-03-06 13:36:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:hwst/service/key_service.dart';

Future<ByteData> getBitmapFromContext() async {
  Image? image;
  final renderObject = KeyService.screenKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;
  image = await renderObject.toImage();
  var byte = await image.toByteData(format: ImageByteFormat.png);
  return byte!;
}
