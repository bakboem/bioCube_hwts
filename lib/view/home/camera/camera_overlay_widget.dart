import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:provider/provider.dart';

class CameraOverlayWidget extends StatelessWidget {
  const CameraOverlayWidget({Key? key, required this.info}) : super(key: key);
  final List<double> info;

  Offset getOffset() {
    final dp =
        KeyService.baseAppKey.currentContext!.read<DeviceStatusProvider>();
    var cardWidth = AppSize.defaultContentsWidth * .8;
    var cardHeight = dp.isOverThanIphone10
        ? cardWidth * 1.65
        : Platform.isAndroid
            ? AppSize.realWidth > 600
                ? cardWidth * 1.4
                : cardWidth * 1.55
            : cardWidth * 1.55;
    // low
    // var topScale = Platform.isIOS ? info[1] / 352 : info[1] / 320;
    // var leftScale = Platform.isIOS ? info[0] / 288 : info[0] / 240;
    // var top = cardHeight * topScale - 40;
    // medium
    var topScale = Platform.isIOS ? info[1] / 640 : info[1] / 720;
    var leftScale = info[0] / 480;
    var top = cardHeight * topScale - 20;
    var left = cardWidth * leftScale;
    return Offset(left, top);
  }

  @override
  Widget build(BuildContext context) {
    return info.isNotEmpty
        ? Positioned(
            left: getOffset().dx,
            top: getOffset().dy,
            child: Container(
              width: info[2],
              height: info[2],
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.green)),
            ))
        : Container();
    // CustomPaint(
    //   painter: FaceLinePainter(faceInfo: info),
    // )
  }
}

class FaceLinePainter extends CustomPainter {
  FaceLinePainter({required this.faceInfo});

  // list of aruco coordinates, each aruco has 4 corners with x/y, total of 8 numbers per aruco
  final List<double> faceInfo;

  // paint we will use to draw to arucos
  final _paint = Paint()
    ..strokeWidth = 2.0
    ..color = Colors.red
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    if (faceInfo.isEmpty) {
      return;
    }
    pr(faceInfo);
    // Each aruco is 8 numbers (4 corners * x,y) and corners are starting from
    // top-left going clockwise
    var x = faceInfo[0];
    var y = faceInfo[1];
    var fsize = faceInfo[2];
    var point = Offset(x, y);
    var left = Offset(x, y + fsize);
    var bottom = Offset(left.dx + fsize, left.dy);
    var right = Offset(bottom.dx, bottom.dy - fsize);

    var top = Offset(right.dx - fsize, right.dy);

    canvas.drawLine(point, Offset(point.dx, point.dy + 50), _paint);
    // canvas.drawLine(point, left, _paint);
    // canvas.drawLine(left, bottom, _paint);
    // canvas.drawLine(bottom, right, _paint);
    // canvas.drawLine(right, top, _paint);
  }

  @override
  bool shouldRepaint(FaceLinePainter oldDelegate) => true;
}
