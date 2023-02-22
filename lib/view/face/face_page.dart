/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/face/face_page.dart
 * Created Date: 2023-01-29 19:05:11
 * Last Modified: 2023-02-22 22:44:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';
import 'package:hwst/view/common/widget_of_divider_line.dart';

class FacePage extends StatefulWidget {
  const FacePage({super.key});
  static final String routeName = '/FacePage';
  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: false,
        appBar: appBarContents(context,
            text: tr('face_recognition'), isUseActionIcon: true),
        child: Column(
          children: [const DefaultTitleDevider()],
        ));
  }
}
