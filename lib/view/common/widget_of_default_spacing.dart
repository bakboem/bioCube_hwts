/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_default_spacing.dart
 * Created Date: 2022-07-03 14:18:03
 * Last Modified: 2023-02-22 22:40:56
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:hwst/styles/app_size.dart';

Widget defaultSpacing({double? height, int? multiple, bool? isHalf}) => Padding(
    padding: EdgeInsets.only(
        top: height != null
            ? height
            : multiple != null
                ? AppSize.defaultListItemSpacing * multiple
                : isHalf != null && isHalf
                    ? AppSize.defaultListItemSpacing / 2
                    : AppSize.defaultListItemSpacing));
