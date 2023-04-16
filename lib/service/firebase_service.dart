/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/service/firebase_service.dart
 * Created Date: 2023-04-12 11:56:25
 * Last Modified: 2023-04-14 22:31:06
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'dart:async';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  factory FirebaseService() => _sharedInstance();
  static FirebaseService? _instance;
  FirebaseService._();
  static FirebaseService _sharedInstance() {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  static bool isPermissed = false;
  static String fcmTocken = '';
  static bool isSupptedBadge = false;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const channelId = 'kolon_medsalesportaldev';
  static final channel =
      AndroidNotificationChannel(channelId, '제약영업포탈', 'discription');
  //초기화  --> 앱이 첫실행시 한번만 호출
  static Future<bool> init() async {
    await initLocalNotifacation();
    return true;
  }

  static Future<void> stopListenner() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> initLocalNotifacation() async {
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/push_icon'),
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (e) async {});
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
    }
  }

  @pragma('vm:entry-point')
  static void locakNotificationTapBackground() {
    var android = AndroidNotificationDetails('ids', 'name', 'discription',
        importance: Importance.max,
        color: AppColors.primary,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation('body'));
    var ios = const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var detail = NotificationDetails(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.show(0, 'title', 'body', detail);
  }

  static Future<void> show() async {
    try {
      var title = 'title';
      var body = 'body';
      var payload = 'payload';
      var android = AndroidNotificationDetails('id', 'name', 'description',
          importance: Importance.max,
          color: AppColors.primary,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation('bigText'));
      var ios = const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      var detail = NotificationDetails(android: android, iOS: ios);
      await flutterLocalNotificationsPlugin.show(0, title, body, detail,
          payload: payload);
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SHOW_WALLPAPER);
    } catch (e) {
      pr(e);
    }
  }
}
