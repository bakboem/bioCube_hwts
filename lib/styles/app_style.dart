import 'dart:io';

import 'app_colors.dart';
import 'app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/styles/app_text.dart';

class AppStyles {
  static OutlineInputBorder defaultBorder = OutlineInputBorder(
      gapPadding: 0,
      borderSide:
          BorderSide(color: AppColors.unReadyButtonBorderColor, width: 1),
      borderRadius: BorderRadius.circular(AppSize.radius5));
  static OutlineInputBorder focusedBorder = OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide(color: AppColors.primary, width: 1),
      borderRadius: BorderRadius.circular(AppSize.radius5));

  /// [TextButton] 사용시 style 사전 정의.
  static ButtonStyle getButtonStyle(Color backgroundColor, Color forgroundColor,
      TextStyle textStyle, double radius,
      {MaterialStateProperty<EdgeInsetsGeometry?>? padding,
      bool? isOnlyLeftBottom,
      bool? isOnlyRightBottom}) {
    return ButtonStyle(
      padding: padding,
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      foregroundColor: MaterialStateProperty.all(forgroundColor),
      textStyle: MaterialStateProperty.all(textStyle),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: isOnlyRightBottom ?? false
              ? BorderRadius.only(bottomRight: Radius.circular(radius))
              : isOnlyLeftBottom ?? false
                  ? BorderRadius.only(bottomLeft: Radius.circular(radius))
                  : BorderRadius.circular(radius))),
    );
  }

  // 검색버튼 사전 정의.
  static Widget buildSearchButton(
      BuildContext context, String buttonText, Function callback,
      {bool? doNotWithPadding}) {
    return Padding(
        padding: doNotWithPadding != null
            ? EdgeInsets.all(AppSize.zero)
            : AppSize.searchButtonPadding,
        child: AppStyles.buildButton(
            context,
            '$buttonText',
            AppSize.realWidth * .55,
            AppColors.primary,
            AppTextStyle.color_16(AppColors.whiteText),
            AppSize.radius8,
            () => callback.call(),
            isWithBorder: true,
            borderColor: AppColors.whiteText,
            selfHeight: AppSize.secondButtonHeight));
  }

  /// [Container]로 일반 버튼 paint 할때 기본 양식 사전 정의.
  static Widget buildButton(BuildContext context, String text, double width,
      Color bgColor, TextStyle style, double radius, VoidCallback callback,
      {bool? isLeft,
      bool? isBottomButton,
      bool? isWithBottomRadius,
      double? selfHeight,
      bool? isWithBorder,
      Color? borderColor,
      bool? isOnlyTopBorder}) {
    return GestureDetector(
      onTap: callback.call,
      child: Container(
          alignment: Alignment.center,
          height: isBottomButton == null
              ? selfHeight ?? AppSize.buttonHeight
              : Platform.isIOS
                  ? AppSize.bottomButtonHeight
                  : AppSize.buttonHeight,
          width: width,
          decoration: BoxDecoration(
              color: bgColor,
              border: isWithBorder != null
                  ? Border.all(
                      color: borderColor!, width: AppSize.defaultBorderWidth)
                  : isOnlyTopBorder != null
                      ? Border(
                          top: BorderSide(width: .5, color: AppColors.textGrey))
                      : null,
              borderRadius: isLeft != null
                  ? isLeft
                      ? BorderRadius.only(bottomLeft: Radius.circular(radius))
                      : BorderRadius.only(bottomRight: Radius.circular(radius))
                  : isWithBottomRadius != null
                      ? isWithBottomRadius
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(radius),
                              bottomRight: Radius.circular(radius))
                          : null
                      : BorderRadius.all(Radius.circular(radius))),
          child: AppText.text('$text', style: style)),
    );
  }

// Pipe 공통 style.
  static Widget buildPipe({double? height}) {
    return Padding(
      padding: EdgeInsets.only(
          left: AppSize.defaultListItemSpacing,
          right: AppSize.defaultListItemSpacing),
      child: Container(
          height: height ??
              (AppTextStyle.h4.fontSize ?? AppTextStyle.hint_16.fontSize!) - 2,
          decoration: BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.textGrey)))),
    );
  }

  static Widget buildTitleRow(String text, {bool? isNotwithStart}) {
    return Row(children: [
      AppText.text(text, style: AppTextStyle.h4),
      SizedBox(width: AppSize.defaultListItemSpacing / 2),
      isNotwithStart != null && isNotwithStart
          ? Container()
          : AppText.text('*',
              style: AppTextStyle.h4.copyWith(color: AppColors.dangerColor))
    ]);
  }

  static Widget defultRowSpacing() {
    return Padding(
        padding: EdgeInsets.only(right: AppSize.defaultListItemSpacing));
  }
}
