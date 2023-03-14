import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';

class CameraOverlayWidget extends StatelessWidget {
  const CameraOverlayWidget({Key? key, required this.info}) : super(key: key);
  final List<double> info;

  List<Offset> getOffset() {
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
    var top = cardHeight * topScale;
    var left = cardWidth * leftScale;
    var border = cardWidth * (info[2] / 480);
    return [Offset(left, top), Offset(border, border)];
  }

  @override
  Widget build(BuildContext context) {
    return info.isNotEmpty
        ? Positioned(
            left: getOffset()[0].dx,
            top: getOffset()[0].dy,
            child: Container(
              width: getOffset()[1].dx,
              height: getOffset()[1].dy,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.green)),
            ))
        : Container();
    // CustomPaint(
    //   painter: FaceLinePainter(faceInfo: info),
    // )
  }
}
