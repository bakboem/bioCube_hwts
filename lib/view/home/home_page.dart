/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/shwt/lib/view/home/home_page.dart
 * Created Date: 2023-01-22 19:13:24
 * Last Modified: 2023-03-29 12:09:40
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:hwst/enums/record_status.dart';
import 'package:hwst/service/key_service.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:app_settings/app_settings.dart';
import 'package:hwst/service/hive_service.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/service/sound_service.dart';
import 'package:hwst/view/home/card_widget.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/enums/drawer_icon_type.dart';
import 'package:hwst/service/connect_service.dart';
import 'package:hwst/service/pass_kit_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/service/vibration_service.dart';
import 'package:hwst/view/setting/setting_page.dart';
import 'package:hwst/service/permission_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/base_app_toast.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:hwst/service/local_file_servicer.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/buildConfig/biocube_build_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hwst/model/user/user_environment_model.dart';
import 'package:hwst/view/common/widget_of_divider_line.dart';
import 'package:hwst/view/common/widget_of_loading_view.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/view/home/provider/home_page_provider.dart';
import 'package:hwst/view/common/widget_of_dialog_contents.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/view/common/widget_of_download_progress.dart';
import 'package:hwst/globalProvider/home_start_button_provider.dart';
import 'package:hwst/globalProvider/core_verify_process_provider.dart';
import 'package:hwst/view/common/function_of_check_card_is_valid.dart';
import 'package:hwst/view/common/function_of_show_location_faild_popup.dart';
import 'package:hwst/view/home/camera/threadController/second_thread_process.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/homePage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late SecondThread _secondThread;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    pr('init home');
    ConnectService.startListener();
    Permission.camera.request();
    loadFaceDetectionAndDeepLearningFile(
      'opencv',
      ['haarcascade_frontalface_default.xml'],
    );
    loadFaceDetectionAndDeepLearningFile(
      'mnn',
      ['FaceCubePlusRecognize.mnn'],
    ).whenComplete(() => _secondThread = SecondThread());
    runBleStart();
    checkIsFaceOk();
  }

  void checkIsFaceOk() {
    final dp =
        KeyService.baseAppKey.currentContext!.read<DeviceStatusProvider>();
    dp.setFaceStatus(CacheService.getUserEnvironment()!.isUseFace!);
  }

  void runBleStart() {
    PermissionService.requestLocationAndBle()
        .then((_) => PermissionService.checkLocationAndBle());
    PassKitService.isNfcOk().then((_) => PassKitService.initKit(
        type: CacheService.getLastVerfyType() == VerifyType.BLE &&
                CacheService.getUserEnvironment()!.isUseBle!
            ? VerifyType.BLE
            : null));
    var lastVerfyType = CacheService.getLastVerfyType();
    Future.delayed(Duration(seconds: 3), () {
      _pageController.jumpToPage(lastVerfyType.getIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _secondThread.secondThreadDestroy();
    ConnectService.stopListener();
    pr('dispose home!');
    super.dispose();
  }

  Future<void> loadFaceDetectionAndDeepLearningFile(
      String dirName, List<String> fileNames) async {
    final fileService = LocalFileService();
    for (var fileName in fileNames) {
      final bytes = await rootBundle.load('assets/$dirName/$fileName');
      File? file;
      Directory? dir;
      if (await fileService.checkDirectoryExits(dirName)) {
        dir = await fileService.getDir(dirName);
      } else {
        dir = await fileService.createDirectory(dirName);
      }
      file = await fileService.createFile(dir!.path + '/$fileName');
      if (await file.length() == 0) {
        await file.writeAsBytes(bytes.buffer.asUint8List()).then((f) =>
            dirName == 'opencv'
                ? CacheService.saveOpencvModelFilePath(f.path)
                : CacheService.saveMnnModelFilePath(f.path));
      } else {
        dirName == 'opencv'
            ? CacheService.saveOpencvModelFilePath(file.path)
            : CacheService.saveMnnModelFilePath(file.path);
      }
    }
  }

  Widget _popupContents(BuildContext context) {
    return Selector<CoreVerifyProcessProvider, Tuple3<bool?, bool?, bool?>>(
      selector: (context, provider) => Tuple3(
          provider.isBleSuccess, provider.isNfcSuccess, provider.isFaceSuccess),
      builder: (context, tuple, _) {
        var userEvn = CacheService.getUserEnvironment()!;
        var bleSuccess = tuple.item1 != null && tuple.item1!;
        var nfcSuccess = tuple.item2 != null && tuple.item2!;
        var faceSuccess = tuple.item3 != null && tuple.item3!;
        if (bleSuccess || nfcSuccess || faceSuccess) {
          Future.delayed(Duration.zero, () async {
            await AppToast().show(
                context,
                bleSuccess
                    ? tr('ble_success_text')
                    : nfcSuccess
                        ? tr('nfc_success_text')
                        : tr('face_success_text'));
            switch (userEvn.alarmType) {
              case 0:
                await ViBrationService.hasVibrator()
                    ? ViBrationService.viberateOnly()
                    : DoNothingAction();
                break;
              case 1:
                faceSuccess
                    ? await SoundService.playSuccessSound()
                    : await SoundService.playSound();
                break;
              case 2:
                faceSuccess
                    ? await SoundService.playSuccessSound()
                    : await SoundService.playSound();
                break;
            }
          });
        }
        return Builder(builder: (context) => Container());
      },
    );
  }

  Widget _buildPageViewText(
      BuildContext context, String type, UserEnvironmentModel? userEvn,
      {bool? isStatusOk}) {
    final isBlueStatusOk =
        type == 'ble' && isStatusOk != null && isStatusOk && userEvn!.isUseBle!;
    final isNfcStatusOk = type == 'nfc' &&
        isStatusOk != null &&
        isStatusOk &&
        (userEvn!.isUseNfc ?? false);
    final isFaceOk = type == 'face' &&
        isStatusOk != null &&
        isStatusOk &&
        userEvn!.isUseFace!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText.text(
            type == 'ble'
                ? tr('ble')
                : type == 'nfc'
                    ? tr('nfc')
                    : tr('face_detection'),
            style: isBlueStatusOk
                ? AppTextStyle.sub_16
                : isNfcStatusOk
                    ? AppTextStyle.sub_16
                    : isFaceOk
                        ? AppTextStyle.sub_16
                        : AppTextStyle.sub_16
                            .copyWith(color: AppColors.cancelIcon)),
        AppText.text(tr('action'),
            style: AppTextStyle.bold_22.copyWith(
                color: isBlueStatusOk
                    ? AppColors.deepIconColor
                    : isNfcStatusOk
                        ? AppColors.deepIconColor
                        : isFaceOk
                            ? AppColors.deepIconColor
                            : AppColors.cancelIcon)),
      ],
    );
  }

  void reset(BuildContext context) async {
    final fp = context.read<FaceDetectionProvider>();
    await fp.resetData();
    await HiveService.deleteAll();
  }

  Future<void> _doUpdateProccess(BuildContext context) async {
    var isNeedUpdate = await HiveService.isNeedUpdate();
    if (!isNeedUpdate) return;
    final showIsStartDownloadPopupResult = await AppDialog.showPopup(
        context,
        buildTowButtonDialogContents(
            context,
            AppSize.appBarHeight * 3,
            Padding(
                padding: AppSize.defaultSidePadding,
                child: AppText.text(tr('is_start_down_load_user_all_proccess'),
                    textAlign: TextAlign.start, maxLines: 4)),
            callback: () => 'success'));
    if (showIsStartDownloadPopupResult == 'success') {
      final fp = context.read<FaceDetectionProvider>();
      fp.requestAllUserInfoData(_secondThread);

      var downLoadPopupResult = await AppDialog.showPopup(
        context,
        Selector<FaceDetectionProvider, bool?>(
          selector: (context, provider) => provider.isExtractFeatureDone,
          builder: (context, isDone, _) {
            return buildDialogContents(
              context,
              updateContents(context),
              true,
              AppSize.downloadPopupHeight,
              signgleButtonText:
                  (isDone == null || !isDone) ? tr('cancel') : tr('ok'),
              canPopCallBackk: () async {
                final fp = context.read<FaceDetectionProvider>();
                if (fp.totalCount != fp.responseModel?.data?.length) {
                  var popupResult = await AppDialog.showPopup(
                      context,
                      buildTowButtonDialogContents(
                          context,
                          AppSize.appBarHeight * 3,
                          Padding(
                            padding: EdgeInsets.all(AppSize.padding),
                            child: AppText.text(
                                tr('realy_exit_download_process'),
                                textAlign: TextAlign.start,
                                maxLines: 4),
                          ),
                          callback: () => 'success'));
                  if (popupResult == 'success') {
                    reset(context);
                    return true;
                  }
                  return false;
                } else {
                  return true;
                }
              },
            );
          },
        ),
      );
      if (downLoadPopupResult != null && downLoadPopupResult) {
        reset(context);
      }
    }
  }

  void doFacePreccess(UserEnvironmentModel userEvn) async {
    if (userEvn.isUseFace!) {
      final cp = context.read<CoreVerifyProcessProvider>();
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        pr('notgranted');
        try {
          await Permission.camera.request().then((status) => status.isGranted
              ? cp.setIsShowCamera(val: true)
              : AppSettings.openDeviceSettings());
        } catch (e) {
          pr('nothing');
          return;
        }
      } else {
        if ((CacheService.getUserEnvironment()?.isUseFaceMore ?? false) &&
            await HiveService.isNeedUpdate()) {
          await _doUpdateProccess(context);
          if (!await HiveService.isNeedUpdate()) {
            final fp = context.read<FaceDetectionProvider>();
            Future.delayed(Duration(milliseconds: 300), () {
              fp.setIsFaceFinded(false);
              cp.setIsShowCamera(val: true);
            });
          }
        } else {
          final fp = context.read<FaceDetectionProvider>();
          fp.setIsFaceFinded(false);
          cp.setIsShowCamera(val: true);
        }
      }
    } else {
      await Navigator.pushNamed(context, SettingPage.routeName);
    }
  }

  void routeToSettinsPage(UserEnvironmentModel userEvn) async {
    if (!userEvn.isUseBle! || !userEvn.isUseNfc! || !userEvn.isUseFace!) {
      Navigator.pushNamed(context, SettingPage.routeName);
    } else {
      final result = await AppDialog.showPopup(
          context,
          buildTowButtonDialogContents(
              context,
              AppSize.singlePopupHeight,
              Center(
                child: AppText.text(tr('ble_is_not_avalible_is_set_now')),
              ),
              callback: () => 'success'));
      if (result == 'success') {
        AppSettings.openBluetoothSettings();
      }
    }
  }

  Widget _buildButtonWidget(BuildContext context, bool isBleOk, bool isNfcOk,
      bool isFaceOk, UserEnvironmentModel? userEvn) {
    final cp = context.read<CoreVerifyProcessProvider>();
    final fp = context.read<FaceDetectionProvider>();
    Future.delayed(Duration.zero, () {
      _pageController.jumpToPage(
          CacheService.getLastVerfyType() == VerifyType.BLE ? 0 : 1);
    });
    return FloatingActionButton.large(
        key: Key('home'),
        elevation: 8,
        backgroundColor: AppColors.whiteText,
        onPressed: () async {
          final p = context.read<HomeStartButtonPorvider>();
          final dp = context.read<DeviceStatusProvider>();
          final isSelectedBlue = p.currenPage == 0;
          final isSelectedNfc = dp.isSuppertNfc && p.currenPage == 1;
          final isSelectedFace =
              dp.isSuppertNfc ? p.currenPage == 2 : p.currenPage == 1;
          if (dp.isLocationOk) {
            if (!cp.isTimerRunning) {
              if (isSelectedBlue && isBleOk && userEvn!.isUseBle!) {
                PassKitService.initKit(type: VerifyType.BLE);
              } else if (isSelectedNfc && isNfcOk && userEvn!.isUseNfc!) {
                PassKitService.initKit(type: VerifyType.NFC);
              } else if (isSelectedFace && isFaceOk) {
                // final fp = context.read<FaceDetectionProvider>();
                // final cp = context.read<CoreVerifyProcessProvider>();
                // fp.setIsFaceFinded(false);
                // cp.setIsShowCamera(val: true);
                doFacePreccess(userEvn!);
              } else {
                routeToSettinsPage(userEvn!);
              }
            } else {
              return;
            }
          } else {
            showLocationFaildPopup(context);
          }
        },
        child: Selector<DeviceStatusProvider, bool>(
          selector: (context, provider) => provider.isSuppertNfc,
          builder: (context, isSupportNfc, _) {
            return PageView(
              physics: BouncingScrollPhysics(),
              controller: _pageController
                ..addListener(() {
                  if (_pageController.initialPage != 3) {
                    if (cp.isShowCamera) {
                      cp.setIsShowCamera(val: false);
                      fp.setRecodeStatus(RecordStatus.INIT);
                    }
                  }
                }),
              onPageChanged: (index) {
                final p = context.read<HomeStartButtonPorvider>();
                p.setCurrenPage(index);
              },
              children: isSupportNfc
                  ? [
                      _buildPageViewText(
                          context, 'ble', isStatusOk: isBleOk, userEvn),
                      _buildPageViewText(
                          context, 'nfc', isStatusOk: isNfcOk, userEvn),
                      _buildPageViewText(
                          context, 'face', isStatusOk: isFaceOk, userEvn)
                    ]
                  : [
                      _buildPageViewText(
                          context, 'ble', isStatusOk: isBleOk, userEvn),
                      _buildPageViewText(
                          context, 'face', isStatusOk: isFaceOk, userEvn)
                    ],
            );
          },
        ));
  }

  Widget _buildStartMatchButton(BuildContext context) {
    var largFloatButtonWidth = AppSize.floatButtonWidth;
    return Positioned(
        bottom: AppSize.appBarHeight,
        left: AppSize.realWidth / 2 - largFloatButtonWidth / 2,
        child: GestureDetector(
          onDoubleTap: () {},
          child: Column(
            children: [
              SizedBox(
                  width: largFloatButtonWidth,
                  height: largFloatButtonWidth,
                  child: Selector<DeviceStatusProvider,
                      Tuple4<bool, bool, bool, bool>>(
                    selector: (context, provider) => Tuple4(
                        provider.isBleOk,
                        provider.isNfcOk,
                        provider.isFaceOk,
                        provider.updateSwich),
                    builder: (context, tuple, _) {
                      return _buildButtonWidget(
                          context,
                          tuple.item1,
                          tuple.item2,
                          tuple.item3,
                          CacheService.getUserEnvironment());
                    },
                  ))
            ],
          ),
        ));
  }

  Widget _buildTip() {
    var boxSize = AppSize.defaultContentsWidth * .8;
    return Positioned(
        left: AppSize.defaultContentsWidth - boxSize,
        bottom: AppSize.appBarHeight - AppSize.defaultListItemSpacing * 4,
        child: SizedBox(
          width: boxSize,
          child: AppText.text(tr('home_tip'), style: AppTextStyle.small_sub),
        ));
  }

  Widget _buildLogoImage(BuildContext context) {
    return Positioned(
        top: AppSize.defaultListItemSpacing * 2,
        child: SizedBox(
          height: AppSize.defaultTextFieldHeight,
          child: Center(
            child: Image.asset(
              ImageType.HWST.path,
            ),
          ),
        ));
  }

  Widget _buidCardWidget(BuildContext context) {
    final dp = context.read<DeviceStatusProvider>();
    final userCard = CacheService.getUserCard();
    return Positioned(
      bottom: AppSize.appBarHeight +
          AppSize.floatButtonWidth / 2 -
          AppSize.elevation * 2,
      left: (AppSize.defaultContentsWidth - AppSize.defaultContentsWidth * .8) /
              2 +
          AppSize.elevation / 2,
      child: CardWidget(
        cardType: userCard!.mCardCode!,
        isOverThanIphone10: Platform.isIOS ? dp.isOverThanIphone10 : false,
      ),
    );
  }

  Widget _buildStartMatchButtonJumpToWidget(BuildContext context) {
    return Selector<HomeStartButtonPorvider, int>(
      selector: (context, provider) => provider.currenPage,
      builder: (context, currenPage, _) {
        Future.delayed(Duration.zero, () {
          _pageController.jumpToPage(currenPage);
        });
        return SizedBox();
      },
    );
  }

  Widget _buildContents(BuildContext context) {
    final userCard = CacheService.getUserCard()!;
    var isCard1 = userCard.mCardCode == '1';
    var isCard2 = userCard.mCardCode == '2';
    return Container(
        height: AppSize.realHeight - AppSize.appBarHeight,
        decoration: BoxDecoration(
            image: isCard1 || isCard2
                ? DecorationImage(
                    image: AssetImage(isCard1
                        ? ImageType.CARD_ONE.path
                        : ImageType.CARD_TWO.path),
                    fit: BoxFit.cover)
                : null),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const DefaultTitleDevider(),
            defaultSpacing(multiple: 2),
            _popupContents(context),
            _buildLogoImage(context),
            _buidCardWidget(context),
            _buildStartMatchButton(context),
            _buildStartMatchButtonJumpToWidget(context),
            _buildTip(),
          ],
        ));
  }

  void showLicense(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Theme(
            data: ThemeData(
                cardColor: AppColors.homeBgColor,
                appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.whiteText,
                    titleSpacing:
                        Platform.isAndroid ? AppSize.realWidth / 2 - 100 : null,
                    titleTextStyle: AppTextStyle.bold_22,
                    iconTheme: IconThemeData(color: AppColors.subText))),
            child: LicensePage(
              applicationName: BioCubeBuildConfig.APP_NAME,
              applicationVersion: BioCubeBuildConfig.APP_VERSION_NAME,
              applicationIcon: Image.asset(
                ImageType.LOGO.path,
                width: AppSize.realWidth * .4,
                height: 50,
              ),
              applicationLegalese:
                  '''Our company's software guards the GPL software open source agreement''',
            )),
      ),
    );
  }

  Widget _buildCloseApp(BuildContext context) {
    return Positioned(
        top: AppSize.appBarHeight,
        right: AppSize.padding,
        child: GestureDetector(
          onTap: () async {
            final result = await AppDialog.showPopup(
                context,
                buildTowButtonDialogContents(
                    context,
                    AppSize.singlePupopHeight,
                    Center(
                      child: AppText.text(tr('is_really_exit_app')),
                    ),
                    callback: () => 'isPressedTrue'));
            if (result != null && result == 'isPressedTrue') {
              exit(0);
            }
          },
          child: Icon(Icons.close),
        ));
  }

  Widget _buildIconRow(BuildContext context, DrawerIconType type) {
    Widget? icon;
    switch (type) {
      case DrawerIconType.HOME:
        icon = Icon(Icons.home);
        break;
      case DrawerIconType.ENVIRONMENT:
        icon = Icon(Icons.settings);
        break;
      case DrawerIconType.HISTORY:
        icon = Icon(Icons.access_time_filled);
        break;
      case DrawerIconType.INFO:
        icon = Icon(Icons.info);
        break;
      case DrawerIconType.LICENCE:
        icon = Icon(Icons.insert_drive_file_outlined);
        break;
      case DrawerIconType.MOBILE_CARD_INFO:
        icon = Icon(Icons.credit_card);
        break;
      case DrawerIconType.PRIVACY_POLICY:
        icon = Icon(Icons.add_moderator_outlined);
        break;
      case DrawerIconType.TERMS_OF_USER:
        icon = Icon(Icons.folder_shared_outlined);
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        isCardValidate(context).then((isValid) {
          if (isValid) {
            if (type == DrawerIconType.HOME) {
              Navigator.pop(context);
            } else if (type == DrawerIconType.LICENCE) {
              showLicense(context);
            } else {
              Navigator.pushNamed(context, type.routeName);
            }
          }
        });
      },
      child: Padding(
          padding: EdgeInsets.only(bottom: AppSize.padding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Padding(padding: EdgeInsets.only(right: AppSize.padding * 2)),
              Expanded(
                child: AppText.text(type.title, textAlign: TextAlign.start),
              )
            ],
          )),
    );
  }

  Widget _buildDrawerTitle(BuildContext context) {
    var userCard = CacheService.getUserCard()!;
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary,
        ),
        child: Stack(
          children: [
            Positioned(
                bottom: AppSize.defaultListItemSpacing * 4,
                left: 0,
                child: Padding(
                  padding: AppSize.defaultSidePadding * 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      defaultSpacing(height: AppSize.appBarHeight * 1.2),
                      AppText.text(userCard.mName ?? '',
                          textAlign: TextAlign.left,
                          style: AppTextStyle.bold30),
                      AppText.text(userCard.mPoName ?? '',
                          textAlign: TextAlign.left,
                          style: AppTextStyle.bold30),
                      AppText.text(userCard.mMail ?? '',
                          textAlign: TextAlign.left,
                          style: AppTextStyle.bold_18),
                    ],
                  ),
                ))
          ],
        ));
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
        child: Stack(
      children: [
        Column(
          children: [
            Expanded(child: _buildDrawerTitle(context)),
            Container(
                padding: AppSize.defaultSidePadding * 2,
                alignment: Alignment.center,
                height: AppSize.realHeight * .7,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildIconRow(context, DrawerIconType.HOME),
                    _buildIconRow(context, DrawerIconType.HISTORY),
                    _buildIconRow(context, DrawerIconType.MOBILE_CARD_INFO),
                    _buildIconRow(context, DrawerIconType.ENVIRONMENT),
                    _buildIconRow(context, DrawerIconType.TERMS_OF_USER),
                    _buildIconRow(context, DrawerIconType.PRIVACY_POLICY),
                    _buildIconRow(context, DrawerIconType.LICENCE),
                    _buildIconRow(context, DrawerIconType.INFO),
                  ],
                )),
          ],
        ),
        _buildCloseApp(context)
      ],
    ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.whiteText,
      iconTheme: IconThemeData(color: AppColors.defaultText),
      elevation: 0,
      shadowColor: AppColors.whiteText,
      shape: null,
      title: Container(
        width: AppSize.realWidth * .5,
        child:
            AppText.text(tr('mobile_access_pass'), style: AppTextStyle.bold_22),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: AppSize.padding),
            child: SizedBox(
              width: AppSize.realWidth * .15,
              child: Image.asset(
                ImageType.HWST.path,
                height: AppSize.appBarHeight / 5,
              ),
            ))
      ],
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
        body: Selector<HomePageProvider, bool>(
      selector: (context, provider) => provider.isLoadData,
      builder: (context, isLoadData, _) {
        return isLoadData
            ? BaseLoadingViewOnStackWidget.build(context, isLoadData,
                color: Colors.white)
            : Container();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageProvider(),
      builder: (context, _) {
        final p = context.read<HomePageProvider>();
        return Scaffold(
          appBar: _buildAppBar(context),
          drawer: _buildDrawer(context),
          body: FutureBuilder<ResultModel>(
              future: p.getUserCard(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null &&
                    snapshot.data!.isSuccessful) {
                  return _buildContents(context);
                }
                return _buildLoadingScreen(context);
              }),
        );
      },
    );
  }
}
