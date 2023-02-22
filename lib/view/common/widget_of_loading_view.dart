/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/base_loading_view_on_stack_widget.dart
 * Created Date: 2021-10-20 22:21:27
 * Last Modified: 2023-02-22 22:42:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/styles/export_common.dart';

class BaseLoadingViewOnStackWidget {
  static build(BuildContext context, bool isLoadData,
      {double? height, double? width, Color? color, Widget? icon}) {
    return isLoadData
        ? Container(
            height: height ?? AppSize.realHeight,
            width: width ?? AppSize.realWidth,
            color: color ?? AppColors.defaultText.withOpacity(.4),
            child: Column(
              mainAxisAlignment: height != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                height != null
                    ? Padding(padding: EdgeInsets.only(top: height * .3))
                    : Container(),
                SizedBox(
                  height: AppSize.defaultIconWidth * 1.5,
                  width: AppSize.defaultIconWidth * 1.5,
                  child: icon ??
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                )
              ],
            ))
        : Container();
  }
}
