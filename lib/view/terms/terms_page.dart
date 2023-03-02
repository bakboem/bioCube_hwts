/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/signin/terms_page.dart
 * Created Date: 2023-01-27 22:48:10
 * Last Modified: 2023-03-02 19:00:03
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/view/terms/terms_of_user_page.dart';
import 'package:hwst/view/common/base_check_box_widget.dart';
import 'package:hwst/view/terms/terms_of_privacy_policy.dart';
import 'package:hwst/view/common/widget_of_top_align_logo.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/terms/provider/terms_page_provider.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  Widget _buildTermsItemRow(BuildContext context, int index) {
    return Selector<TermsPageProvider, bool>(
      selector: (context, provider) => provider.checkedList[index],
      builder: (context, isChecked, _) {
        return Padding(
            padding:
                EdgeInsets.only(bottom: AppSize.defaultListItemSpacing * 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: AppSize.defaultCheckBoxHeight,
                  width: AppSize.defaultCheckBoxHeight,
                  child: BaseCheckbox(
                      side: BorderSide(color: AppColors.unReadyText),
                      checkColor: AppColors.whiteText,
                      activeColor: AppColors.primary,
                      value: isChecked,
                      onChanged: (_) {
                        final cp = context.read<TermsPageProvider>();
                        cp.setCheckList(index);
                      }),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
                GestureDetector(
                    onTap: () {
                      final cp = context.read<TermsPageProvider>();
                      cp.setCheckList(index);
                    },
                    child: SizedBox(
                        width: AppSize.realWidth * .5,
                        child: AppText.text(
                            tr(index == 0
                                ? 'confirem_end_user_license_agreement'
                                : 'i_agree_to_the_user_privacy_policy'),
                            maxLines: 10,
                            textAlign: TextAlign.left))),
                Spacer(),
                SizedBox(
                  width: AppSize.realWidth * .2,
                  height: AppSize.smallButtonHeight,
                  child: AppStyles.buildButton(
                    context,
                    tr('look'),
                    AppSize.realWidth * .2,
                    AppColors.primary,
                    AppTextStyle.default_12,
                    AppSize.radius8,
                    () {
                      Navigator.pushNamed(
                          context,
                          index == 0
                              ? TermsOfUserPage.routeName
                              : TermsOfPrivacyPolicy.routeName);
                    },
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget _buildTermsContents(BuildContext context) {
    final tp = context.read<TermsPageProvider>();
    return Padding(
      padding: AppSize.defaultSidePadding,
      child: Column(
        children: [
          ...List.generate(tp.checkedList.length,
              (index) => _buildTermsItemRow(context, index))
        ],
      ),
    );
  }

  Widget _buildSubmmiButton(BuildContext context) {
    return Selector<TermsPageProvider, bool>(
      selector: (context, provider) => provider.isValidate,
      builder: (context, isValidate, _) {
        return Align(
          alignment: Alignment.center,
          child: AppStyles.buildButton(
              context,
              tr('ok'),
              AppSize.realWidth * .4,
              isValidate ? AppColors.primary : AppColors.secondGreyColor,
              AppTextStyle.default_16.copyWith(
                  color:
                      isValidate ? AppColors.whiteText : AppColors.unReadyText),
              AppSize.radius15, () {
            final tp = context.read<TermsPageProvider>();
            if (tp.isValidate) {
              final ap = context.read<AuthProvider>();
              ap.setIsTermsAgree(true);
            } else {
              AppDialog.showDangermessage(
                  context, tr('if_not_agree_can_not_use_in'));
            }
          }, selfHeight: AppSize.defaultTextFieldHeight),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        isWithWillPopScope: true,
        willpopCallback: () => true,
        hasForm: false,
        // appBar: appBarContents(),
        appBar: null,
        child: ChangeNotifierProvider(
          create: (context) => TermsPageProvider(),
          builder: (context, _) {
            return Container(
              padding: AppSize.defaultSidePadding,
              color: AppColors.whiteText,
              height: AppSize.realHeight,
              width: AppSize.realWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  defaultSpacing(height: AppSize.appBarHeight),
                  WidgetOfTopAlignLogo(
                    subTitle: tr('continue_when_done'),
                  ),
                  _buildTermsContents(context),
                  defaultSpacing(multiple: 5),
                  _buildSubmmiButton(context),
                ],
              ),
            );
          },
        ));
  }
}
