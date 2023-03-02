/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/shwt/lib/bioCubeApp.dart
 * Created Date: 2023-01-22 19:01:08
 * Last Modified: 2023-03-02 23:33:09
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hwst/enums/verify_type.dart';
import 'package:hwst/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/view/auth/auth_page.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/sound_service.dart';
import 'package:hwst/service/connect_service.dart';
import 'package:hwst/service/pass_kit_service.dart';
import 'view/common/function_of_hidden_key_borad.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/globalProvider/timer_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hwst/globalProvider/app_theme_provider.dart';
import 'view/common/function_of_checkBleAndLocationStatus.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/globalProvider/connect_status_provider.dart';
import 'package:hwst/globalProvider/next_page_loading_provider.dart';
import 'package:hwst/view/common/function_of_check_card_is_valid.dart';
import 'package:hwst/globalProvider/core_verify_process_provider.dart';

class BioCubeApp extends StatefulWidget {
  const BioCubeApp({super.key});

  @override
  State<BioCubeApp> createState() => _BioCubeAppState();
}

class _BioCubeAppState extends State<BioCubeApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifeCycle) async {
    super.didChangeAppLifecycleState(lifeCycle);
    final _isForeground = (lifeCycle == AppLifecycleState.resumed);
    final _isBackground = (lifeCycle == AppLifecycleState.paused);
    final _isDetached = (lifeCycle == AppLifecycleState.detached);

    var baseContext = KeyService.baseAppKey.currentContext;
    if (baseContext == null) return;
    final cp = baseContext.read<CoreVerifyProcessProvider>();
    final isValidate = await isCardValidate(context);
    if (!_isForeground) {
      cp.setIsShowCamera(val: false);
    }
    if (_isForeground && isValidate) {
      hideKeyboard(context);
      cp.setIsBackgroundMode(false);
      checkBleAndLocationStatus();
      Future.delayed(
          Duration(seconds: 1),
          () => PassKitService.initKit(
              isWithStartBle: cp.lastVerfyType == VerifyType.BLE));
    } else if (_isDetached) {
      pr('_isDetached ');
      SoundService.dispose();
      PassKitService.dispose();
      ConnectService.stopListener();
    } else if (_isBackground) {
      pr('isBackground');
      cp.setIsBackgroundMode(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NextPageLoadingProvider>(
          create: (_) => NextPageLoadingProvider(),
        ),
        ChangeNotifierProvider<AppThemeProvider>(
          create: (context) => AppThemeProvider(),
        ),
        ChangeNotifierProvider<TimerProvider>(
          create: (_) => TimerProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ConnectStatusProvider>(
          create: (_) => ConnectStatusProvider(),
        ),
        ChangeNotifierProvider<CoreVerifyProcessProvider>(
          create: (_) => CoreVerifyProcessProvider(),
        ),
        ChangeNotifierProvider<DeviceStatusProvider>(
          create: (_) => DeviceStatusProvider(),
        ),
        ChangeNotifierProvider(create: (_) => FaceDetectionProvider())
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (context, _) {
            final tp = context.read<AppThemeProvider>();
            return MaterialApp(
                navigatorKey: KeyService.baseAppKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                theme: tp.themeData,
                home: AuthPage(),
                routes: routes);
          }),
    );
  }
}
