/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-02-24 16:05:37
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-02-26 13:43:58
 * @FilePath: /hwst/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hwst/bioCubeApp.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hwst/model/db/user_info_table.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/service/firebase_service.dart';
import 'package:hwst/service/sound_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/service/native_channel_service.dart';
import 'package:hwst/buildConfig/biocube_build_config.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  await FirebaseService.init();
  Hive.registerAdapter(UserInfoTableAdapter());
  NativeChannelService.init();
  SoundService.init();
  CacheService.init();
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
