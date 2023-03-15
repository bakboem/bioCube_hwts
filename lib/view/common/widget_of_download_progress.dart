/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/view/common/widget_of_download_progress.dart
 * Created Date: 2023-03-15 01:40:21
 * Last Modified: 2023-03-15 22:50:38
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';

Widget updateContents(BuildContext context) {
  return Consumer<FaceDetectionProvider>(builder: (context, provider, _) {
    return Container(
      height: AppSize.appBarHeight * 3,
      width: AppSize.defaultContentsWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.radius8),
          color: AppColors.whiteText),
      child: Padding(
        padding: AppSize.defaultSidePadding,
        child: provider.responseModel != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText.text(
                      'DownloadTime: ${provider.downloadTime.inMilliseconds} milliseconds',
                      style: AppTextStyle.default_14),
                  defaultSpacing(),
                  AppText.text(
                      'SaveDataTime: ${provider.saveTime.inMilliseconds} milliseconds',
                      style: AppTextStyle.default_14),
                  defaultSpacing(),
                  AppText.text(
                      'TotalTime: ${provider.totalTime.inMilliseconds} milliseconds',
                      style: AppTextStyle.default_14),
                  defaultSpacing(),
                  AppText.text(
                      'TotalComplete: ${provider.responseModel?.data?.length}/${provider.totalCount}',
                      style: AppTextStyle.default_14),
                  // AppText.text(
                  //     '${(provider.responseModel!.data!.length ~/ (provider.totalCount ?? 0)) * 100}%',
                  //     style: AppTextStyle.default_14),
                  defaultSpacing(),
                  LinearProgressIndicator(
                    backgroundColor: AppColors.textGrey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    value: (provider.responseModel!.data!.length ~/
                            (provider.totalCount ?? 0)) *
                        100,
                  ),
                ],
              )
            : SizedBox(),
      ),
    );
  });
}
