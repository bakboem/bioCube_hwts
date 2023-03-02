/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/view/common/next_page_loading_widget.dart
 * Created Date: 2022-01-24 23:26:31
 * Last Modified: 2023-03-02 19:15:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/globalProvider/next_page_loading_provider.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:provider/provider.dart';

class NextPageLoadingWdiget {
  static Widget build(BuildContext context) {
    return Consumer<NextPageLoadingProvider>(builder: (context, provider, _) {
      return provider.isShowLoading
          ? Padding(
              padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox.fromSize(
                      size: Size(20, 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: AppColors.primary,
                      ))))
          : Container();
    });
  }
}
