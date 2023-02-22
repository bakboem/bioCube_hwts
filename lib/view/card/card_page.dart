/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/card/card_page.dart
 * Created Date: 2023-01-27 11:53:20
 * Last Modified: 2023-02-22 23:23:28
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/base_input_widget.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/common/widget_of_divider_line.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});
  static final String routeName = '/cardPage';

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  Widget _buildLogoImage() {
    return Image.asset(
      ImageType.HWST.path,
      height: AppSize.defaultTextFieldHeight,
    );
  }

  Widget _buidDiscription() {
    return AppText.text(tr('mobile_card_info'), style: AppTextStyle.sub_16);
  }

  Widget _buildUserImage(BuildContext context) {
    final userCard = CacheService.getUserCard();
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding:
            userCard!.mPhoto!.isEmpty ? EdgeInsets.all(AppSize.padding) : null,
        width: AppSize.realWidth * .35,
        height: AppSize.realWidth * .35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.radius25),
            image: userCard.mPhoto!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(userCard.mPhoto!), fit: BoxFit.cover)
                : null),
        child: userCard.mPhoto!.isNotEmpty
            ? SizedBox()
            : Image.asset(
                ImageType.PEOPLE.path,
                fit: BoxFit.contain,
              ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String val) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.defaultListItemSpacing),
      child: Row(
        children: [
          Expanded(child: AppText.text(title, textAlign: TextAlign.center)),
          BaseInputWidget(
              context: context,
              width: AppSize.defaultContentsWidth * .65,
              hintText: val,
              hintTextStyleCallBack: () => AppTextStyle.default_16,
              enable: false)
        ],
      ),
    );
  }

  List<Widget> _buildUserInfoList(BuildContext context) {
    final userCard = CacheService.getUserCard()!;

    return [
      _buildInfoRow(tr('name'), userCard.mName ?? ''),
      _buildInfoRow(tr('company'), userCard.mCoName ?? ''),
      _buildInfoRow(tr('department'), userCard.mDpName ?? ''),
      _buildInfoRow(tr('phone_number'), userCard.mPhone ?? ''),
      _buildInfoRow(tr('email'), userCard.mMail ?? ''),
      _buildInfoRow(tr('start_use_date'), userCard.mCardKeySdate ?? ''),
      _buildInfoRow(tr('effective_date'), userCard.mCardKeyEdate ?? ''),
      _buildInfoRow(tr('mobile_card_number'), userCard.mCardKey ?? ''),
      _buildInfoRow(
          tr('status'),
          DateTime.parse(userCard.mCardKeyEdate!).isBefore(DateTime.now())
              ? tr('faild')
              : tr('normal')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: false,
        appBar: appBarContents(
          context,
          isUseActionIcon: true,
          text: tr('mobile_card_info'),
        ),
        child: Stack(
          children: [
            ListView(
              padding: AppSize.defaultSidePadding,
              shrinkWrap: true,
              children: [
                defaultSpacing(multiple: 3),
                _buildLogoImage(),
                defaultSpacing(),
                _buidDiscription(),
                defaultSpacing(multiple: 3),
                _buildUserImage(context),
                defaultSpacing(multiple: 3),
                ..._buildUserInfoList(context),
                defaultSpacing(height: AppSize.appBarHeight)
              ],
            ),
            const DefaultTitleDevider(),
          ],
        ));
  }
}
