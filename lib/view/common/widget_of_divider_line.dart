/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_divider_line.dart
 * Created Date: 2022-07-02 14:22:53
 * Last Modified: 2023-02-22 22:40:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:hwst/styles/app_colors.dart';
import 'package:hwst/styles/app_size.dart';

class DefaultTitleDevider extends StatelessWidget {
  const DefaultTitleDevider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: AppSize.defaultLineHeight,
      width: AppSize.realWidth,
      color: AppColors.homeBgColor,
    );
  }
}
