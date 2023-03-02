/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/base_date_picker_for_month.dart
 * Created Date: 2022-09-25 09:37:58
 * Last Modified: 2023-03-02 18:58:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwst/model/common/result_model.dart';
import 'package:hwst/view/common/widget_of_dialog_contents.dart';
import 'package:hwst/view/common/provider/base_date_picker_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../styles/export_common.dart';

typedef DateCallback = Function(DateTime?);

class BaseDatePickerForMonth extends StatefulWidget {
  const BaseDatePickerForMonth({Key? key, this.dateCallback, this.initDate})
      : super(key: key);
  final DateCallback? dateCallback;
  final DateTime? initDate;
  @override
  State<BaseDatePickerForMonth> createState() => _BaseDatePickerForMonthState();
}

class _BaseDatePickerForMonthState extends State<BaseDatePickerForMonth> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BaseDatePickerForMonthProvider(),
      builder: (context, _) {
        final p = context.read<BaseDatePickerForMonthProvider>();
        return FutureBuilder<ResultModel>(
            future: p.initYearList(widget.initDate),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return buildTowButtonDialogContents(
                    context,
                    AppSize.secondPopupHeight,
                    Container(
                        height:
                            AppSize.secondPopupHeight - AppSize.buttonHeight,
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: AppSize.buttonHeight,
                                  child: Padding(
                                      padding: AppSize.defaultSidePadding,
                                      child: Selector<
                                          BaseDatePickerForMonthProvider,
                                          Tuple2<int?, int?>>(
                                        selector: (context, provider) => Tuple2(
                                            provider.currenYear,
                                            provider.currenMonth),
                                        builder: (context, tuple, _) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 60,
                                                  child: AppText.text(
                                                      tuple.item1 != null
                                                          ? '${tuple.item1}'
                                                          : '',
                                                      style: AppTextStyle
                                                          .w500_20)),
                                              AppText.text('년',
                                                  style: AppTextStyle.w500_20
                                                      .copyWith(fontSize: 18)),
                                              SizedBox(
                                                  width: 30,
                                                  child: AppText.text(
                                                      tuple.item2 != null
                                                          ? '${tuple.item2}'
                                                          : '',
                                                      style: AppTextStyle
                                                          .w500_20)),
                                              AppText.text('월',
                                                  style: AppTextStyle.w500_20
                                                      .copyWith(fontSize: 18)),
                                            ],
                                          );
                                        },
                                      )),
                                ),
                                Divider(
                                  thickness: 1,
                                  height: 1,
                                )
                              ],
                            ),
                            Expanded(
                                child: Padding(
                              padding: AppSize.defaultSidePadding,
                              child: Row(
                                children: [
                                  Selector<BaseDatePickerForMonthProvider,
                                      int?>(
                                    selector: (context, provider) =>
                                        provider.currenYear,
                                    builder: (context, year, _) {
                                      return Container(
                                        width: (AppSize.defaultContentsWidth -
                                                AppSize.padding * 2) *
                                            .5,
                                        child: CupertinoPicker(
                                            scrollController:
                                                FixedExtentScrollController(
                                                    initialItem: p.yearList
                                                        .indexOf(year!)),
                                            itemExtent: 50,
                                            looping: true,
                                            selectionOverlay: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          width: .8,
                                                          color: AppColors
                                                              .textGrey),
                                                      bottom: BorderSide(
                                                          width: .8,
                                                          color: AppColors
                                                              .textGrey))),
                                            ),
                                            onSelectedItemChanged: (int value) {
                                              p.setCurrenYear(value);
                                            },
                                            children: p.yearList
                                                .asMap()
                                                .entries
                                                .map((map) => Center(
                                                      child: AppText.text(
                                                          '${map.value}년',
                                                          style: AppTextStyle
                                                              .default_18),
                                                    ))
                                                .toList()),
                                      );
                                    },
                                  ),
                                  Selector<BaseDatePickerForMonthProvider,
                                      int?>(
                                    selector: (context, provider) =>
                                        provider.currenMonth,
                                    builder: (context, month, _) {
                                      return Container(
                                        width: (AppSize.defaultContentsWidth -
                                                AppSize.padding * 2) *
                                            .5,
                                        child: CupertinoPicker(
                                            scrollController:
                                                FixedExtentScrollController(
                                                    initialItem: p.monthList
                                                        .indexOf(month!)),
                                            itemExtent: 50,
                                            looping: true,
                                            selectionOverlay: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          width: .8,
                                                          color: AppColors
                                                              .textGrey),
                                                      bottom: BorderSide(
                                                          width: .8,
                                                          color: AppColors
                                                              .textGrey))),
                                            ),
                                            onSelectedItemChanged: (int value) {
                                              p.setCurrenMonth(value);
                                            },
                                            children: p.monthList
                                                .asMap()
                                                .entries
                                                .map((map) => Center(
                                                      child: AppText.text(
                                                          '${map.value}월',
                                                          style: AppTextStyle
                                                              .default_18),
                                                    ))
                                                .toList()),
                                      );
                                    },
                                  ),
                                  // Selector<BaseDatePickerForMonthProvider, int?>(
                                  //   selector: (context, provider) =>
                                  //       provider.currenDay,
                                  //   builder: (context, day, _) {
                                  //     return Container(
                                  //       width: (AppSize.realWidth -
                                  //               AppSize.padding * 2) *
                                  //           .33,
                                  //       child: CupertinoPicker(
                                  //           scrollController:
                                  //               FixedExtentScrollController(
                                  //                   initialItem: 0),
                                  //           itemExtent: 50,
                                  //           looping: true,
                                  //           selectionOverlay: Container(
                                  //             decoration: const BoxDecoration(
                                  //                 border: Border(
                                  //                     top: BorderSide(
                                  //                         width: .8,
                                  //                         color:
                                  //                             AppColors.textGrey),
                                  //                     bottom: BorderSide(
                                  //                         width: .8,
                                  //                         color:
                                  //                             AppColors.textGrey))),
                                  //           ),
                                  //           onSelectedItemChanged: (int value) {
                                  //             p.setCurrenDay(value);
                                  //           },
                                  //           children: p.dayList
                                  //               .asMap()
                                  //               .entries
                                  //               .map((map) => Center(
                                  //                     child: AppText.text(
                                  //                       '${map.value}',
                                  //                     ),
                                  //                   ))
                                  //               .toList()),
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),
                            ))
                          ],
                        )), callback: () {
                  return DateTime(p.currenYear!, p.currenMonth!)
                      .toIso8601String();
                });
              } else {
                return Container();
              }
            });
      },
    );
  }
}
