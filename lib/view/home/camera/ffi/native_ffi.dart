/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/face_kit/truepass/lib/view/home/ffi/native_ffi.dart
 * Created Date: 2023-02-17 11:18:19
 * Last Modified: 2023-02-22 22:44:49
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

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = _openDynamicLibrary();

/// C function signatures
typedef _CVersionFunc = ffi.Pointer<Utf8> Function();
typedef _CInitDetector = ffi.Void Function(
    ffi.Pointer<ffi.Uint8> markerPngBytes,
    ffi.Int32 inSize,
    ffi.Int32 bits,
    ffi.Pointer<Utf8>);
typedef _CDestroyDetector = ffi.Void Function();
typedef _CDetect = ffi.Pointer<ffi.Float> Function(
    ffi.Int32 width,
    ffi.Int32 height,
    ffi.Int32 rotation,
    ffi.Pointer<ffi.Uint8> bytes,
    ffi.Bool isYUV,
    ffi.Pointer<ffi.Int32> outCount);
typedef _CDetectTest = ffi.Pointer<ffi.Int> Function(
    ffi.Int32 width,
    ffi.Int32 height,
    ffi.Int32 rotation,
    ffi.Pointer<ffi.Uint8> bytes,
    ffi.Bool isYUV,
    ffi.Pointer<ffi.Int32> outCount);

/// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _InitDetector = void Function(ffi.Pointer<ffi.Uint8> markerPngBytes,
    int inSize, int bits, ffi.Pointer<Utf8>);
typedef _DestroyDetector = void Function();
typedef _Detect = ffi.Pointer<ffi.Float> Function(
    int width,
    int height,
    int rotation,
    ffi.Pointer<ffi.Uint8> bytes,
    bool isYUV,
    ffi.Pointer<ffi.Int32> outCount);
typedef _DetectTest = ffi.Pointer<ffi.Int> Function(
    int width,
    int height,
    int rotation,
    ffi.Pointer<ffi.Uint8> bytes,
    bool isYUV,
    ffi.Pointer<ffi.Int32> outCount);
// Functions mapping.
final _VersionFunc _version =
    _lib.lookup<ffi.NativeFunction<_CVersionFunc>>('version').asFunction();

final _InitDetector _initDetector = _lib
    .lookup<ffi.NativeFunction<_CInitDetector>>('initDetector')
    .asFunction();
final _Detect _detect =
    _lib.lookup<ffi.NativeFunction<_CDetect>>('detect').asFunction();
final _DetectTest _detectTest =
    _lib.lookup<ffi.NativeFunction<_CDetectTest>>('testFace').asFunction();
final _DestroyDetector _destroyDetector = _lib
    .lookup<ffi.NativeFunction<_CDestroyDetector>>('destroyDetector')
    .asFunction();

// Image buffer
ffi.Pointer<ffi.Uint8>? _imageBuffer;

// Native parameter transfer
void initDetector(Uint8List markerPngBytes, int bits, String path) {
  var totalSize = markerPngBytes.lengthInBytes;
  var imgBuffer = malloc.allocate<ffi.Uint8>(totalSize);
  Uint8List bytes = imgBuffer.asTypedList(totalSize);
  bytes.setAll(0, markerPngBytes);
  _initDetector(imgBuffer, totalSize, bits, path.toNativeUtf8());

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
Float32List detect(int width, int height, int rotation, Uint8List yBuffer,
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
  var res = _detect(width, height, rotation, _imageBuffer!,
      Platform.isAndroid ? true : false, outCount);
  final count = outCount.value;

  malloc.free(outCount);
  return res.asTypedList(count);
}

int detectTest(int width, int height, int rotation, Uint8List yBuffer,
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
  var res = _detectTest(width, height, rotation, _imageBuffer!,
      Platform.isAndroid ? true : false, outCount);
  malloc.free(outCount);
  return res.value;
}

// get platform dlib
ffi.DynamicLibrary _openDynamicLibrary() {
  if (Platform.isAndroid) {
    return ffi.DynamicLibrary.open('libnative_opencv.so');
  } else if (Platform.isWindows) {
    return ffi.DynamicLibrary.open("native_opencv_windows_plugin.dll");
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
