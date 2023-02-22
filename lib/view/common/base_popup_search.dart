/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/base_popup_search.dart
 * Created Date: 2021-09-11 00:27:49
 * Last Modified: 2023-02-22 22:42:53
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 *                        Discription                         
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/enums/popup_list_type.dart';
import 'package:hwst/enums/popup_search_type.dart';
import 'package:hwst/view/common/base_shimmer.dart';
import 'package:hwst/view/common/base_app_dialog.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/common/widget_of_next_page_loading.dart';
import 'package:hwst/globalProvider/next_page_loading_provider.dart';
import 'package:hwst/view/common/provider/base_popup_search_provider.dart';

class BasePopupSearch {
  final PopupSearchType? type;
  final Map<String, dynamic>? bodyMap;
  BasePopupSearch({required this.type, this.bodyMap});

  Future<dynamic> show(BuildContext context) async {
    final result = await AppDialog.showPopup(
        context, PopupSearchOneRowContents(type!, bodyMap: bodyMap));
    if (result != null) return result;
  }
}

Widget shimmer() {
  return Padding(
      padding: EdgeInsets.all(AppSize.padding),
      child: Column(
        children: List.generate(
            6,
            (index) => Container(
                  child: BaseShimmer.shimmerBox(
                      AppTextStyle.default_16.fontSize!,
                      AppSize.updatePopupWidth - AppSize.padding * 2),
                )).toList(),
      ));
}

class PopupSearchOneRowContents extends StatefulWidget {
  PopupSearchOneRowContents(
    this.type, {
    Key? key,
    this.bodyMap,
  }) : super(key: key);
  final PopupSearchType type;
  final Map<String, dynamic>? bodyMap;
  @override
  _PopupSearchOneRowContentsState createState() =>
      _PopupSearchOneRowContentsState();
}

class _PopupSearchOneRowContentsState extends State<PopupSearchOneRowContents> {
  late ScrollController _scrollController;
  late FocusNode _metaGroupFocus;
  late FocusNode _metaNameFocus;
  @override
  void initState() {
    super.initState();
    _metaGroupFocus = FocusNode();
    _metaNameFocus = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _metaGroupFocus.dispose();
    _metaNameFocus.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildContentsView(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();
    if (p.isFirestRun) {
      pr('dododo');
      p.onSearch(widget.type.popupStrListType[0], false,
          bodyMaps: widget.bodyMap);
    }
    switch (widget.type) {
      default:
        return Container();
    }
  }

  // Widget _buildLoadingWidget(BuildContext context, bool isLoadData) {
  //   final p = context.read<BasePopupSearchProvider>();
  //   return isLoadData
  //       ? Container(
  //           height: widget.type.height -
  //               AppSize.buttonHeight -
  //               widget.type.appBarHeight,
  //           child: Padding(
  //             padding: AppSize.defaultSidePadding,
  //             child: DefaultShimmer.buildDefaultPopupShimmer(),
  //           ),
  //         )
  //       : Container(
  //           child: Center(
  //             child: AppText.listViewText(
  //                 p.isShhowNotResultText == null ? '' : tr('not data find')),
  //           ),
  //         );
  // }

  Widget _buildSearchBar(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BasePopupSearchProvider()),
        ChangeNotifierProvider(create: (context) => NextPageLoadingProvider()),
      ],
      builder: (context, _) {
        pr('build page');
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
          width: AppSize.updatePopupWidth,
          height: widget.type.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSearchBar(context),
                  Expanded(child: _buildContentsView(context))
                ],
              ),
              Positioned(
                  left: 0,
                  bottom: AppSize.buttonHeight / 2,
                  child: Container(
                      width: AppSize.defaultContentsWidth,
                      child: Padding(
                          padding:
                              EdgeInsets.only(bottom: AppSize.appBarHeight / 2),
                          child: NextPageLoadingWdiget.build(context)))),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppSize.radius15),
                            bottomRight: Radius.circular(AppSize.radius15)),
                        child: Container(
                            alignment: Alignment.center,
                            width: AppSize.defaultContentsWidth,
                            height: AppSize.buttonHeight,
                            decoration: BoxDecoration(
                                color: AppColors.whiteText,
                                border: Border(
                                    top: BorderSide(
                                        color: AppColors.tableBorderColor,
                                        width: AppSize.defaultBorderWidth))),
                            child: AppText.text(
                              widget.type.popupStrListType.first.buttonText,
                              style: AppTextStyle.default_16
                                  .copyWith(color: AppColors.primary),
                            ))),
                  ))
            ],
          ),
        );
      },
    );
  }
}
