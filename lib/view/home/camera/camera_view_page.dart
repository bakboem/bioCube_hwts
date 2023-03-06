import 'dart:io';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:provider/provider.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/common/widget_of_loading_view.dart';
import 'package:hwst/view/home/camera/camera_overlay_widget.dart';
import 'package:hwst/view/home/camera/threadController/receive_thread_process.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);
  static final String routeName = '/cameraPage';
  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage>
    with WidgetsBindingObserver {
  CameraController? _camController;
  late ReceiveThread _requestThread;
  int _camFrameRotation = 0;
  double _camFrameToScreenScale = 0;
  int _lastRun = 0;
  bool _detectionInProgress = false;
  List<double> _faceInfo = List.empty();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestThread = ReceiveThread();
    initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _requestThread.destroy();
    _camController?.dispose();
    pr('dispose camera!');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _camController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    var idx =
        cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
    if (idx < 0) {
      log("No Back camera found - weird");
      return;
    }

    var desc = cameras[idx];
    _camFrameRotation = Platform.isAndroid ? desc.sensorOrientation : 0;
    _camController = CameraController(
      desc,
      ResolutionPreset.medium, // ios : 640 x480     android : 720x480
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _camController!.initialize();
      await _camController!
          .startImageStream((image) => _processCameraImage(image));
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_detectionInProgress ||
        !mounted ||
        DateTime.now().millisecondsSinceEpoch - _lastRun < 200) {
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
      _camFrameToScreenScale = AppSize.realWidth / w;
    }

    // Call the detector
    _detectionInProgress = true;
    final fp = context.read<FaceDetectionProvider>();
    List<double>? res;
    if (!fp.isFaceFinded) {
      res = await _requestThread.detect(image, _camFrameRotation);
    }
    if (res != null && res.isNotEmpty) {
      _faceInfo = res;
      fp.setIsShowFaceLine(true);
      // fp.setIsFaceFinded(true);
      fp.setFaceInfo(res);
      pr('find face x $res');
    } else {
      fp.setIsShowFaceLine(false);
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
    final dp = context.read<DeviceStatusProvider>();
    var cardWidth = AppSize.defaultContentsWidth * .8;
    var cardHeight = dp.isOverThanIphone10
        ? cardWidth * 1.65
        : Platform.isAndroid
            ? AppSize.realWidth > 600
                ? cardWidth * 1.4
                : cardWidth * 1.55
            : cardWidth * 1.55;
    var scale = AppSize.realHeight / cardHeight;
    pr('scale!!!! ${scale}');
    if (_camController == null) {
      return Stack(
        children: [
          BaseLoadingViewOnStackWidget.build(context, true),
        ],
      );
    }
    return Stack(
      children: [
        CameraPreview(_camController!),
      ],
    );
  }
}
