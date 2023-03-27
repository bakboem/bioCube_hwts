import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';

Widget textRow(String start, String end, isUseTime) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppText.text('$start:', style: AppTextStyle.default_14),
      AppText.text('$end ${isUseTime ? 'milliseconds' : ''}',
          style: AppTextStyle.default_14),
    ],
  );
}

Widget updateContents(BuildContext context) {
  return Consumer<FaceDetectionProvider>(builder: (context, provider, _) {
    return Container(
      width: AppSize.defaultContentsWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.radius8),
          color: AppColors.whiteText),
      child: Padding(
        padding: AppSize.defaultSidePadding,
        child: provider.responseModel != null &&
                provider.responseModel!.data!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  defaultSpacing(multiple: 2),
                  textRow(tr('downloadTime'),
                      '${provider.downloadTime.inMilliseconds}', true),
                  defaultSpacing(),
                  textRow(tr('saveDataTime'),
                      '${provider.saveTime.inMilliseconds}', true),
                  defaultSpacing(),
                  textRow(tr('totalTime'),
                      '${provider.totalTime.inMilliseconds}', true),
                  defaultSpacing(multiple: 2),
                  textRow(
                      tr('totalComplete'),
                      '${provider.responseModel?.data?.length}/${provider.totalCount}',
                      false),
                  defaultSpacing(),
                  LinearProgressIndicator(
                    backgroundColor: AppColors.textGrey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    value: provider.responseModel!.data!.length /
                        (provider.totalCount ?? 0),
                  ),
                  defaultSpacing(multiple: 2),
                  textRow(
                      tr('extractFeatureComplete'),
                      '${provider.extractFeatrueComplateCount}/${provider.extractFeatrueCount ?? 0}',
                      false),
                  defaultSpacing(),
                  LinearProgressIndicator(
                    key: Key('extracte'),
                    backgroundColor: AppColors.textGrey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    value: provider.extractFeatrueComplateCount == 0 ||
                            provider.extractFeatrueCount == null
                        ? 1
                        : provider.extractFeatrueComplateCount /
                            (provider.extractFeatrueCount!),
                  ),
                  defaultSpacing(multiple: 2),
                  AppText.text(
                      provider.isExtractFeatureDone ?? false ? tr('done') : '',
                      style: AppTextStyle.default_14,
                      textAlign: TextAlign.center),
                ],
              )
            : SizedBox(),
      ),
    );
  });
}
