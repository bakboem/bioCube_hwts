/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/HWST/lib/view/common/widget_of_download_progress.dart
 * Created Date: 2023-03-15 01:40:21
 * Last Modified: 2023-03-15 02:46:58
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/model/user/get_user_all_response_model.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';

Widget updateContents(BuildContext context) {
  return Selector<FaceDetectionProvider, int?>(
      selector: (context, provider) => provider.totalCount,
      builder: (context, count, _) {
        return count != null
            ? downLoadProgressContents(context, count)
            : SizedBox();
      });
}

Widget downLoadProgressContents(BuildContext context, int totalCount) =>
    Container(
      child: Selector<FaceDetectionProvider,
          Tuple4<String?, String?, String?, GetUserAllResponseModel?>>(
        selector: (context, provider) => Tuple4(provider.downloadTime,
            provider.saveTime, provider.getDbDataTime, provider.responseModel),
        builder: (context, tuple, _) {
          return Container(
            height: AppSize.appBarHeight * 3,
            width: AppSize.defaultContentsWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.radius8),
                color: AppColors.whiteText),
            child: Padding(
              padding: AppSize.defaultSidePadding,
              child: tuple.item4 != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.text(
                            'DownloadTime: ${tuple.item1 ?? ''} milliseconds',
                            style: AppTextStyle.default_14),
                        defaultSpacing(),
                        AppText.text(
                            'SaveDataTime: ${tuple.item2 ?? ''} milliseconds',
                            style: AppTextStyle.default_14),
                        defaultSpacing(),
                        AppText.text(
                            'TotalTime: ${int.parse(tuple.item1 ?? '0') + int.parse(tuple.item2 ?? '0')} milliseconds',
                            style: AppTextStyle.default_14),
                        defaultSpacing(),
                        AppText.text(
                            '${(tuple.item4!.data!.length ~/ totalCount) * 100}%',
                            style: AppTextStyle.default_14),
                        defaultSpacing(),
                        Selector<FaceDetectionProvider, String?>(
                          selector: (context, provider) => provider.dataLength,
                          builder: (context, val, _) {
                            return LinearProgressIndicator(
                              backgroundColor: AppColors.textGrey,
                              valueColor:
                                  AlwaysStoppedAnimation(AppColors.primary),
                              value:
                                  (int.parse(val ?? '0') ~/ totalCount) * 100,
                            );
                          },
                        )
                      ],
                    )
                  : SizedBox(),
            ),
          );
        },
      ),
    );
