/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/common/widget_of_top_align_logo.dart
 * Created Date: 2023-01-28 07:50:45
 * Last Modified: 2023-02-22 23:23:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';

class WidgetOfTopAlignLogo extends StatelessWidget {
  const WidgetOfTopAlignLogo({super.key, required this.subTitle});
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          ImageType.HWST.path,
          height: AppSize.defaultTextFieldHeight,
        ),
        defaultSpacing(height: AppSize.appBarHeight * 2),
        AppText.text(subTitle, style: AppTextStyle.bold_20),
        defaultSpacing(height: AppSize.appBarHeight)
      ],
    );
  }
}
