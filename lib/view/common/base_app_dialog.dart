/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/app_dialog.dart
 * Created Date: 2021-08-23 13:52:24
 * Last Modified: 2023-02-22 22:42:56
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hwst/util/format_util.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/widget_of_dialog_contents.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';

typedef DiaLogCallBack = Function(bool);
typedef CanPopCallBack = Future<bool> Function();

class AppDialog {
  static dynamic showPopup(BuildContext context, Widget widget,
      {bool? isWithShapeBorder}) {
    return showDialog(
        useSafeArea: false,
        context: context,
        builder: (ctx) => AlertDialog(
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: isWithShapeBorder == null || isWithShapeBorder
                ? RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppSize.radius15)))
                : null,
            content:
                WillPopScope(child: widget, onWillPop: () async => false)));
  }

  static Future<void> showSimpleDialog(
      BuildContext context, String? title, String text,
      {String? cancelButtonText,
      String? successButtonText,
      bool? isSingleButton,
      DiaLogCallBack? callBack}) async {
    var default16 =
        AppTextStyle.default_16.copyWith(color: AppColors.defaultText);
    var primray16 = AppTextStyle.default_16.copyWith(color: AppColors.primary);
    var actionWidget = isSingleButton != null && isSingleButton
        ? <Widget>[
            CupertinoDialogAction(
                textStyle: primray16,
                child: Text(successButtonText ?? tr('ok')),
                onPressed: () => callBack != null
                    ? callBack.call(true)
                    : Navigator.pop(context)),
          ]
        : <Widget>[
            CupertinoDialogAction(
              textStyle: default16,
              child: Text(cancelButtonText ?? tr('cancel')),
              onPressed: () => callBack != null
                  ? callBack.call(false)
                  : Navigator.pop(context),
            ),
            CupertinoDialogAction(
              textStyle: primray16,
              child: Text(successButtonText ?? tr('ok')),
              onPressed: () => callBack != null
                  ? callBack.call(true)
                  : Navigator.pop(context),
            ),
          ];

    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
              title: title != null ? Text(title) : Container(),
              content: Text(
                text,
                style: AppTextStyle.default_16,
                textAlign: TextAlign.center,
              ),
              actions: actionWidget);
        });
  }

  static dynamic showDangermessage(BuildContext context, String str,
      {bool? isPopToFirst}) {
    // str = str + "fdsaffsafdsafdsafklasfjdskal;jf\n\nd\n,\n,\n" * 15;
    var enterLength = FormatUtil.howManyLengthForString(str) + 1;
    var height =
        AppSize.buttonHeight * 3 + AppSize.padding * 2 + enterLength * 16;
    pr('enterLength $enterLength');
    return showPopup(
        context,
        buildDialogContents(
            context,
            Container(
              alignment: Alignment.centerLeft,
              height: height - AppSize.buttonHeight,
              width: AppSize.defaultContentsWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: AppImage.getImage(ImageType.INFO)),
                  defaultSpacing(),
                  AppText.text('$str',
                      textAlign: TextAlign.center,
                      maxLines: 50,
                      style: AppTextStyle.default_16)
                ],
              ),
            ),
            true,
            height > AppSize.realHeight * .6 ? AppSize.realHeight * .6 : height,
            signgleButtonText: '${tr('ok')}',
            isPoptoFirst: isPopToFirst));
  }

  static menu(BuildContext context) {
    return AppDialog.showPopup(
        context,
        buildDialogContents(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context, 'edit');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: AppSize.buttonHeight,
                    child: AppText.text('${tr('do_edit')}',
                        style: AppTextStyle.default_18),
                  ),
                ),
                Divider(
                  height: AppSize.dividerHeight,
                  color: AppColors.textGrey,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, 'delete');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: AppSize.buttonHeight,
                    child: AppText.text('${tr('do_delete')}',
                        style: AppTextStyle.default_18),
                  ),
                )
              ],
            ),
            true,
            AppSize.menuPopupHeight,
            signgleButtonText: '${tr('close')}',
            isNotPadding: true));
  }

  static showSignglePopup(BuildContext context, String contents,
      {double? height}) {
    var enterLength = FormatUtil.howManyLengthForString(contents) + 1;
    var height =
        AppSize.buttonHeight * 2 + AppSize.padding * 2 + enterLength * 16;
    return showPopup(
        context,
        buildDialogContents(
            context,
            Container(
              alignment: Alignment.centerLeft,
              height: height - AppSize.buttonHeight,
              child: AppText.text('$contents',
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  style: AppTextStyle.default_16),
            ),
            true,
            height,
            signgleButtonText: '${tr('ok')}'));
  }
}
