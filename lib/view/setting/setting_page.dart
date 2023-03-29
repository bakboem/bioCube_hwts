/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/setting/setting_page.dart
 * Created Date: 2023-01-27 11:51:50
 * Last Modified: 2023-03-29 09:28:26
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:hwst/enums/hive_box_type.dart';
import 'package:hwst/enums/slider_type.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/app_text.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/enums/swich_type.dart';
import 'package:hwst/styles/app_style.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/enums/language_type.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/hive_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:hwst/service/pass_kit_service.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/globalProvider/app_theme_provider.dart';
import 'package:hwst/view/common/widget_of_divider_line.dart';
import 'package:hwst/view/common/function_of_pop_to_first.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';
import 'package:hwst/view/common/widget_of_dialog_contents.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/view/common/widget_of_download_progress.dart';
import 'package:hwst/view/setting/provider/setting_page_provider.dart';
import 'package:hwst/view/home/camera/threadController/second_thread_process.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  static final String routeName = '/settingPage';
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var nfcSwich = ValueNotifier(false);
  var bleSwich = ValueNotifier(false);
  var faceSwich = ValueNotifier(false);
  late SecondThread _secondThread;
  List<String> veifyRadioList = [];
  List<String> cameraRadioList = [];
  List<String> combinationVeifyRadioList = [];
  List<String> guideMethodRadioList = [];

  @override
  void initState() {
    super.initState();
    _secondThread = SecondThread();
    Future.delayed(Duration.zero, () {
      final ap = context.read<AppThemeProvider>();
      ap.setLanguageType(
          type: LanguageType.values
              .where((element) =>
                  element.name ==
                  KeyService.baseAppKey.currentContext!.locale.countryCode)
              .single);
    });
  }

  @override
  void dispose() {
    bleSwich.dispose();
    nfcSwich.dispose();
    faceSwich.dispose();
    _secondThread.secondThreadDestroy(killOnly: true);
    pr('dispose settings');
    super.dispose();
  }

  Widget _buildSwich(BuildContext context, SwichType type, GlobalKey swichKey) {
    final p = context.read<SettinPageProivder>();
    nfcSwich.value = p.nfcSwichVal;
    bleSwich.value = p.bleSwichVal;
    faceSwich.value = p.faceSwichVal;
    return Container(
      child: ValueListenableBuilder<bool?>(
        valueListenable: type == SwichType.NFC
            ? nfcSwich
            : type == SwichType.BLE
                ? bleSwich
                : faceSwich,
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.zero,
            child: Switch(
              key: swichKey,
              value: value ?? false,
              onChanged: (value) async {
                switch (type) {
                  case SwichType.NFC:
                    nfcSwich.value = value;
                    p.setNfcSwich();
                    break;
                  case SwichType.BLE:
                    bleSwich.value = value;
                    p.setBleSwich();
                    break;
                  case SwichType.FACE:
                    faceSwich.value = value;
                    p.setFaceSwich();
                    break;
                }
                p.setUserEnvrionment(context);
              },
              activeTrackColor: AppColors.primary,
              activeColor: AppColors.whiteText,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcons(LanguageType type) {
    return SizedBox(
      width: 50,
      height: 20,
      child: Image.asset(
        type.iconPath,
      ),
    );
  }

  Widget _buildLangugeSelector(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: AppText.text(tr('language'), textAlign: TextAlign.start),
        ),
        Spacer(),
        Selector<AppThemeProvider, LanguageType?>(
          selector: (context, provider) => provider.languageType,
          builder: (context, languge, _) {
            return Container(
              width: AppSize.defaultContentsWidth * .4,
              child: DropdownButton(
                underline: SizedBox(),
                enableFeedback: false,
                menuMaxHeight: AppSize.smallPopupHeight,
                dropdownColor: AppColors.whiteText,
                isExpanded: true,
                icon: _buildIcons(languge != null ? languge : LanguageType.KR),
                borderRadius: BorderRadius.circular(AppSize.radius15),
                value: languge == null ? '한국어' : languge.localText,
                items: LanguageType.values
                    .asMap()
                    .entries
                    .map(
                      (map) => DropdownMenuItem(
                        value: LanguageType.values[map.key].localText,
                        child: Text(LanguageType.values[map.key].localText,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: ((value) {
                  final tp = context.read<AppThemeProvider>();
                  tp.setLanguageType(text: value);
                  context.setLocale(tp.languageType!.locale);
                  setState(() {});
                }),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildButtonItem(BuildContext context, SwichType type, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitleText(context, title, true),
        _buildSwich(context, type, GlobalKey(debugLabel: type.name)),
      ],
    );
  }

  Widget _buildIsUseBleButton(BuildContext context) {
    return _buildButtonItem(context, SwichType.BLE, tr('is_use_ble'));
  }

  Widget _buildIsUseNfcButton(BuildContext context) {
    return _buildButtonItem(context, SwichType.NFC, tr('is_use_nfc'));
  }

  Widget _buildIsUseFaceButton(BuildContext context) {
    return _buildButtonItem(
        context, SwichType.FACE, tr('is_use_face_recognition'));
  }

  Widget _buildTitleText(BuildContext context, String title, bool isTitle) {
    return AppText.text(title,
        style: isTitle ? AppTextStyle.w500_16 : AppTextStyle.default_12,
        maxLines: isTitle ? null : 2);
  }

  Widget _buildRadioIcon(BuildContext context, String? currenStr,
      bool? isCombinationVeify, int index, bool? isUseFace) {
    final p = context.read<SettinPageProivder>();
    return SizedBox(
      width: 10,
      height: 10,
      child: Radio<String>(
        activeColor: AppColors.primary,
        visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: isCombinationVeify != null && isUseFace == null
            ? combinationVeifyRadioList[index]
            : isUseFace == null
                ? veifyRadioList[index]
                : cameraRadioList[index],
        groupValue: currenStr,
        onChanged: (_) {
          isCombinationVeify != null && isUseFace == null
              ? () {
                  if (p.faceSwichVal == false) {
                    faceSwich.value = true;
                    p.setFaceSwich();
                  }
                  p.setCombinationVeifyRadioStr(
                      combinationVeifyRadioList, index);
                }()
              : isUseFace == null
                  ? () {
                      if (faceSwich.value) {
                        faceSwich.value = false;
                        p.setFaceSwich();
                      }
                      p.setCurrenVeirfyRadioStr(veifyRadioList, index);
                    }()
                  : () async {
                      p.setCameraRadioStr(cameraRadioList, index);
                      p.setFaceMoreSwich(true);
                      var isSelectedOneToOne =
                          p.cameraRadioList.indexOf(p.cameraRadioStr) == 0;
                      if (isSelectedOneToOne) {
                        p.setFaceMoreSwich(false);
                      } else {
                        await _doUpdateProccess(context);
                      }
                    }();
          p.setUserEnvrionment(context);
          final dp = context.read<DeviceStatusProvider>();
          dp.doUpdateStatus();
        },
      ),
    );
  }

  void reset(BuildContext context) async {
    final fp = context.read<FaceDetectionProvider>();
    await fp.resetData();
    // await HiveService.deleteAll();
  }

  Future<void> _doUpdateProccess(BuildContext context) async {
    final p = context.read<SettinPageProivder>();
    final dp = context.read<DeviceStatusProvider>();
    var isNeedUpdate = await HiveService.isNeedUpdate();
    if (!isNeedUpdate) return;
    // 1:N 선택했으면
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
            return buildDialogContents(context, updateContents(context), true,
                AppSize.downloadPopupHeight,
                signgleButtonText: (isDone == null || !isDone)
                    ? tr('cancel')
                    : tr('ok'), canPopCallBackk: () async {
              final fp = context.read<FaceDetectionProvider>();
              if (fp.totalCount != fp.responseModel?.data?.length ||
                  fp.extractFeatrueComplateCount != fp.extractFeatrueCount) {
                var popupResult = await AppDialog.showPopup(
                    context,
                    buildTowButtonDialogContents(
                        context,
                        AppSize.appBarHeight * 3,
                        Padding(
                          padding: EdgeInsets.all(AppSize.padding),
                          child: AppText.text(tr('realy_exit_download_process'),
                              textAlign: TextAlign.start, maxLines: 4),
                        ),
                        callback: () => 'success'));
                if (popupResult == 'success') {
                  reset(context);
                  p.setCameraRadioStr(cameraRadioList, 0);
                  p.setFaceMoreSwich(false);
                  return true;
                }
                return false;
              } else {
                return true;
              }
            });
          },
        ),
      );
      if (downLoadPopupResult != null && downLoadPopupResult) {
        reset(context);
      }
    } else {
      p.setCameraRadioStr(cameraRadioList, 0);
      p.setFaceMoreSwich(false);
    }
    p.setUserEnvrionment(context);
    dp.doUpdateStatus();
  }

  Widget _buildRadioText(BuildContext context, String? currenStr,
      bool? isCombinationVeify, int index, bool? isUseFace) {
    return Expanded(
        child: AppText.text(
            isCombinationVeify != null
                ? combinationVeifyRadioList[index]
                : isUseFace == null
                    ? veifyRadioList[index]
                    : cameraRadioList[index],
            style: currenStr == veifyRadioList[index] ||
                    (isCombinationVeify != null &&
                        currenStr == combinationVeifyRadioList[index]) ||
                    (currenStr == cameraRadioList[index])
                ? AppTextStyle.default_14.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyle.sub_14));
  }

  Widget _buildRadioItem(BuildContext context, int index, String? currenStr,
      bool? isCombinationVeify, bool? isUseFace) {
    final p = context.read<SettinPageProivder>();
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await Future.delayed(Duration.zero, () {
            isCombinationVeify != null && isUseFace == null
                ? () {
                    if (p.faceSwichVal == false) {
                      faceSwich.value = true;
                      p.setFaceSwich();
                    }
                    p.setCombinationVeifyRadioStr(
                        combinationVeifyRadioList, index);
                  }()
                : isUseFace == null
                    ? () {
                        if (faceSwich.value) {
                          faceSwich.value = false;
                          p.setFaceSwich();
                        }
                        p.setCurrenVeirfyRadioStr(veifyRadioList, index);
                      }()
                    : () async {
                        p.setCameraRadioStr(cameraRadioList, index);
                        p.setFaceMoreSwich(true);
                        var isSelectedOneToOne =
                            p.cameraRadioList.indexOf(p.cameraRadioStr) == 0;
                        if (isSelectedOneToOne) {
                          p.setFaceMoreSwich(false);
                        } else {
                          await _doUpdateProccess(context);
                        }
                      }();
          });
          p.setUserEnvrionment(context);
          final dp = context.read<DeviceStatusProvider>();
          dp.doUpdateStatus();
        },
        child: Container(
          width: AppSize.defaultContentsWidth / 2,
          padding: AppSize.defaultSidePadding,
          child: Row(
            children: [
              _buildRadioIcon(
                  context, currenStr, isCombinationVeify, index, isUseFace),
              Padding(padding: EdgeInsets.only(right: AppSize.padding)),
              _buildRadioText(
                  context, currenStr, isCombinationVeify, index, isUseFace)
            ],
          ),
        ));
  }

  Widget _buildGuideMethodItem(
      BuildContext context, int index, String? currenStr) {
    final p = context.read<SettinPageProivder>();
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          p.setCurrenGuideMethodStr(guideMethodRadioList, index);
          p.setUserEnvrionment(context);
        },
        child: Container(
          padding: AppSize.defaultSidePadding,
          width: AppSize.defaultContentsWidth / 3,
          child: Row(
            children: [
              SizedBox(
                width: 10,
                height: 10,
                child: Radio<String>(
                  activeColor: AppColors.primary,
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: guideMethodRadioList[index],
                  groupValue: currenStr,
                  onChanged: (_) {
                    p.setCurrenGuideMethodStr(guideMethodRadioList, index);
                    p.setUserEnvrionment(context);
                  },
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
              Expanded(
                child: AppText.text(guideMethodRadioList[index],
                    style: currenStr == guideMethodRadioList[index]
                        ? AppTextStyle.default_14
                            .copyWith(fontWeight: FontWeight.w600)
                        : AppTextStyle.sub_14),
              )
            ],
          ),
        ));
  }

  Widget _buildVeirfyTypeWidget(BuildContext context) {
    return Selector<SettinPageProivder, String?>(
      selector: (context, provider) => provider.currenVeirfyRadioStr,
      builder: (context, str, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...veifyRadioList.asMap().entries.map((map) =>
                _buildRadioItem(context, map.key, str ?? '', null, null))
          ],
        );
      },
    );
  }

  Widget _buildCameraTypeWidget(BuildContext context) {
    return Selector<SettinPageProivder, Tuple2<String?, bool>>(
      selector: (context, provider) =>
          Tuple2(provider.cameraRadioStr, provider.faceSwichVal),
      builder: (context, tuple, _) {
        return !tuple.item2
            ? SizedBox()
            : Column(
                children: [
                  defaultSpacing(multiple: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...cameraRadioList.asMap().entries.map((map) =>
                          _buildRadioItem(
                              context, map.key, tuple.item1 ?? '', null, true))
                    ],
                  )
                ],
              );
      },
    );
  }

  Widget _buildGuideMethodWidget(BuildContext context) {
    return Selector<SettinPageProivder, String?>(
      selector: (context, provider) => provider.currenGuideMethod,
      builder: (context, str, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...guideMethodRadioList.asMap().entries.map(
                (map) => _buildGuideMethodItem(context, map.key, str ?? ''))
          ],
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Container(
      alignment: Alignment.centerLeft,
      width: AppSize.defaultContentsWidth,
      child: _buildTitleText(context, title, true),
    );
  }

  Widget _buidSignOutWidget(BuildContext context) {
    return Padding(
      padding: AppSize.defaultSidePadding * .8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.text(tr('stop_using_card_request'),
              style: AppTextStyle.sub_14),
          AppStyles.buildButton(
              context,
              tr('ok'),
              AppSize.smallButtonWidth,
              AppColors.primary,
              AppTextStyle.sub_12.copyWith(color: AppColors.whiteText),
              AppSize.radius8, () async {
            final result = await AppDialog.showPopup(
                context,
                buildTowButtonDialogContents(
                    context,
                    AppSize.singlePopupHeight,
                    Center(
                      child: AppText.text(tr('is_really_stop_use_card')),
                    ), callback: () {
                  return 'ok';
                }));
            if (result != null && result == 'ok') {
              CacheService.deleteALL();
              await HiveService.init(HiveBoxType.USER_INFO);
              await HiveService.deleteAll();
              final ap = context.read<AuthProvider>();
              ap.setIsLogedIn(false);
              popToFirst(context);
            }
          }, selfHeight: AppSize.smallButtonHeight)
        ],
      ),
    );
  }

  Widget _buildRssiSlider(BuildContext context) {
    return Selector<SettinPageProivder, String?>(
      selector: (context, provider) => provider.rssi,
      builder: (context, val, _) {
        return val == null
            ? SizedBox()
            : Slider(
                label:
                    '${double.parse(val).toInt() < -70 ? tr('strong_signal') : double.parse(val).toInt() < -50 ? tr('normal_signal') : tr('weak_signal')}  $val',
                secondaryTrackValue: -80,
                value: double.parse(val),
                max: 0,
                min: -100,
                divisions: 100,
                onChangeEnd: (t) {
                  final p = context.read<SettinPageProivder>();
                  p.setUserEnvrionment(context);
                  PassKitService.setRssi();
                },
                onChanged: (t) {
                  final p = context.read<SettinPageProivder>();
                  p.setRssi(t.toInt().toString());
                });
      },
    );
  }

  Widget _buildTips(String str) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.padding),
        child: AppText.text('Tip:$str',
            style: AppTextStyle.small_sub,
            textAlign: TextAlign.start,
            maxLines: 2));
  }

  Widget _buildSessionTimeSlider(BuildContext context) {
    return Selector<SettinPageProivder, int?>(
      selector: (context, provider) => provider.sessionSettingTime,
      builder: (context, session, _) {
        return Slider(
            max: 60,
            min: 20,
            divisions: 60,
            label: '${session?.toInt()} sec',
            value: session != null ? session.toDouble() : 20,
            onChangeEnd: (s) {
              final p = context.read<SettinPageProivder>();
              p.setUserEnvrionment(context);
              PassKitService.setSessionTime();
            },
            onChanged: (s) {
              final p = context.read<SettinPageProivder>();
              p.setSessionTime(s.toInt());
            });
      },
    );
  }

  Widget _buildScoreSlider(BuildContext context) {
    return Selector<SettinPageProivder, int?>(
      selector: (context, provider) => provider.scoreSetting,
      builder: (context, score, _) {
        return Slider(
            max: 80,
            min: 0,
            divisions: 80,
            label: '${score ?? 0} score',
            value: score != null ? score.toDouble() : 75,
            onChangeEnd: (s) {
              final p = context.read<SettinPageProivder>();
              p.setUserEnvrionment(context);
            },
            onChanged: (s) {
              final p = context.read<SettinPageProivder>();
              p.setScore(s.toInt());
            });
      },
    );
  }

  Widget _buildTitleRow(BuildContext context, String title,
      {required SliderType type}) {
    return Padding(
      padding: EdgeInsets.only(right: AppSize.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.text(title),
          type == SliderType.RSSI
              ? Selector<SettinPageProivder, String?>(
                  selector: (context, provider) => provider.rssi,
                  builder: (context, val, _) {
                    return AppText.text('$val dBm');
                  },
                )
              : type == SliderType.SESSION
                  ? Selector<SettinPageProivder, int?>(
                      selector: (context, provider) =>
                          provider.sessionSettingTime,
                      builder: (context, val, _) {
                        return AppText.text('$val sec');
                      },
                    )
                  : Selector<SettinPageProivder, int?>(
                      selector: (context, provider) => provider.scoreSetting,
                      builder: (context, val, _) {
                        return AppText.text('$val score');
                      },
                    )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    veifyRadioList = [tr('fixed_type'), tr('personal')];
    combinationVeifyRadioList = [tr('face_and_ble'), tr('face_and_nfc')];
    guideMethodRadioList = [tr('vibration'), tr('system_voice'), tr('sound')];
    cameraRadioList = [tr('one_to_one'), tr('one_to_more')];
    return BaseLayout(
        hasForm: false,
        appBar: appBarContents(context,
            text: tr('set_user_env'), isUseActionIcon: true),
        child: ChangeNotifierProvider(
          create: (context) => SettinPageProivder(),
          builder: (context, _) {
            return FutureBuilder<ResultModel>(
                future: context.read<SettinPageProivder>().init(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        const DefaultTitleDevider(),
                        Expanded(
                            child: ListView(
                          padding: AppSize.defaultSidePadding,
                          // physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildLangugeSelector(context),
                            _buildIsUseNfcButton(context),
                            _buildIsUseBleButton(context),
                            _buildIsUseFaceButton(context),
                            _buildCameraTypeWidget(context),
                            defaultSpacing(multiple: 2),
                            Divider(height: 1, color: AppColors.subText),

                            Platform.isAndroid
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      defaultSpacing(multiple: 2),
                                      _buildTitleRow(
                                          context, tr('rssi_setting'),
                                          type: SliderType.RSSI),
                                      defaultSpacing(),
                                      _buildRssiSlider(context),
                                      defaultSpacing(),
                                      _buildTips(tr('slider_description')),
                                      defaultSpacing(),
                                      _buildTitleRow(
                                          context, tr('session_setting'),
                                          type: SliderType.SESSION),
                                      _buildSessionTimeSlider(context),
                                      defaultSpacing(),
                                      _buildTips(tr('session_description')),
                                      defaultSpacing(),
                                      _buildTitleRow(
                                          context, tr('score_setting'),
                                          type: SliderType.SCORE),
                                      _buildScoreSlider(context),
                                      defaultSpacing(),
                                      _buildTips(tr('score_description')),
                                    ],
                                  )
                                : SizedBox(),
                            defaultSpacing(multiple: 2),
                            _buildTitle(context, tr('specified_use')),
                            defaultSpacing(),
                            _buildVeirfyTypeWidget(context),
                            defaultSpacing(multiple: 2),
                            // _buildVerifyTypeByChoic(context),
                            // defaultSpacing(),
                            _buildTitle(context, tr('guide_method')),
                            defaultSpacing(),
                            _buildGuideMethodWidget(context),
                            defaultSpacing(multiple: 2),
                            _buildTitle(context, tr('stop_using_request')),
                            defaultSpacing(),
                            _buidSignOutWidget(context),
                            defaultSpacing(height: AppSize.appBarHeight),
                          ],
                        ))
                      ],
                    );
                  }
                  return Container();
                });
          },
        ));
  }
}
