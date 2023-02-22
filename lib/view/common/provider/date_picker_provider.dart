/*
 * Project Name:  [maepyoso] -  V1.2.0+
 * File: /Users/bakbeom/work/sm/kcld/ticketoffice/lib/view/common/provider/date_picker_provider.dart
 * Created Date: 2022-04-18 01:25:52
 * Last Modified: 2023-02-22 22:37:58
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  케이씨엘디 주식회사 ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/view/common/function_of_print.dart';

class BaseDatePickerForMonthProvider extends ChangeNotifier {
  List<List<int>> dayInMonth = [];
  var startYear = DateTime.now().year - 70;
  var endYear = DateTime.now().year;
  int? currenYear;
  int? currenMonth;
  int? currenDay;
  List<int> yearList = [];
  List<int> monthList = [];
  List<int> dayList = [];
  get currentDate => DateTime(currenYear!, currenMonth!, currenDay!);
  Future<ResultModel> initYearList() async {
    await Future.delayed(Duration.zero, () {
      while (startYear != endYear) {
        yearList.add(startYear);
        startYear++;
      }
    }).whenComplete(() {
      monthList.clear();
      List.generate(12, (index) => monthList.add(index + 1));
    });

    await howManyDays(startYear);
    currenMonth = monthList.first;
    dayList = dayInMonth[currenMonth!];
    currenYear = yearList.first;
    currenDay = dayList.first;
    notifyListeners();
    return ResultModel(true);
  }

  void setCurrenYear(int index) {
    currenYear = yearList[index];
    howManyDays(currenYear);
  }

  void setCurrenMonth(int index) {
    currenMonth = monthList[index];
    var dayCount = DateTime(currenYear!, currenMonth! + 1, 0).day;
    dayList.clear();
    List.generate(dayCount, (index) => dayList.add(index + 1));
    notifyListeners();
  }

  void setCurrenDay(int index) {
    currenDay = dayList[index];

    notifyListeners();
  }

  Future<void> howManyDays(int? year) async {
    dayInMonth.clear();
    List.generate(12, (index) => dayInMonth.add([]));
    await Future.delayed(Duration.zero, () async {
      for (var month = 1; month <= 12; month++) {
        var dayCount = DateTime(year!, month + 1, 0).day;
        pr(month);
        List.generate(
            dayCount, (index) => dayInMonth[month - 1].add(index + 1));
      }
    });
  }
}
