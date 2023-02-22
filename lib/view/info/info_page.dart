/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/info/info_page.dart
 * Created Date: 2023-02-02 14:44:43
 * Last Modified: 2023-02-22 23:23:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hwst/buildConfig/biocube_build_config.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/model/user/user_device_info.dart';
import 'package:hwst/service/deviceInfo_service.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/common/widget_of_divider_line.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  static final String routeName = '/InfoPage';
  Widget _buildLogoImage() {
    return Image.asset(
      ImageType.HWST.path,
      height: AppSize.defaultTextFieldHeight,
    );
  }

  Widget _buildCompanyImage() {
    return Transform.scale(
      scale: .5,
      child: AppImage.getImage(ImageType.COMPANY, color: AppColors.primary),
    );
  }

  Widget _buildCompanyDescription() {
    return AppText.text(tr('info'),
        style: AppTextStyle.bold_16.copyWith(color: AppColors.subText));
  }

  Widget _buildAppinfoRow(String title, String val) {
    return Padding(
      padding: AppSize.defaultSidePadding,
      child: Row(
        children: [
          Expanded(
              child: AppText.text(title,
                  style: AppTextStyle.bold_16, textAlign: TextAlign.right)),
          Padding(padding: EdgeInsets.only(right: AppSize.padding * 2)),
          SizedBox(
            width: AppSize.defaultContentsWidth * .45,
            child: AppText.text(val,
                textAlign: TextAlign.left, style: AppTextStyle.bold_16),
          )
        ],
      ),
    );
  }

  List<Widget> _buildAppinfoList(
      BuildContext context, AsyncSnapshot<UserDeviceInfo> snapshot) {
    var hasData =
        snapshot.hasData && snapshot.connectionState == ConnectionState.done;
    return [
      _buildAppinfoRow(tr('app_name'), BioCubeBuildConfig.APP_NAME),
      _buildAppinfoRow(tr('app_version'), BioCubeBuildConfig.APP_VERSION_NAME),
      _buildAppinfoRow(
          tr('platform'),
          hasData
              ? '${Platform.isIOS ? '${snapshot.data!.deviceVersion}' : ''}'
              : ''),
      _buildAppinfoRow(
          tr('device_model'), hasData ? snapshot.data!.deviceModel : ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: false,
        appBar:
            appBarContents(context, isUseActionIcon: true, text: tr('info')),
        child: FutureBuilder<UserDeviceInfo>(
            future: DeviceInfoService.getDeviceInfo(),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  ListView(
                    padding: AppSize.defaultSidePadding,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      defaultSpacing(multiple: 3),
                      _buildLogoImage(),
                      defaultSpacing(height: AppSize.appBarHeight / 2),
                      _buildCompanyImage(),
                      _buildCompanyDescription(),
                      defaultSpacing(multiple: 3),
                      ..._buildAppinfoList(context, snapshot)
                    ],
                  ),
                  const DefaultTitleDevider(),
                ],
              );
            }));
  }
}
