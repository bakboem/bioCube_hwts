import 'dart:io';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hwst/enums/record_status.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/service/local_file_servicer.dart';
import 'package:hwst/view/home/camera/camera_overlay_widget.dart';
import 'package:provider/provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/common/widget_of_loading_view.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/view/home/camera/threadController/first_thread_process.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);
  static final String routeName = '/cameraPage';
  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  CameraController? _camController;
  late FirstThread _firstThread;
  int _camFrameRotation = 0;
  double _camFrameToScreenScale = 0;
  int _lastRun = 0;
  bool _detectionInProgress = false;
  bool _recordInProgress = false;
  bool _isCameraReady = false;
  @override
  void initState() {
    super.initState();
    _firstThread = FirstThread();
    initCamera();
  }

  @override
  void dispose() {
    _camController?.dispose();
    _firstThread.destroy();
    pr('dispose camera!');
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      var idx = cameras
          .indexWhere((c) => c.lensDirection == CameraLensDirection.front);
      if (idx < 0) {
        log("No Back camera found - weird");
        return;
      }

      var desc = cameras[idx];
      _camFrameRotation = Platform.isAndroid ? desc.sensorOrientation : 0;
      if (_camController != null) {
        _camController!.dispose();
      }
      _camController = CameraController(
        desc,
        ResolutionPreset
            .medium, // ios : 640 x480   android : 720x480   // low 352x288 on iOS, 320x240 on Android
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );
    } catch (e) {
      pr('@@@@@@@@@@@ Camera init Exception');
    }

    try {
      await _camController!.initialize();
      await _camController!
          .startImageStream((image) => _processCameraImage(image));
      if (mounted) {
        _isCameraReady = true;
        setState(() {});
      }
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }
  }

  void _processCameraImage(CameraImage image) async {
    final fp =
        KeyService.baseAppKey.currentContext!.read<FaceDetectionProvider>();
    if (fp.recordstatus == RecordStatus.WORKING) {
      // do record proccess.
      _firstThread.startRecord(image, _camFrameRotation,
          isReady: _recordInProgress == false ? true : null);
      _recordInProgress = true;
      return;
    }
    if (_detectionInProgress ||
        !mounted ||
        DateTime.now().millisecondsSinceEpoch - _lastRun < 500) {
      return;
    }
    // calc the scale factor to convert from camera frame coords to screen coords.
    // NOTE!!!! We assume camera frame takes the entire screen width, if that's not the case
    // (like if camera is landscape or the camera frame is limited to some area) then you will
    // have to find the correct scale factor somehow else
    if (_camFrameToScreenScale == 0) {
      var w = (_camFrameRotation == 0 || _camFrameRotation == 180)
          ? image.width
          : image.height;
      _camFrameToScreenScale = 360 / w; // 360 is globle ui design width.

      fp.setCameraScale(_camFrameToScreenScale);
    }

    // Call the detector
    _detectionInProgress = true;
    Map<String, dynamic>? res;
    if (!fp.isFaceFinded) {
      res = await _firstThread.detect(image, _camFrameRotation);
      if (res != null && res.isNotEmpty) {
        fp.setIsShowFaceLine(true);
        fp.setFaceInfo(res['faceInfo']);
        fp.setIsFaceFinded(true);
        fp.startMatchData(_firstThread, res['feat']);
        pr('find face x $res');
      }
    } else {
      fp.setIsShowFaceLine(false);
    }
    if (fp.recordstatus == RecordStatus.START) {
      fp.setRecodeStatus(RecordStatus.WORKING);
      pr('startRecord');
      Future.delayed(Duration(seconds: 5), () {
        fp.setRecodeStatus(RecordStatus.END);
        _recordInProgress = false;
      });
    }
    _detectionInProgress = false;
    _lastRun = DateTime.now().millisecondsSinceEpoch;

    // Make sure we are still mounted, the background thread can return a response after we navigate away from this
    // screen but before bg thread is killed
    if (!mounted || res == null) {
      return;
    }

    // Check that the number of coords we got divides by 8 exactly, each aruco has 8 coords (4 corners x/y)
    // if ((res.length / 8) != (res.length ~/ 8)) {
    //   log('Got invalid response from , number of coords is ${res.length} and does not represent complete arucos with 4 corners');
    //   return;
    // }

    // convert arucos from camera frame coords to screen coords
    // final arucos =
    //     res.map((x) => x * _camFrameToScreenScale).toList(growable: false);
    // setState(() {
    //   _arucos = arucos;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (_camController == null || !_isCameraReady) {
      return Stack(
        children: [
          BaseLoadingViewOnStackWidget.build(context, true),
        ],
      );
    } else {
      return Stack(
        children: [
          CameraPreview(_camController!),
          Consumer<FaceDetectionProvider>(builder: (context, provider, _) {
            return provider.faceInfo != null &&
                    provider.faceInfo!.isNotEmpty &&
                    provider.isShowFaceLine
                ? CameraOverlayWidget(info: provider.faceInfo!)
                : SizedBox();
          }),
        ],
      );
    }
  }
}
