import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hwst/bioCubeApp.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/service/sound_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/service/native_channel_service.dart';
import 'package:hwst/buildConfig/biocube_build_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  NativeChannelService.init();
  await Hive.initFlutter();
  CacheService.init();
  await SoundService.init();
  setSystemOverlay();
  start();
}

void setSystemOverlay() {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

void start() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    pr('success???');
    runApp(
      EasyLocalization(
        supportedLocales: BioCubeBuildConfig.appLocale,
        path: "assets/i18n",
        fallbackLocale: CacheService.getLocale(),
        child: const BioCubeApp(),
      ),
    );
  });
}
