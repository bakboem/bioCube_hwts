import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 각종 사이즈 데이터 사전 등록.
class AppSize {
  static double fontSize(double size) => size;
  static double bottomSafeAreaHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;
  static double rightSafeAreaHeight(BuildContext context) =>
      MediaQuery.of(context).padding.right;
  static double topSafeAreaHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;
  static double get defaultContentsWidth => realWidth - padding * 2;
  static double get zero => 0;
  static double get realWidth => 1.sw;
  static double get realHeight => 1.sh;
  static double get itemExtent => 40;
  static double get singlePupopHeight => buttonHeight * 3;
  static double get padding => 16.w;
  static double get popHeight => 430.h;
  static double get defaultCheckBoxHeight => 20;
  static double get appBarHeight => 56.h;
  static double get cardBorderWidth => 5;
  static double get card1BorderWidth => 3;
  static double get smallButtonWidth => 70;
  static double get floatButtonWidth => 100;
  static double get statusBarHeight => 24.h;
  static double get splashIconWidth => 56.h;
  static double get splashIconBottomSpacing => 32.h;
  static double get splashLogoWidth => 50.w;
  static double get splashLogoHeight => 10.h;
  static double get splashIconHeight => 60.h;
  static double get defaultBorderWidth => 1.w;
  static double get smallButtonHeight => 32;
  static double get weekDayHeight => 80.h;
  static double get calendarWidth => AppSize.realWidth;
  static double get weekDayNumberBoxHeight => 30;
  static double get avataWidth => 65;
  static double get elevation => 8;
  static double get cardAvataWidth => 70;
  static double get defaultSpacingForTitleAndTextField => 5.w;
  static double get buttomPaddingForTitleAndTextField => 18.w;
  static EdgeInsets get signinLogoPadding => EdgeInsets.fromLTRB(0, 50, 0, 30);
  static double buildWidth(BuildContext context, double multiple) =>
      MediaQuery.of(context).size.width * multiple;
  static double get updatePopupWidth => 328.w;
  static double get smallPopupHeight => 300;
  static double get downloadPopupHeight => 250;
  static double get singlePopupHeight => 150.w;
  static double get menuPopupHeight =>
      buttonHeight * 3 + AppSize.dividerHeight * 2;
  static double get buttonHeight => 55;
  static double get bottomButtonHeight => 65;
  static double get dividerHeight => 2;
  static double get strokeWidth => 2;
  static double get noticeHeight => 430.h;
  static double get choosePopupHeightForUpdate => 220;
  static double get enForcePopupHeightForUpdate => 260;
  static double get radius5 => 5.r;
  static double get radius4 => 4.r;
  static double get progressHeight => 3.h;
  static double get radius8 => 8.r;
  static double get radius15 => 14.0;
  static double get radius25 => 25.r;
  static double get cellPadding => 10.w;
  static EdgeInsets get popupPadding =>
      EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 20.h);
  static EdgeInsets get searchPopupListPadding =>
      EdgeInsets.only(top: 12.w, bottom: 12.w, left: 0, right: 0);
  static EdgeInsets get nullValueWidgetPadding =>
      EdgeInsets.only(left: padding, top: 50.w, bottom: 50.w, right: padding);

  static double get secondButtonHeight => 44;
  static double get secondButtonWidth => 110.w;
  static double get listFontSpacing => 4.w;
  static double get defaultListItemSpacing => 9.w;
  static double get versionInfoSpacing1 => 12.w;
  static double get versionInfoSpacing2 => 67.w;
  static double get timeBoxHeight => 42.h;
  static double get shimmerHeight => 44.w;
  static double get buttonShimmerHeight => 30.w;
  static double get versionShimmerSpacing => 20.w;
  static double get timeBoxWidth => 156.w;
  static double get suggestionsBoxHeight => 205.h;
  static double get timePickerBoxHeight => 230.h;
  static EdgeInsets get defaultSidePadding =>
      EdgeInsets.only(left: padding, right: padding);
  static double get defaultShimmorSpacing => 4.w;
  static double get defaultIconWidth => 18.w;
  static double get secondPopupHeight => 346;
  static EdgeInsets get tageSidePadding =>
      EdgeInsets.only(left: 8.w, right: 8.w, top: 3.w, bottom: 3.w);
  static double get textFiledIconMainWidth => 18.w;
  static double get textFiledIconMaxWidth => 24.w;
  static double get textFiledIconSidePadding => 12.w;
  static double get iconSmallDefaultWidth => 12.w;
  static double get textRowTableHeight => 35.w;
  static double get textRowModelShowAllIconTopPadding => 8.w;
  static EdgeInsets get textRowModelLinePadding =>
      EdgeInsets.only(top: 8.h, bottom: 8.h);
  static double get textFiledDefaultSpacing => 10.w;
  static double get defaultTextFieldHeight => 42.w;
  static double get defaultLineHeight => textFiledIconSidePadding;
  static double get popupAppbarHeight => 88.w;
  static EdgeInsets defaultTextFieldPadding(double textHeight,
          {double? boxHeight}) =>
      EdgeInsets.fromLTRB(
          12.w,
          boxHeight != null
              ? ((boxHeight - textHeight - 2) / 2)
              : ((defaultTextFieldHeight - textHeight - 2) / 2),
          12.w,
          boxHeight != null
              ? (boxHeight - textHeight - 2) / 2
              : ((defaultTextFieldHeight - textHeight - 2) / 2));
  static EdgeInsets defaultTextFieldPaddingWidthSigninPage(double fontSize,
          {double? boxHeight}) =>
      EdgeInsets.fromLTRB(
        12.w,
        boxHeight != null
            ? (boxHeight - fontSize - 2) / 2
            : (defaultTextFieldHeight - fontSize - 2) / 2,
        12.w,
        boxHeight != null
            ? (boxHeight - fontSize - 2) / 2
            : (defaultTextFieldHeight - fontSize - 2) / 2,
      );

  static double get listItemDateAndNameSpacing => 10.w;
  static EdgeInsets get searchButtonPadding =>
      EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 30.w);
}
