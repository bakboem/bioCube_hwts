/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/base_widget.dart
 * Created Date: 2021-08-19 11:37:50
 * Last Modified: 2023-02-22 22:42:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/function_of_hidden_key_borad.dart';

typedef IsShowAppBarCallBack = bool Function();
typedef OnwillpopCallback = bool Function();

class BaseLayout extends StatelessWidget {
  BaseLayout(
      {required this.hasForm,
      required this.appBar,
      this.isWithWillPopScope,
      this.isWithBottomSafeArea,
      this.isWithRightSafeArea,
      this.isWithLeftSafeArea,
      this.isWithTopSafeArea,
      this.isResizeToAvoidBottomInset,
      this.isShowAppBarCallBack,
      this.bgColog,
      required this.child,
      this.willpopCallback,
      Key? key})
      : super(key: key);
  final Widget child;
  final IsShowAppBarCallBack? isShowAppBarCallBack;
  final bool hasForm;
  final AppBar? appBar;
  final bool? isWithBottomSafeArea;
  final bool? isWithRightSafeArea;
  final bool? isWithLeftSafeArea;
  final bool? isWithTopSafeArea;

  final bool? isResizeToAvoidBottomInset;
  final Color? bgColog;
  final OnwillpopCallback? willpopCallback;
  final bool? isWithWillPopScope;

  Widget contents(BuildContext context) {
    return SafeArea(
        bottom: Platform.isIOS
            ? isWithBottomSafeArea ?? false
            : isWithBottomSafeArea ?? true,
        right: isWithRightSafeArea ?? false,
        left: isWithLeftSafeArea ?? false,
        child: GestureDetector(
            onTap: () {
              hasForm
                  ? () {
                      hideKeyboard(context);
                    }()
                  : DoNothingAction();
            },
            child: child));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: isResizeToAvoidBottomInset ?? true,
      backgroundColor: bgColog ?? AppColors.whiteText,
      appBar: isShowAppBarCallBack != null
          ? isShowAppBarCallBack!.call()
              ? appBar
              : null
          : appBar,
      body: isWithWillPopScope != null
          ? WillPopScope(
              child: contents(context),
              onWillPop: () async {
                return willpopCallback != null
                    ? willpopCallback!.call()
                    : false;
              })
          : contents(context),
    );
  }
}
