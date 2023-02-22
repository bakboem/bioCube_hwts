/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/history/history_page.dart
 * Created Date: 2023-01-29 17:56:27
 * Last Modified: 2023-02-22 22:44:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hwst/globalProvider/timer_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/util/date_util.dart';
import 'package:hwst/util/format_util.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/enums/verify_type.dart';
import 'package:hwst/enums/input_icon_type.dart';
import 'package:hwst/enums/popup_list_type.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/model/history/history_model.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:hwst/view/common/base_input_widget.dart';
import 'package:hwst/view/common/widget_of_divider_line.dart';
import 'package:hwst/view/common/widget_of_loading_view.dart';
import 'package:hwst/model/history/history_response_model.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';
import 'package:hwst/view/common/widget_of_next_page_loading.dart';
import 'package:hwst/globalProvider/next_page_loading_provider.dart';
import 'package:hwst/view/history/provider/history_page_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  static final String routeName = '/HistoryPage';
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late ScrollController _scrollController;
  var _scrollSwich = ValueNotifier<bool>(false);
  bool upLock = true;
  bool downLock = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollSwich.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildCheckBoxItem(
      BuildContext context, Map<VerifyType, bool> map, int index,
      {required double width}) {
    final p = context.read<HistoryPageProvider>();
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: AppSize.defaultCheckBoxHeight,
            height: AppSize.defaultCheckBoxHeight,
            child: Checkbox(
                activeColor: AppColors.primary,
                key: Key('$index'),
                value: map.values.single,
                onChanged: (val) {
                  p.setCheckBoxList(index);
                }),
          ),
          Padding(
              padding:
                  EdgeInsets.only(right: AppSize.defaultListItemSpacing / 2)),
          Expanded(
              child: AppText.text(map.keys.single.title,
                  style: map.values.single
                      ? AppTextStyle.default_14
                          .copyWith(fontWeight: FontWeight.w600)
                      : AppTextStyle.sub_14,
                  textAlign: TextAlign.start))
        ],
      ),
    );
  }

  Widget _buildCheckAll(BuildContext context) {
    return Selector<HistoryPageProvider, bool>(
      selector: (context, provider) => provider.isCheckedAll,
      builder: (context, isChecked, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSize.defaultCheckBoxHeight,
              height: AppSize.defaultCheckBoxHeight,
              child: Checkbox(
                  activeColor: AppColors.primary,
                  value: isChecked,
                  onChanged: (val) {
                    final p = context.read<HistoryPageProvider>();
                    p.setIsCheckedAll();
                  }),
            ),
            Padding(
                padding:
                    EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
            AppText.text(tr('all'),
                style: isChecked
                    ? AppTextStyle.default_14
                        .copyWith(fontWeight: FontWeight.w600)
                    : AppTextStyle.sub_14,
                textAlign: TextAlign.start)
          ],
        );
      },
    );
  }

  Widget _buildVerifyTypeSelectorRow(BuildContext context) {
    return Selector<HistoryPageProvider, List<Map<VerifyType, bool>>>(
      selector: (context, provider) => provider.checkBoxList,
      builder: (context, list, _) {
        return SizedBox(
            width: AppSize.defaultContentsWidth,
            child: Column(
              children: [
                Row(
                  children: [
                    ...list.sublist(0, list.length - 2).asMap().entries.map(
                        (map) => _buildCheckBoxItem(context, map.value, map.key,
                            width: AppSize.defaultContentsWidth / 4))
                  ],
                ),
                defaultSpacing(),
                Row(
                  children: [
                    ...list.sublist(list.length - 2).asMap().entries.map(
                        (map) => _buildCheckBoxItem(
                            context, map.value, map.key + 4,
                            width: AppSize.defaultContentsWidth / 2))
                  ],
                )
              ],
            ));
      },
    );
  }

  Widget _buildTitleText(BuildContext context, String title, bool isTitle) {
    return AppText.text(title,
        style: isTitle ? AppTextStyle.w500_16 : AppTextStyle.default_12,
        maxLines: isTitle ? null : 2);
  }

  Widget _buildDatePicker(BuildContext context) {
    final p = context.read<HistoryPageProvider>();
    return Row(
      children: [
        Selector<HistoryPageProvider, String?>(
            selector: (context, provider) => provider.selectedStartDate,
            builder: (context, startDate, _) {
              return BaseInputWidget(
                  context: context,
                  dateStr: startDate != null
                      ? FormatUtil.removeDash(startDate)
                      : null,
                  oneCellType: OneCellType.DATE_PICKER,
                  hintTextStyleCallBack: () => startDate != null
                      ? AppTextStyle.default_16
                      : AppTextStyle.hint_16,
                  hintText:
                      startDate != null ? startDate : '${tr('plz_enter_date')}',
                  iconType: InputIconType.DATA_PICKER,
                  isSelectedStrCallBack: (str) => p.setStartDate(context, str),
                  width: AppSize.timeBoxWidth,
                  enable: false);
            }),
        Center(child: AppText.text('~', style: AppTextStyle.default_16)),
        Selector<HistoryPageProvider, String?>(
            selector: (context, provider) => provider.selectedEndDate,
            builder: (context, endDate, _) {
              return BaseInputWidget(
                  context: context,
                  dateStr:
                      endDate != null ? FormatUtil.removeDash(endDate) : null,
                  oneCellType: OneCellType.DATE_PICKER,
                  hintTextStyleCallBack: () => endDate != null
                      ? AppTextStyle.default_16
                      : AppTextStyle.hint_16,
                  hintText:
                      endDate != null ? endDate : '${tr('plz_enter_date')}',
                  iconType: InputIconType.DATA_PICKER,
                  isSelectedStrCallBack: (str) => p.setEndDate(context, str),
                  width: AppSize.timeBoxWidth,
                  enable: false);
            }),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: AppStyles.buildSearchButton(context, tr('search'), () {
          final p = context.read<HistoryPageProvider>();
          var isNotCheked =
              p.checkBoxList.where((map) => map.values.single).isEmpty;

          if (isNotCheked) {
            AppDialog.showDangermessage(
                context,
                isNotCheked
                    ? tr('plz_select_verify_type')
                    : tr('plz_select_server_type'));
          } else {
            final tp = context.read<TimerProvider>();
            if (tp.isRunning == null || !tp.isRunning!) {
              tp.perdict(Future.delayed(Duration.zero, () async {
                p.refresh();
              }));
            }
          }
        }, doNotWithPadding: true));
  }

  Widget _buildSearchCondition(BuildContext context) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleText(context, tr('verify_method'), true),
            defaultSpacing(),
            _buildCheckAll(context),
            defaultSpacing(),
            _buildVerifyTypeSelectorRow(context),
            defaultSpacing(multiple: 2),
            _buildTitleText(context, tr('date_selection'), true),
            defaultSpacing(),
            _buildDatePicker(context),
            defaultSpacing(multiple: 2),
            _buildSearchButton(context),
            defaultSpacing()
          ],
        ));
  }

  Widget _buildResultItem(BuildContext context, HistoryModel model) {
    return Padding(
      padding: AppSize.defaultSidePadding,
      child: Row(
        children: [
          _buildResultItemBox(
              .35, '${DateUtil.getDateStr2(model.lDate!).trim()}',
              isLeft: true),
          _buildResultItemBox(.15, model.lResultNm!),
          _buildResultItemBox(
              .15,
              VerifyType.values
                  .where((type) => type.code == model.lType)
                  .single
                  .name),
          _buildResultItemBox(.35, '${model.dDefNm}')
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final p = context.read<HistoryPageProvider>();
    return Expanded(
        child: Selector<HistoryPageProvider, HistoryResponseModel?>(
      selector: (context, provider) => provider.responseModel,
      builder: (context, model, _) {
        return model != null && model.data != null && model.data!.isNotEmpty
            ? ListView.builder(
                controller: _scrollController
                  ..addListener(() {
                    if (_scrollController.offset > AppSize.appBarHeight) {
                      if (downLock == true) {
                        downLock = false;
                        upLock = true;
                        _scrollSwich.value = true;
                      }
                    } else {
                      if (upLock == true) {
                        upLock = false;
                        downLock = true;
                        _scrollSwich.value = false;
                      }
                    }
                    if (_scrollController.offset ==
                            _scrollController.position.maxScrollExtent &&
                        !p.isLoadData &&
                        p.hasMore) {
                      final nextPageProvider =
                          context.read<NextPageLoadingProvider>();
                      nextPageProvider.show();
                      p.nextPage().then((_) => nextPageProvider.stop());
                    }
                  }),
                itemCount: model.data!.length,
                itemBuilder: (context, index) {
                  return _buildResultItem(context, model.data![index]);
                })
            : _buildLoadDataWidget(context);
      },
    ));
  }

  Widget _buildResultItemBox(double multiple, String str,
      {bool? isTitle, bool? isLeft}) {
    return Container(
        height: isTitle != null ? null : AppTextStyle.default_12.fontSize! * 3,
        alignment: isLeft != null ? Alignment.centerLeft : Alignment.center,
        width: AppSize.defaultContentsWidth * multiple,
        child: _buildTitleText(context, str, isTitle ?? false));
  }

  Widget _buildResultTitle() {
    var list = [tr('date_time'), tr('partition'), tr('type'), tr('location')];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...list.asMap().entries.map((map) => Container(
              alignment: Alignment.center,
              color: AppColors.primary.withOpacity(.1),
              height: AppSize.defaultTextFieldHeight * .8,
              width: map.key == 0
                  ? AppSize.realWidth * .35
                  : map.key == 1
                      ? AppSize.realWidth * .15
                      : map.key == 2
                          ? AppSize.realWidth * .15
                          : AppSize.realWidth * .35,
              child: AppText.text(map.value,
                  style: AppTextStyle.default_14
                      .copyWith(fontWeight: FontWeight.w600)),
            )),
      ],
    );
  }

  Widget _buildLoadDataWidget(BuildContext context) {
    return Selector<HistoryPageProvider, Tuple2<bool, HistoryResponseModel?>>(
      selector: (context, provider) =>
          Tuple2(provider.isLoadData, provider.responseModel),
      builder: (context, tuple, _) {
        return tuple.item1
            ? BaseLoadingViewOnStackWidget.build(context, tuple.item1,
                color: Colors.white)
            : tuple.item2 == null
                ? Center(
                    child: AppText.text(tr('not_search_anything'),
                        style: AppTextStyle.sub_14))
                : Container();
      },
    );
  }

  Widget _buildScrollToTop(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _scrollSwich,
        builder: (context, isCanScroll, _) {
          return isCanScroll
              ? Selector<HistoryPageProvider, HistoryResponseModel?>(
                  selector: (context, provider) => provider.responseModel,
                  builder: (context, model, _) {
                    return model != null && model.data!.isNotEmpty
                        ? Positioned(
                            right: AppSize.padding,
                            bottom: AppSize.padding,
                            child: FloatingActionButton(
                              backgroundColor: AppColors.whiteText,
                              foregroundColor: AppColors.primary,
                              onPressed: () {
                                _scrollController.animateTo(0,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn);
                              },
                              child: AppImage.getImage(ImageType.SCROLL_TO_TOP,
                                  color: AppColors.primary),
                            ))
                        : Container();
                  },
                )
              : Container();
        });
  }

  Widget _buildDevider() {
    return Padding(
      padding: AppSize.defaultSidePadding,
      child: Divider(color: AppColors.textGrey, height: 1),
    );
  }

  Widget _buildNextPageLoadingWidget(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: AppSize.appBarHeight / 2),
        child: NextPageLoadingWdiget.build(context));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryPageProvider(),
      builder: (context, provider) {
        return BaseLayout(
            hasForm: true,
            appBar: appBarContents(context,
                text: tr('my_history'),
                isUseActionIcon: true, backKeyCallback: () {
              context.read<HistoryPageProvider>().reset();
            }),
            child: FutureBuilder(
                future: context.read<HistoryPageProvider>().init(),
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          const DefaultTitleDevider(),
                          defaultSpacing(),
                          _buildSearchCondition(context),
                          defaultSpacing(),
                          _buildResultTitle(),
                          _buildDevider(),
                          _buildResult(context),
                          _buildNextPageLoadingWidget(context)
                        ],
                      ),
                      _buildScrollToTop(context)
                    ],
                  );
                }));
      },
    );
  }
}
