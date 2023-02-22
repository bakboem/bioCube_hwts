/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/widget_of_appbar_contents.dart
 * Created Date: 2023-01-28 08:10:40
 * Last Modified: 2023-02-22 23:23:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/styles/export_common.dart';

AppBar appBarContents(BuildContext context,
    {String? text,
    bool? isHome,
    double? elevation,
    Color? backgroundColor,
    Function? backKeyCallback,
    required bool isUseActionIcon}) {
  // return AppBar(
  //     iconTheme: IconThemeData(color: AppColors.appBarIconColor),
  //     leading: IconButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         icon: Icon(Icons.arrow_back_ios_new)),
  //     shadowColor: AppColors.whiteText,
  //     shape: null,
  //     elevation: 0,
  //     toolbarHeight: 100,
  //     backgroundColor: AppColors.whiteText,
  //     title: Column(
  //       children: [
  //         Image.asset(
  //           ImageType.HWST.path,
  //           height: AppSize.appBarHeight / 2,
  //         ),
  //         defaultSpacing()
  //       ],
  //     ));
  return AppBar(
    iconTheme: IconThemeData(color: AppColors.appBarIconColor),
    centerTitle: true,
    leading: isHome != null && isHome
        ? null
        : IconButton(
            onPressed: () {
              backKeyCallback?.call();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
    shadowColor: elevation == null ? AppColors.textGrey : AppColors.textGrey,
    shape: null,
    elevation: elevation ?? 0,
    toolbarHeight: AppSize.appBarHeight,
    backgroundColor: backgroundColor ?? AppColors.whiteText,
    title: AppText.text(
      text ?? '',
      style: AppTextStyle.bold_22,
    ),
    actions: [
      isUseActionIcon
          ? Padding(
              padding: EdgeInsets.only(right: AppSize.padding),
              child: SizedBox(
                width: AppSize.realWidth * .15,
                child: Image.asset(
                  ImageType.HWST.path,
                  height: AppSize.appBarHeight / 5,
                ),
              ))
          : SizedBox()
    ],
  );
}
