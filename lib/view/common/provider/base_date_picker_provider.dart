/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/provider/base_date_picker_provider.dart
 * Created Date: 2022-07-06 10:31:03
 * Last Modified: 2023-03-02 18:58:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/view/common/function_of_print.dart';

class BaseDatePickerForMonthProvider extends ChangeNotifier {
  List<List<int>> dayInMonth = [];
  var startYear = DateTime.now().year - 10;
  var endYear = DateTime.now().year + 10;
  int? currenYear;
  int? currenMonth;
  int? currenDay;
  List<int> yearList = [];
  List<int> monthList = [];
  List<int> dayList = [];
  get currentDate => DateTime(currenYear!, currenMonth!, currenDay!);
  Future<ResultModel> initYearList(DateTime? initDate) async {
    await Future.delayed(Duration.zero, () {
      while (startYear != endYear) {
        yearList.add(startYear);
        startYear++;
      }
    }).whenComplete(() {
      monthList.clear();
      List.generate(12, (index) => monthList.add(index + 1));
    });

    // await howManyDays(startYear);
    // currenMonth = monthList.first;
    // dayList = dayInMonth[currenMonth!];
    // currenYear = yearList.first;
    // currenDay = dayList.first;
    currenYear = initDate != null ? initDate.year : DateTime.now().year;
    currenMonth = initDate != null ? initDate.month : DateTime.now().month;
    notifyListeners();
    return ResultModel(true);
  }

  void setCurrenYear(int index) {
    currenYear = yearList[index];
    // howManyDays(currenYear);
    notifyListeners();
  }

  void setCurrenMonth(int index) {
    currenMonth = monthList[index];
    // var dayCount = DateTime(currenYear!, currenMonth! + 1, 0).day;
    dayList.clear();
    // List.generate(dayCount, (index) => dayList.add(index + 1));
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
