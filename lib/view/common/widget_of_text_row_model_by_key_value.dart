// ignore_for_file: deprecated_member_use

/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/text_row_model_by_key_value.dart
 * Created Date: 2021-09-06 11:46:11
 * Last Modified: 2023-02-22 22:42:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hwst/util/regular.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/styles/app_text.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/view/common/base_shimmer.dart';
import 'package:hwst/globalProvider/app_theme_provider.dart';

class TextRowModelByKeyValue extends StatelessWidget {
  const TextRowModelByKeyValue(this.title, this.discription,
      this.isWithShowAllButton, this.isWithEndShowAllButton,
      {Key? key,
      this.callback,
      this.showAllButtonText,
      this.icon,
      this.isLeftIcon,
      this.exceptionColor,
      this.isWithShimmer,
      this.shimmerRow,
      this.isWithStar,
      this.isTitleTwoRow,
      this.discription2,
      this.maxLine,
      this.showAllButtonWidth,
      this.contentsTextWidth,
      this.leadingTextWidth,
      this.style})
      : super(key: key);

  final String title;
  final String discription;
  final String? discription2;
  final bool isWithShowAllButton;
  final double? showAllButtonWidth;
  final bool isWithEndShowAllButton;
  final Function? callback;
  final int? maxLine;
  final String? showAllButtonText;
  final Widget? icon;
  final bool? isLeftIcon;
  final Color? exceptionColor;
  final bool? isWithShimmer;
  final bool? isWithStar;
  final int? shimmerRow;
  final bool? isTitleTwoRow;
  final double? leadingTextWidth;
  final double? contentsTextWidth;
  final TextStyle? style;

  Widget buildShowAllButton() {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.textRowModelShowAllIconTopPadding),
      child: Container(
        width: isWithShowAllButton
            ? showAllButtonWidth != null
                ? showAllButtonWidth
                : contentsTextWidth != null
                    ? contentsTextWidth! * .25
                    : (AppSize.realWidth - AppSize.padding * 2) * .3
            : isWithStar != null
                ? (AppSize.realWidth - AppSize.padding * 2) * .35
                : (AppSize.realWidth - AppSize.padding * 2) * .3,
        child: InkWell(
          onTap: () => callback != null ? callback!.call() : DoNothingAction(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText.text('${showAllButtonText ?? ''}',
                  style: AppTextStyle.color14(AppColors.showAllTextColor),
                  maxLines: isWithShowAllButton ? 2 : null,
                  overflow: TextOverflow.ellipsis),
              Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: SizedBox(
                      height: AppSize.iconSmallDefaultWidth,
                      child: icon ??
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.showAllTextColor,
                            size: AppSize.iconSmallDefaultWidth,
                          )))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEndShowAllButton() {
    return InkWell(
        onTap: () => callback != null ? callback!.call() : DoNothingAction(),
        child: Container(
          width: isLeftIcon != null && isLeftIcon!
              ? (AppSize.realWidth - AppSize.padding * 2) * .7
              : contentsTextWidth != null
                  ? contentsTextWidth! * .25
                  : (AppSize.realWidth - AppSize.padding * 2) * .25,
          child: Row(
            mainAxisAlignment: isLeftIcon != null && isLeftIcon!
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText.text('${showAllButtonText ?? ''}',
                  style: AppTextStyle.color14(AppColors.blueTextColor)),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: icon!,
              )
            ],
          ),
        ));
  }

  Widget buildRowLeadingText(BuildContext context) {
    final p = context.read<AppThemeProvider>();
    return Container(
        width: leadingTextWidth != null
            ? leadingTextWidth
            : isWithStar != null
                ? (AppSize.realWidth - AppSize.padding * 2) * .35
                : (AppSize.realWidth - AppSize.padding * 2) * .3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: AppText.text('$title',
                    style: style ?? p.themeData.textTheme.headline6!,
                    maxLines: isTitleTwoRow != null ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start),
              ),
            ),
            isWithStar != null
                ? AppText.text(' *',
                    style: AppTextStyle.color14(AppColors.dangerColor))
                : Container()
          ],
        ));
  }

  Widget buildRowContents(BuildContext context) {
    final p = context.read<AppThemeProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: isLeftIcon != null && isLeftIcon!
                ? 0
                : isWithEndShowAllButton
                    ? contentsTextWidth != null
                        ? contentsTextWidth! * .75
                        : (AppSize.realWidth - AppSize.padding * 2) * .45
                    : contentsTextWidth != null
                        ? contentsTextWidth
                        : isWithStar != null
                            ? (AppSize.realWidth - AppSize.padding * 2) * .65
                            : (AppSize.realWidth - AppSize.padding * 2) * .7,
            child: InkWell(
                onTap: () {
                  if (exceptionColor != null) {
                    launch(
                        "tel://${discription.replaceAll(RegExpUtil.matchNumber, '')}");
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    discription2 != null
                        ? AppText.text('$discription2  ',
                            style: p.themeData.textTheme.headline4!)
                        : Container(),
                    Expanded(
                        child: Container(
                            child: AppText.text('$discription',
                                style: style != null
                                    ? style!
                                        .copyWith(color: AppColors.defaultText)
                                    : exceptionColor != null
                                        ? p.themeData.textTheme.headline4!
                                            .copyWith(color: exceptionColor)
                                        : p.themeData.textTheme.headline4!,
                                maxLines: maxLine != null
                                    ? maxLine
                                    : isWithEndShowAllButton
                                        ? 1
                                        : 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start)))
                  ],
                ))),
        isWithEndShowAllButton ? buildEndShowAllButton() : Container()
      ],
    );
  }

  Widget shimmerBox(bool isRowLeadingText) {
    return Container(
      height: AppTextStyle.default_14.fontSize,
      width: isRowLeadingText
          ? (AppSize.defaultContentsWidth - AppSize.defaultShimmorSpacing) * .3
          : (AppSize.defaultContentsWidth - AppSize.defaultShimmorSpacing) * .7,
      color: AppColors.whiteText,
    );
  }

  Widget buildShimmerContainer() {
    return BaseShimmer(
        child: shimmerRow != null && shimmerRow! > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(true),
                  Padding(
                      padding: EdgeInsets.only(
                          right: AppSize.defaultShimmorSpacing)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerBox(false),
                      Padding(
                          padding: EdgeInsets.only(
                              top: AppSize.defaultShimmorSpacing)),
                      shimmerBox(true)
                    ],
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(true),
                  Padding(
                      padding: EdgeInsets.only(
                          right: AppSize.defaultShimmorSpacing)),
                  shimmerBox(false)
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    return isWithShimmer != null && isWithShimmer!
        ? buildShimmerContainer()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRowLeadingText(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRowContents(context),
                  isWithShowAllButton
                      ? buildShowAllButton()
                      : Container(
                          height: AppSize.zero,
                        )
                ],
              )
            ],
          );
  }
}
