/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/app_bar.dart
 * Created Date: 2021-08-29 19:57:10
 * Last Modified: 2023-03-02 19:15:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:hwst/view/common/widget_of_dialog_contents.dart';

typedef IsEditPageCallBack = Function();

class MainAppBar extends AppBar {
  final Widget? titleText;
  final Widget? action;
  final Function? callback;
  final Widget? icon;
  final bool? isDisableUpdate;
  final Function? actionCallback;
  final IsEditPageCallBack? cachePageTypeCallBack;
  MainAppBar(
    BuildContext context, {
    this.titleText,
    this.action,
    this.callback,
    this.icon,
    this.isDisableUpdate,
    this.actionCallback,
    this.cachePageTypeCallBack,
  }) : super(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: AppColors.whiteText,
            iconTheme: IconThemeData(
                color: titleText == null
                    ? AppColors.whiteText
                    : AppColors.appBarIconColor),
            toolbarHeight: AppSize.appBarHeight,
            centerTitle: true,
            leading: IconButton(
                onPressed: () async {
                  if (cachePageTypeCallBack != null &&
                      cachePageTypeCallBack.call()) {
                    final result = await AppDialog.showPopup(
                        context,
                        WillPopScope(
                            child: buildTowButtonTextContents(
                              context,
                              '${tr('is_exit_current_page')}',
                            ),
                            onWillPop: () async => false));
                    result as bool;
                    if (result) {
                      Navigator.pop(context, isDisableUpdate ?? true);
                    }
                  } else {
                    if (callback != null) {
                      callback.call();
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: icon ?? Icon(Icons.arrow_back_ios_new)),
            title: titleText,
            elevation: 0,
            titleSpacing: 0,
            actions: action != null
                ? [
                    GestureDetector(
                      onTap: () => actionCallback!.call(),
                      child: action,
                    )
                  ]
                : null);
}
