/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/shwt/lib/view/auth/auth_page.dart
 * Created Date: 2023-01-22 19:10:16
 * Last Modified: 2023-03-04 10:45:25
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/app_text.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:app_settings/app_settings.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/styles/app_style.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/enums/signin_type.dart';
import 'package:hwst/view/home/home_page.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/view/terms/terms_page.dart';
import 'package:hwst/enums/input_icon_type.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:hwst/service/permission_service.dart';
import 'package:hwst/view/common/base_app_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/globalProvider/timer_provider.dart';
import 'package:hwst/view/common/base_input_widget.dart';
import 'package:hwst/globalProvider/device_status_provider.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/common/function_of_hidden_key_borad.dart';
import 'package:hwst/view/signin/provider/signin_page_provider.dart';
import 'package:hwst/view/common/base_text_controller_factory_widget.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});
  static final routeName = '/SigninPage';
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  void initState() {
    final ap = context.read<AuthProvider>();
    ap.checkIsLogedIn(false);
    PermissionService.requestLocationAndBle()
        .then((_) => PermissionService.checkLocationAndBle());
    super.initState();
  }

  Widget _buildAssessKeyInput(BuildContext context) {
    final sp = context.read<SigninPageProvider>();
    return Selector<SigninPageProvider, String?>(
      selector: (context, provider) => provider.accessKeyInputStr,
      builder: (context, assessKey, _) {
        return BaseTextControllerFactoryWidget(
            textEditHookWidget: (controller, focus) {
          if (assessKey == null) {
            controller.clear();
          }
          return BaseInputWidget(
            context: context,
            textEditingController: controller,
            focusNode: focus,
            keybordType: TextInputType.number,
            hintText: assessKey == null || assessKey.isEmpty
                ? tr('plz_enter_assess_key')
                : assessKey,
            hintTextStyleCallBack: () => assessKey == null
                ? AppTextStyle.hint_16
                : AppTextStyle.default_16,
            iconType: assessKey != null && assessKey.isNotEmpty
                ? InputIconType.DELETE
                : null,
            defaultIconCallback: () {
              sp.setAccessKey(null);
              controller.clear();
              focus.unfocus();
            },
            width: AppSize.defaultContentsWidth,
            onChangeCallBack: (str) => sp.setAccessKey(str),
            enable: true,
          );
        });
      },
    );
  }

  Widget _emailOrPhoneInput(BuildContext context) {
    final sp = context.read<SigninPageProvider>();
    return Selector<SigninPageProvider, Tuple2<String?, SigninType>>(
      selector: (context, provider) =>
          Tuple2(provider.loginAccountInputStr, provider.signinType),
      builder: (context, tuple, _) {
        return BaseTextControllerFactoryWidget(
            textEditHookWidget: (controller, focus) {
          if (tuple.item1 == null) {
            controller.clear();
          }
          return BaseInputWidget(
            context: context,
            textEditingController: controller,
            focusNode: focus,
            keybordType:
                tuple.item2 == SigninType.EMAIL ? null : TextInputType.phone,
            hintText: tuple.item1 == null || tuple.item1!.isEmpty
                ? tuple.item2 == SigninType.EMAIL
                    ? tr('plz_enter_email')
                    : tr('plz_enter_phone_number')
                : tuple.item1,
            hintTextStyleCallBack: () => tuple.item1 == null
                ? AppTextStyle.hint_16
                : AppTextStyle.default_16,
            iconType: tuple.item1 != null && tuple.item1!.isNotEmpty
                ? InputIconType.DELETE
                : null,
            defaultIconCallback: () {
              sp.setLoginAccount(null);
              controller.clear();
              focus.unfocus();
            },
            width: AppSize.defaultContentsWidth,
            onChangeCallBack: (str) => sp.setLoginAccount(str),
            enable: true,
          );
        });
      },
    );
  }

  Widget _siteCodeInput(BuildContext context) {
    final sp = context.read<SigninPageProvider>();
    return Selector<SigninPageProvider, String?>(
      selector: (context, provider) => provider.siteCodeInputStr,
      builder: (context, siteCode, _) {
        return BaseTextControllerFactoryWidget(
            textEditHookWidget: (controller, focus) {
          if (siteCode == null) {
            controller.clear();
          }
          return BaseInputWidget(
            context: context,
            textEditingController: controller,
            keybordType: TextInputType.number,
            focusNode: focus,
            hintText: siteCode == null || siteCode.isEmpty
                ? tr('plz_enter_site_code')
                : siteCode,
            hintTextStyleCallBack: () => siteCode == null
                ? AppTextStyle.hint_16
                : AppTextStyle.default_16,
            iconType: siteCode != null && siteCode.isNotEmpty
                ? InputIconType.DELETE
                : null,
            defaultIconCallback: () {
              sp.setSiteCode(null);
              controller.clear();
              focus.unfocus();
            },
            width: AppSize.defaultContentsWidth,
            onChangeCallBack: (str) => sp.setSiteCode(str),
            enable: true,
          );
        });
      },
    );
  }

  Widget _buildSigninButton(BuildContext context) {
    return Selector<SigninPageProvider, bool>(
      selector: (context, provider) => provider.isValidate,
      builder: (context, isValidate, _) {
        return Align(
          alignment: Alignment.center,
          child: AppStyles.buildButton(
              context,
              tr('ok'),
              AppSize.realWidth * .4,
              isValidate ? AppColors.primary : AppColors.secondGreyColor,
              AppTextStyle.color_16(
                  isValidate ? AppColors.whiteText : AppColors.unReadyText),
              AppSize.radius15, () async {
            final p = context.read<SigninPageProvider>();
            final sp = context.read<SigninPageProvider>();
            final dp = context.read<DeviceStatusProvider>();
            final ap = context.read<AuthProvider>();
            final tp = context.read<TimerProvider>();
            if (!p.isEmail) {
              AppDialog.showDangermessage(context, tr('plz_check_email'));
              return;
            }
            var _loginProccess = () async {
              final result = await sp.signIn();
              if (!result.isSuccessful) {
                CacheService.deleteALL();
                if (result.errorMassage == 'accessKeyExpired') {
                  final result = await AppDialog.showDangermessage(
                      context, tr('access_key_expired'));
                  if (result != null && result) {
                    final ap = context.read<AuthProvider>();
                    ap.setIsLogedIn(false);
                    CacheService.deleteALL();
                  }
                } else {
                  await AppDialog.showDangermessage(
                      context,
                      result.errorMassage != null &&
                              result.errorMassage!.isNotEmpty
                          ? result.errorMassage!
                          : tr('plase_check_login_info'),
                      isPopToFirst: true);
                }
              } else {
                ap.setIsLogedIn(true);
                AppToast().show(context, tr('logoin_successful'));
              }
            };
            var permissonProccess = () async {
              await PermissionService.requestLocationAndBle()
                  .then((_) => PermissionService.checkLocationAndBle());
              if (dp.isBleOk && dp.isLocationOk) {
                _loginProccess();
              } else {
                if (!dp.isLocationOk) {
                  var result = await AppDialog.showDangermessage(
                      context, '${tr('not_use_location_permission_text')}');
                  if (result) {
                    AppSettings.openLocationSettings();
                  }
                }
                if (!dp.isBleOk) {
                  var result = await AppDialog.showDangermessage(
                      context, '${tr('not_use_ble_permission_text')}');
                  if (result) {
                    AppSettings.openBluetoothSettings();
                  }
                }
              }
            };

            if (sp.isValidate && (!tp.isRunning)) {
              tp.perdict(permissonProccess.call());
            }
          }, selfHeight: AppSize.defaultTextFieldHeight),
        );
      },
    );
  }

  Widget _buildRadioButtonRow(BuildContext context) {
    final sp = context.read<SigninPageProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(
            sp.radioList.length,
            (index) => SizedBox(
                width: AppSize.defaultContentsWidth / 2,
                child: Selector<SigninPageProvider, SigninType>(
                  selector: (context, provider) => provider.signinType,
                  builder: (context, signinType, _) {
                    return Row(
                      children: [
                        Radio(
                          activeColor: AppColors.primary,
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: sp.radioList[index].title,
                          groupValue: signinType.title,
                          onChanged: (text) {
                            sp.resetInputStr();
                            hideKeyboard(context);
                            sp.setSigninType(sp.radioList[index]);
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            sp.resetInputStr();
                            hideKeyboard(context);
                            sp.setSigninType(sp.radioList[index]);
                          },
                          child: AppText.text(sp.radioList[index].title),
                        )
                      ],
                    );
                  },
                )))
      ],
    );
  }

  Widget _buildImage() {
    return Image.asset(
      ImageType.HWST.path,
      height: AppSize.defaultTextFieldHeight,
    );
  }

  Widget _buildContents(BuildContext context) {
    return BaseLayout(
        isResizeToAvoidBottomInset: true,
        hasForm: true,
        appBar: appBarContents(context,
            isHome: true, isUseActionIcon: false, text: tr('add_mobile_card')),
        child: Container(
          alignment: Alignment.topCenter,
          padding: AppSize.defaultSidePadding,
          color: AppColors.whiteText,
          height: AppSize.realHeight,
          width: AppSize.realWidth,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildImage(),
              defaultSpacing(multiple: 4),
              AppText.text(tr('register_activation_key'),
                  style: AppTextStyle.bold_20
                      .copyWith(color: Color.fromARGB(255, 22, 195, 186))),
              defaultSpacing(multiple: 4),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: AppSize.realWidth * .6,
                  child: AppText.text(tr('access_key_discription'),
                      maxLines: 5,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.bold_16),
                ),
              ),
              defaultSpacing(multiple: 4),
              _buildRadioButtonRow(context),
              defaultSpacing(height: AppSize.defaultTextFieldHeight / 2),
              _emailOrPhoneInput(context),
              defaultSpacing(),
              _buildAssessKeyInput(context),
              defaultSpacing(),
              _siteCodeInput(context),
              defaultSpacing(height: AppSize.defaultTextFieldHeight),
              _buildSigninButton(context),
              defaultSpacing(height: AppSize.appBarHeight * 2)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SigninPageProvider(),
      builder: (context, _) {
        return Selector<AuthProvider, bool?>(
          selector: (context, provider) => provider.isTermsAgree,
          builder: (context, isTermsAgree, _) {
            return CacheService.getIsAgrred() ?? false
                ? HomePage()
                : isTermsAgree != null && isTermsAgree
                    ? _buildContents(context)
                    : TermsPage();
          },
        );
      },
    );
  }
}
