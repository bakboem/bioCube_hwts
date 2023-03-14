/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/face_kit/truepass/lib/view/home/ffi/native_ffi.dart
 * Created Date: 2023-02-17 11:18:19
 * Last Modified: 2023-03-13 23:26:01
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
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:provider/provider.dart';

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
typedef _CDestroyDetector = ffi.Void Function();

typedef _CDetectFrame = ffi.Pointer<ffi.Float> Function(
  ffi.Int32 width,
  ffi.Int32 height,
  ffi.Int32 rotation,
  ffi.Pointer<ffi.Uint8> bytes,
  ffi.Bool isYUV,
  ffi.Pointer<ffi.Int32> outCount,
  ffi.Pointer<ffi.Float> feat,
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
typedef _DestroyDetector = void Function();

typedef _DetectFrame = ffi.Pointer<ffi.Float> Function(
    int width,
    int height,
    int rotation,
    ffi.Pointer<ffi.Uint8> bytes,
    bool isYUV,
    ffi.Pointer<ffi.Int32> outCount,
    ffi.Pointer<ffi.Float> feat);
// Functions mapping.
final _VersionFunc _version =
    _lib.lookup<ffi.NativeFunction<_CVersionFunc>>('version').asFunction();

final _InitDetector _initDetector = _lib
    .lookup<ffi.NativeFunction<_CInitDetector>>('initDetector')
    .asFunction();

final _DetectFrame _detectFrame =
    _lib.lookup<ffi.NativeFunction<_CDetectFrame>>('detectFrame').asFunction();
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
void destroy() {
  _destroyDetector();
  if (_imageBuffer != null) {
    malloc.free(_imageBuffer!);
  }
}

// Native parameter transfer
Float32List detectFrame(int width, int height, int rotation, Uint8List yBuffer,
    Uint8List? uBuffer, Uint8List? vBuffer) {
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
  var featCount = ffi.sizeOf<ffi.Float>();
  ffi.Pointer<ffi.Float> feat = malloc.allocate<ffi.Float>(featCount * 512);
  var res = _detectFrame(width, height, rotation, _imageBuffer!,
      Platform.isAndroid ? true : false, outCount, feat);
  final count = outCount.value;
  var result = res.asTypedList(count);

  var featResul = feat.asTypedList(featCount * 512).toList();
  pr(featResul);
  malloc.free(outCount);
  malloc.free(res);
  malloc.free(feat);
  return result;
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
