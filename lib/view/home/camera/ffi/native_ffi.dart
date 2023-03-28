/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/face_kit/truepass/lib/view/home/ffi/native_ffi.dart
 * Created Date: 2023-02-17 11:18:19
 * Last Modified: 2023-03-28 14:26:21
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:hwst/model/db/user_info_table.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/view/common/function_of_print.dart';

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = _openDynamicLibrary();

/// C function signatures
typedef _CVersionFunc = ffi.Pointer<Utf8> Function();
typedef _CInitDetector = ffi.Void Function(
  ffi.Pointer<ffi.Uint8> markerPngBytes,
  ffi.Int32 inSize,
  ffi.Int32 bits,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef _CInitMnnModel = ffi.Void Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef _CDestroyDetector = ffi.Void Function();

typedef _CDetectFrame = ffi.Pointer<ffi.Float> Function(
  ffi.Int32 width,
  ffi.Int32 height,
  ffi.Int32 rotation,
  ffi.Pointer<ffi.Uint8> bytes,
  ffi.Bool isYUV,
  ffi.Pointer<ffi.Int32> outCount,
  ffi.Pointer<ffi.Float> feat,
  ffi.Pointer<ffi.Int32> isSuccessful,
);
typedef _CExtractFeature = ffi.Pointer<ffi.Float> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffi.Float> feat,
  ffi.Pointer<ffi.Int32> isSuccessful,
);
typedef _CMatchFeature = ffi.Pointer<ffi.Float> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

/// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _InitDetector = void Function(
  ffi.Pointer<ffi.Uint8> markerPngBytes,
  int inSize,
  int bits,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef _InitMnnModel = void Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef _DestroyDetector = void Function();

typedef _DetectFrame = ffi.Pointer<ffi.Float> Function(
    int width,
    int height,
    int rotation,
    ffi.Pointer<ffi.Uint8> bytes,
    bool isYUV,
    ffi.Pointer<ffi.Int32> outCount,
    ffi.Pointer<ffi.Float> feat,
    ffi.Pointer<ffi.Int32> isSuccessful);

typedef _ExtractFeature = ffi.Pointer<ffi.Float> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffi.Float> feat,
  ffi.Pointer<ffi.Int32> isSuccessful,
);
typedef _MatchFeature = ffi.Pointer<ffi.Float> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
// Functions mapping.
final _VersionFunc _version =
    _lib.lookup<ffi.NativeFunction<_CVersionFunc>>('version').asFunction();

final _InitDetector _initDetector = _lib
    .lookup<ffi.NativeFunction<_CInitDetector>>('initDetector')
    .asFunction();
final _InitMnnModel _initMnnModel = _lib
    .lookup<ffi.NativeFunction<_CInitMnnModel>>('initMnnModel')
    .asFunction();
final _DetectFrame _detectFrame =
    _lib.lookup<ffi.NativeFunction<_CDetectFrame>>('detectFrame').asFunction();
final _ExtractFeature _extractFeature = _lib
    .lookup<ffi.NativeFunction<_CExtractFeature>>('extractFeature')
    .asFunction();
final _MatchFeature _matchFeature = _lib
    .lookup<ffi.NativeFunction<_CMatchFeature>>('matchFeature')
    .asFunction();
final _DestroyDetector _destroyDetector = _lib
    .lookup<ffi.NativeFunction<_CDestroyDetector>>('destroyDetector')
    .asFunction();

// C function signatures
typedef _process_image_func = ffi.Void Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Int32 width,
  ffi.Int32 height,
  ffi.Int32 rotation,
  ffi.Pointer<ffi.Uint8> bytes,
  ffi.Bool isYUV,
);

// Dart function signatures
typedef _ProcessImageFunc = void Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  int width,
  int height,
  int rotation,
  ffi.Pointer<ffi.Uint8> bytes,
  bool isYUV,
);
final _ProcessImageFunc _processImage = _lib
    .lookup<ffi.NativeFunction<_process_image_func>>('process_image')
    .asFunction();
void processImage(
  String inputPath,
  String outputPath,
  int width,
  int height,
  int rotation,
  Uint8List yBuffer,
  Uint8List? uBuffer,
  Uint8List? vBuffer,
) {
  var ySize = yBuffer.lengthInBytes;
  var uSize = uBuffer?.lengthInBytes ?? 0;
  var vSize = vBuffer?.lengthInBytes ?? 0;
  var totalSize = ySize + uSize + vSize;
  _imageBuffer ??= malloc.allocate<ffi.Uint8>(totalSize);
  Uint8List _bytes = _imageBuffer!.asTypedList(totalSize);
  _bytes.setAll(0, yBuffer);

  if (Platform.isAndroid) {
    // Swap u&v buffer for opencv
    _bytes.setAll(ySize, vBuffer!);
    _bytes.setAll(ySize + vSize, uBuffer!);
  }

  _processImage(inputPath.toNativeUtf8(), outputPath.toNativeUtf8(), width,
      height, rotation, _imageBuffer!, Platform.isAndroid ? true : false);
}

