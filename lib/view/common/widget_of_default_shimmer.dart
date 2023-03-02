/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/default_shimmer.dart
 * Created Date: 2021-10-13 10:00:13
 * Last Modified: 2023-03-02 19:15:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:math';
import 'base_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/styles/app_style.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';

class DefaultShimmer {
  static buildDefaultResultShimmer({bool? isNotPadding}) {
    return BaseShimmer(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: AppSize.defaultSidePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: AppSize.padding)),
                BaseShimmer.shimmerBox(AppTextStyle.default_16.fontSize!,
                    AppSize.defaultContentsWidth * .5),
                Padding(
                    padding:
                        EdgeInsets.only(top: AppSize.defaultShimmorSpacing)),
                Row(
                  children: [
                    BaseShimmer.shimmerBox(AppTextStyle.sub_14.fontSize!,
                        AppSize.defaultContentsWidth * .2),
                    AppStyles.buildPipe(),
                    BaseShimmer.shimmerBox(
                        AppTextStyle.sub_14.fontSize!,
                        isNotPadding != null
                            ? AppSize.defaultContentsWidth * .6
                            : AppSize.defaultContentsWidth * .7),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: AppSize.padding)),
                Divider(color: AppColors.textGrey)
              ],
            ),
          );
        },
      ),
    );
  }

  static buildCalindaShimmer({bool? isNotPadding}) {
    return BaseShimmer(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  index == 0
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                  index == 0
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                  BaseShimmer.shimmerBox(30, 30),
                  BaseShimmer.shimmerBox(30, 30),
                  BaseShimmer.shimmerBox(30, 30),
                  index == 5
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                  index == 5
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                ],
              ),
              defaultSpacing(height: 40)
            ],
          );
        },
      ),
    );
  }

  static buildDefaultPopupShimmer({int? length}) {
    var width = AppSize.defaultContentsWidth;
    var contentsWidth = width - AppSize.padding * 2;
    return BaseShimmer(
        child: Container(
      alignment: Alignment.topLeft,
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing * 2),
        itemCount: length ?? 12,
        itemExtent: AppSize.defaultTextFieldHeight,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.topLeft,
            child: BaseShimmer.shimmerBox(
                AppTextStyle.default_16.fontSize!,
                Random().nextDouble() < 0.3
                    ? contentsWidth * .3
                    : contentsWidth * .5),
          );
        },
      ),
    ));
  }
}
