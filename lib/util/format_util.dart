/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/util/number_format.dart
 * Created Date: 2021-09-08 09:34:02
 * Last Modified: 2023-02-22 22:42:59
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/function_of_print.dart';

class FormatUtil {
  static String addComma(String number, {bool? isReturnZero}) {
    number = number.trim();
    if (double.tryParse(number) != null) {
      if (double.parse(number) == 0) {
        return isReturnZero != null ? '0' : '';
      } else {
        NumberFormat formater = NumberFormat();
        if (double.parse(number) > 999) formater = NumberFormat('#,000');
        return formater.format(double.tryParse(number));
      }
    } else {
      return number;
    }
  }

  static double asFixed(String val, int fixed) {
    return double.parse(double.parse(val).toStringAsFixed(fixed));
  }

  static String getDistance(data) {
    pr(data.toString());
    return data.toString().trim() == '' || double.tryParse(data.toString()) == 0
        ? '-'
        : '${data.toString()}km';
  }

  static String formatNum(double num, int postion) {
    if (double.tryParse('$num') != null) {
      if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
          postion) {
        return num.toStringAsFixed(postion)
            .substring(0, num.toString().lastIndexOf(".") + postion + 1)
            .toString();
      } else {
        return num.toString()
            .substring(0, num.toString().lastIndexOf(".") + postion + 1)
            .toString();
      }
    } else {
      return '$num';
    }
  }

  static String formatZero(String str) {
    return int.tryParse(str) != null ? int.tryParse(str).toString() : str;
  }

  static String moneyWithCurrencyUnit(String number, String unit) {
    number = number.trim();
    if (double.tryParse(number) != null) {
      var temp = double.tryParse(number);
      if (temp == 0) {
        return '0$unit';
      } else {
        number = '${addComma(number)} $unit';
        return number;
      }
    } else {
      return number;
    }
  }

  static String addCommaAndUsdForDecimals(String str, String unit) {
    if (double.tryParse(str) != null) {
      var temp = double.parse(str);
      if (temp == 0) {
        return '';
      } else {
        str = '${formatNum(temp, 2)} $unit';
        return str;
      }
    } else {
      return str;
    }
  }

  static String addCommaAndDecimals(String str) {
    var before = '';
    var end = '';
    if (str.contains('.')) {
      before = str.substring(0, str.indexOf('.'));
      end = str.substring(str.indexOf('.'));
    }
    before = addComma(before);
    if (before == '') {
      before = '0';
      if (end.contains(' ')) {
        end = end.substring(end.indexOf(' '));
      }
    }
    return before + end;
  }

  static String moneyAndUnitDouble(
      String money, String moneyUnit, String queantity, String queantityUnit) {
    print('quqqqqqqqq ::::$queantity');
    if (double.tryParse(money) != null && int.tryParse(queantity) != null) {
      var temp = double.parse(money);
      if (temp == 0) {
        return '';
      } else {
        money = '${formatNum(temp, 2)} $moneyUnit';
        queantity = '${int.parse(queantity)}$queantityUnit';
        return '${addComma(money)} / $queantity';
      }
    } else {
      return '$money$moneyUnit$queantity$queantityUnit';
    }
  }

  static String addPercent(String str) {
    if (double.tryParse(str) != null) {
      var temp = double.parse(str);
      return '${formatNum(temp, 1)}%';
    } else {
      return str;
    }
  }

  static String addBrackets(String str) {
    return '($str)';
  }

  static String addPeriod(String? str1, String? str2) {
    if (str1 != null && str1 != '' && str2 != null && str2 != '') {
      var temp1 = addDashForDateStr(str1);
      var temp2 = addDashForDateStr(str2);
      return '$temp1 ~ $temp2';
    } else {
      return '';
    }
  }

  static double randomSimmerSize(int max, int min) {
    Random random = new Random();

    return (random.nextInt(max - min) + min).toDouble();
  }

  static String addDashForMonth(String str, {bool? isYYMM}) {
    if (str.length == 8) {
      return str.substring(4).replaceRange(2, 2, '-');
    } else if (isYYMM != null && isYYMM && str.length == 6) {
      var temp = str.substring(2);
      return temp.replaceRange(2, 2, '-');
    } else if (str.length == 6) {
      return str.replaceRange(4, 4, '-');
    } else
      return str;
  }

  static String addDashForPhoneNumber(String str) {
    if (str.length == 11) {
      return str.replaceRange(3, 3, '-').replaceRange(8, 8, '-');
    } else
      return str;
  }

  static String addDashForLicenceNumber(String str) {
    if (str.length == 10) {
      return str.replaceRange(3, 3, '-').replaceRange(6, 6, '-');
    } else
      return str;
  }

  static String addDashForDateStr(String str) {
    if (str.trim().length == 8) {
      return str.trim().replaceRange(4, 4, '-').replaceRange(7, 7, '-');
    } else
      return str;
  }

  static String addDashForDoubleDateStr(String str, String str2) {
    if (str.trim().length == 8 && str2.trim().length == 8) {
      return '${str.trim().replaceRange(4, 4, '-').replaceRange(7, 7, '-')} ~ ${str2.trim().replaceRange(4, 4, '-').replaceRange(7, 7, '-')}';
    } else
      return '$str ~ $str2';
  }

  static String addDashForDateStr2(String str) {
    if (str.length == 8) {
      return str.substring(2).replaceRange(2, 2, '-').replaceRange(5, 5, '-');
    } else
      return str;
  }

  static String addColonForTime(String str) {
    if (str.length == 6) {
      return str.substring(0, str.length - 2).replaceRange(2, 2, ':');
    } else
      return str;
  }

  static String subToStartSpace(String str) {
    if (str.startsWith(' ')) {
      str = str.substring(1);
    }
    return str.substring(0, str.indexOf(' '));
  }

  static String subToEndSpace(String str) {
    if (str.startsWith(' ')) {
      str = str.substring(1);
    }
    return str.substring(str.indexOf(' ') + 1);
  }

  static String currencyUnitConversion(String str) {
    final doubleData = double.tryParse(str);
    if (doubleData != null && doubleData != 0) {
      final unit = 1000000;
      final transData = doubleData / unit;
      return '${transData.truncate()}${tr('million')}';
    }
    return '';
  }

  static String removeDash(String str) {
    return str.replaceAll('-', '');
  }

  static String monthStr(
    String str, {
    bool? isWithDash,
  }) {
    var temp = str.replaceAll('-', '');
    return isWithDash != null && isWithDash
        ? str.substring(0, str.length - 3)
        : temp.substring(0, temp.length - 2);
  }

  static String profitConversion(String saler) {
    if (saler == '0' || saler == '') {
      return '';
    } else {
      return '$saler%';
    }
  }

  static int howManyLengthForString(String str) {
    var count = 0;
    for (var i = 0; i < str.length; i++) {
      if (str[i] == '\n') {
        count++;
      }
    }

    return count;
  }
}