// Image buffer
ffi.Pointer<ffi.Uint8>? _imageBuffer;

// Native parameter transfer
void initDetector(Uint8List markerPngBytes, int bits, String opencvModlePath,
    String mnnModlePath, String testOutputPath) {
  var totalSize = markerPngBytes.lengthInBytes;
  var imgBuffer = malloc.allocate<ffi.Uint8>(totalSize);
  Uint8List bytes = imgBuffer.asTypedList(totalSize);
  bytes.setAll(0, markerPngBytes);
  _initDetector(
    imgBuffer,
    totalSize,
    bits,
    opencvModlePath.toNativeUtf8(),
    mnnModlePath.toNativeUtf8(),
    testOutputPath.toNativeUtf8(),
  );
  malloc.free(imgBuffer);
}

// Native parameter transfer
void initMnnModel(String mnnModlePath, String opencvPath) {
  _initMnnModel(mnnModlePath.toNativeUtf8(), opencvPath.toNativeUtf8());
}

// Native parameter transfer
void destroy() {
  _destroyDetector();
  if (_imageBuffer != null) {
    malloc.free(_imageBuffer!);
  }
}

// Native parameter transfer
List<double>? detectFrame(int width, int height, int rotation,
    Uint8List yBuffer, Uint8List? uBuffer, Uint8List? vBuffer) {
  var ySize = yBuffer.lengthInBytes;
  var uSize = uBuffer?.lengthInBytes ?? 0;
  var vSize = vBuffer?.lengthInBytes ?? 0;
  var totalSize = ySize + uSize + vSize;

  _imageBuffer ??= malloc.allocate<ffi.Uint8>(totalSize);
  Uint8List _bytes = _imageBuffer!.asTypedList(totalSize);
  _bytes.setAll(0, yBuffer);

  if (Platform.isAndroid) {
    // Swap u&v buffer for opencv
    _bytes.setAll(ySize, vBuffer!);
    _bytes.setAll(ySize + vSize, uBuffer!);
  }

  ffi.Pointer<ffi.Int32> outCount = malloc.allocate<ffi.Int32>(1);
  ffi.Pointer<ffi.Int32> isSuccessful = malloc.allocate<ffi.Int32>(1);
  var featCount = ffi.sizeOf<ffi.Float>();
  ffi.Pointer<ffi.Float> feat = malloc.allocate<ffi.Float>(featCount * 512);
  var res = _detectFrame(width, height, rotation, _imageBuffer!,
      Platform.isAndroid ? true : false, outCount, feat, isSuccessful);
  final count = outCount.value;
  var result = res.asTypedList(count);
  var isExtracted = isSuccessful.value == 1;
  var featResul = feat.asTypedList(featCount * 512).toList();
  pr(featResul);
  malloc.free(outCount);
  malloc.free(res);
  malloc.free(feat);
  malloc.free(isSuccessful);
  return result.toList().isNotEmpty && isExtracted ? result.toList() : null;
}

// Native parameter transfer
UserInfoTable? extractFeature(UserInfoTable user) {
  var featCount = ffi.sizeOf<ffi.Float>();
  ffi.Pointer<ffi.Int32> isSuccessful = malloc.allocate<ffi.Int32>(1);
  ffi.Pointer<ffi.Float> feat = malloc.allocate<ffi.Float>(featCount * 512);
  final base64Image = user.imageData!;
  var res = _extractFeature(
    base64Image.toNativeUtf8(),
    feat,
    isSuccessful,
  );
  var result = res.asTypedList(featCount * 512).toList();
  var temp = '';
  for (var i = 0; i < result.length; i++) {
    temp += '${result[i]}' + '${i != result.length - 1 ? ',' : ''}';
  }
  user.feature = temp;
  user.isExtracted = isSuccessful.value == 1;
  pr('user.isExtracted ? ${user.isExtracted}');
  malloc.free(feat);
  malloc.free(res);
  malloc.free(isSuccessful);
  return user;
}

UserInfoTable? matchFeature(UserInfoTable user) {
  // var feat1 = CacheService. .toNativeUtf8();
  // var feat2 = user.feature!.toNativeUtf8();
  // var score = _matchFeature(feat1, feat2);
  // malloc.free(feat1);
  // malloc.free(feat2);
  return user;
}

// get platform dlib
ffi.DynamicLibrary _openDynamicLibrary() {
  if (Platform.isAndroid) {
    return ffi.DynamicLibrary.open('libnative_opencv.so');
  }
  return ffi.DynamicLibrary.process();
}

String opencvVersion() {
  return _version().toDartString();
}

class ProcessImageArguments {
  final String inputPath;
  final String outputPath;
  ProcessImageArguments(this.inputPath, this.outputPath);
}
