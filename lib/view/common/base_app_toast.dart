/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/app_toast.dart
 * Created Date: 2021-10-01 14:02:55
 * Last Modified: 2023-02-26 11:51:01
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/globalProvider/timer_provider.dart';

class AppToast {
  final FToast? fToast;
  factory AppToast() => _sharedInstance();
  static AppToast? _instance;
  AppToast._(this.fToast);
  static AppToast _sharedInstance() {
    _instance ??= AppToast._(FToast());
    return _instance!;
  }

  show(BuildContext context, String str, {bool? show}) {
    fToast!.init(context);
    Widget toast = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: AppSize.padding),
        width: AppSize.defaultContentsWidth,
        height:
            str.length > 40 ? AppSize.buttonHeight * 1.4 : AppSize.buttonHeight,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowColor,
                  offset: Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: -6)
            ],
            color: AppColors.textFieldUnfoucsColor,
            borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
        child: AppText.text(
          str,
          style: AppTextStyle.default_14.copyWith(color: AppColors.whiteText),
          maxLines: 3,
        ));
    final tp = context.read<TimerProvider>();
    if (tp.lastToastText == null || tp.lastToastText != str) {
      tp.setLastToastText(str);
      return fToast!.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 3),
      );
    } else if (!tp.isToastRunnint) {
      return tp.toastProcess(() {
        fToast!.showToast(
          child: toast,
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 3),
        );
      });
    }
  }
}
