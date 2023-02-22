/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/string_fomate_type.dart
 * Created Date: 2021-09-17 09:25:12
 * Last Modified: 2023-02-22 22:42:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hwst/util/format_util.dart';

// 포맷 유형
enum StringFormateType {
  PHONE,
  DATE_MD,
  DATE_YMD,
  DATE_YMD_DOUBLE,
  DATE_YMD_SHORT,
  MONEY,
  COMMA_WITH_CURRENCY_UNIT,
  MONEY_KEEP_DECIMALS,
  MONEY_AND_UNIT_DOUBLE,
  PERCENT,
  PERIOD,
  BRACKETS,
  NONE,
  LICENCE
}

extension StringFormateTypeExtension on StringFormateType {
  String formate(String body, {String? body2, String? body3, String? body4}) {
    switch (this) {
      case StringFormateType.DATE_MD:
        return FormatUtil.addDashForMonth(body);
      case StringFormateType.DATE_YMD:
        return FormatUtil.addDashForDateStr(body);
      case StringFormateType.DATE_YMD_DOUBLE:
        return FormatUtil.addDashForDoubleDateStr(body, body2!);
      case StringFormateType.DATE_YMD_SHORT:
        return FormatUtil.addDashForDateStr2(body);
      case StringFormateType.MONEY:
        return FormatUtil.addComma(body);
      case StringFormateType.PERCENT:
        return FormatUtil.addPercent(body);
      case StringFormateType.PERIOD:
        return FormatUtil.addPeriod(body, body2!);
      case StringFormateType.COMMA_WITH_CURRENCY_UNIT:
        return FormatUtil.moneyWithCurrencyUnit(body, body2!);
      case StringFormateType.BRACKETS:
        return FormatUtil.addBrackets(body);
      case StringFormateType.MONEY_KEEP_DECIMALS:
        return FormatUtil.addCommaAndUsdForDecimals(body, body2!);
      case StringFormateType.PHONE:
        return FormatUtil.addDashForPhoneNumber(body);
      case StringFormateType.MONEY_AND_UNIT_DOUBLE:
        return FormatUtil.moneyAndUnitDouble(body, body2!, body3!, body4!);
      case StringFormateType.LICENCE:
        return FormatUtil.addDashForLicenceNumber(body);
      case StringFormateType.NONE:
        return body;
    }
  }
}
