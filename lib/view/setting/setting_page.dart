/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/setting/setting_page.dart
 * Created Date: 2023-01-27 11:51:50
 * Last Modified: 2023-02-26 16:08:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hwst/service/pass_kit_service.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/app_text.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/enums/swich_type.dart';
import 'package:hwst/styles/app_style.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/enums/language_type.dart';
import 'package:hwst/service/key_service.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/globalProvider/app_theme_provider.dart';
import 'package:hwst/view/common/widget_of_divider_line.dart';
import 'package:hwst/view/common/function_of_pop_to_first.dart';
import 'package:hwst/view/common/widget_of_dialog_contents.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/setting/provider/setting_page_provider.dart';

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
  List<String> veifyRadioList = [];
  List<String> combinationVeifyRadioList = [];
  List<String> guideMethodRadioList = [];

  @override
  void initState() {
    super.initState();
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
                    p.veifyRadioList.indexOf(p.currenVeirfyRadioStr) == 0
                        ? AppDialog.showDangermessage(context,
                            tr('fixed_type_can_not_use_face_detection'))
                        : () {
                            faceSwich.value = value;
                            p.setFaceSwich();
                          }();
                    break;
                }
                p.setUserEnvrionment();
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
      bool? isCombinationVeify, int index) {
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
        value: isCombinationVeify != null
            ? combinationVeifyRadioList[index]
            : veifyRadioList[index],
        groupValue: currenStr,
        onChanged: (_) {
          isCombinationVeify != null
              ? () {
                  if (p.faceSwichVal == false) {
                    faceSwich.value = true;
                    p.setFaceSwich();
                    p.setUserEnvrionment();
                  }
                  p.setCombinationVeifyRadioStr(
                      combinationVeifyRadioList, index);
                }()
              : () {
                  if (faceSwich.value) {
                    faceSwich.value = false;
                    p.setFaceSwich();
                    p.setUserEnvrionment();
                  }
                  p.setCurrenVeirfyRadioStr(veifyRadioList, index);
                }();
          p.setUserEnvrionment();
        },
      ),
    );
  }

  Widget _buildRadioText(BuildContext context, String? currenStr,
      bool? isCombinationVeify, int index) {
    return Expanded(
        child: AppText.text(
            isCombinationVeify != null
                ? combinationVeifyRadioList[index]
                : veifyRadioList[index],
            style: currenStr == veifyRadioList[index] ||
                    (isCombinationVeify != null &&
                        currenStr == combinationVeifyRadioList[index])
                ? AppTextStyle.default_14.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyle.sub_14));
  }

  Widget _buildRadioItem(BuildContext context, int index, String? currenStr,
      bool? isCombinationVeify) {
    final p = context.read<SettinPageProivder>();
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Future.delayed(Duration.zero, () {
            isCombinationVeify != null
                ? () {
                    if (p.faceSwichVal == false) {
                      faceSwich.value = true;
                      p.setFaceSwich();
                      p.setUserEnvrionment();
                    }
                    p.setCombinationVeifyRadioStr(
                        combinationVeifyRadioList, index);
                  }()
                : () {
                    if (faceSwich.value) {
                      faceSwich.value = false;
                      p.setFaceSwich();
                      p.setUserEnvrionment();
                    }
                    p.setCurrenVeirfyRadioStr(veifyRadioList, index);
                  }();
          }).whenComplete(() => p.setUserEnvrionment());
        },
        child: Container(
          width: AppSize.defaultContentsWidth / 2,
          padding: AppSize.defaultSidePadding,
          child: Row(
            children: [
              _buildRadioIcon(context, currenStr, isCombinationVeify, index),
              Padding(padding: EdgeInsets.only(right: AppSize.padding)),
              _buildRadioText(context, currenStr, isCombinationVeify, index)
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
          p.setUserEnvrionment();
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
                    p.setUserEnvrionment();
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(right: AppSize.padding)),
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
            ...veifyRadioList.asMap().entries.map(
                (map) => _buildRadioItem(context, map.key, str ?? '', null))
          ],
        );
      },
    );
  }

  // Widget _buildCombinationVrirfyWidget(BuildContext context) {
  //   return Selector<SettinPageProivder, String?>(
  //     selector: (context, provider) => provider.combinationVeifyRadioStr,
  //     builder: (context, str, _) {
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           ...combinationVeifyRadioList.asMap().entries.map(
  //               (map) => _buildRadioItem(context, map.key, str ?? '', true))
  //         ],
  //       );
  //     },
  //   );
  // }

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

  // Widget _buildVerifyTypeByChoic(BuildContext context) {
  //   return Selector<SettinPageProivder, String?>(
  //     selector: (context, provider) => provider.currenVeirfyRadioStr,
  //     builder: (context, verifyType, _) {
  //       return verifyType != null && verifyType == tr('personal')
  //           ? Column(
  //               children: [
  //                 _buildTitle(context, tr('combination_type_choic')),
  //                 defaultSpacing(),
  //                 _buildCombinationVrirfyWidget(context),
  //                 defaultSpacing(),
  //               ],
  //             )
  //           : Container();
  //     },
  //   );
  // }

  Widget _buidStopUsingRequestWidget(BuildContext context) {
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
              final ap = context.read<AuthProvider>();
              ap.setIsLogedIn(false);
              popToFirst(context);
            }
          }, selfHeight: AppSize.smallButtonHeight)
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    return Selector<SettinPageProivder, int?>(
      selector: (context, provider) => provider.rssi,
      builder: (context, val, _) {
        return val == null
            ? SizedBox()
            : SizedBox(
                height: AppSize.defaultListItemSpacing * 3,
                child: Slider(
                    label:
                        '${val < -50 ? tr('strong_signal') : val < -30 ? tr('normal_signal') : tr('weak_signal')}  $val',
                    secondaryTrackValue: -40,
                    value: val.toDouble(),
                    max: 0,
                    min: -100,
                    divisions: 100,
                    onChangeEnd: (t) {
                      final p = context.read<SettinPageProivder>();
                      p.setUserEnvrionment();
                      PassKitService.setRssi();
                    },
                    onChanged: (t) {
                      final p = context.read<SettinPageProivder>();
                      p.setRssi(t.toInt());
                    }),
              );
      },
    );
  }

  Widget _buildSliderTip() {
    return Padding(
        padding: EdgeInsets.only(left: AppSize.padding),
        child: AppText.text('Tip:${tr('slider_description')}',
            style: AppTextStyle.small_sub, textAlign: TextAlign.start));
  }

  @override
  Widget build(BuildContext context) {
    veifyRadioList = [tr('fixed_type'), tr('personal')];
    combinationVeifyRadioList = [tr('face_and_ble'), tr('face_and_nfc')];
    guideMethodRadioList = [tr('vibration'), tr('system_voice'), tr('sound')];
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
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildLangugeSelector(context),
                            _buildIsUseNfcButton(context),
                            _buildIsUseBleButton(context),
                            _buildIsUseFaceButton(context),
                            defaultSpacing(multiple: 2),
                            Divider(height: 1, color: AppColors.subText),

                            Platform.isAndroid
                                ? Column(
                                    children: [
                                      defaultSpacing(multiple: 2),
                                      _buildTitle(context, tr('rssi_setting')),
                                      defaultSpacing(),
                                      _buildSlider(context),
                                      defaultSpacing(),
                                      _buildSliderTip(),
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
                            _buidStopUsingRequestWidget(context)
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
