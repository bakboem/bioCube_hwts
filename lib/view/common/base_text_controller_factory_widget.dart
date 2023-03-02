/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/text_controller_factory.dart
 * Created Date: 2022-09-06 18:26:48
 * Last Modified: 2023-01-26 18:42:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 							 					Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

typedef TextEditHookWidget = Widget Function(TextEditingController, FocusNode);

class BaseTextControllerFactoryWidget extends StatefulWidget {
  const BaseTextControllerFactoryWidget(
      {required this.textEditHookWidget, Key? key})
      : super(key: key);
  final TextEditHookWidget? textEditHookWidget;

  @override
  State<BaseTextControllerFactoryWidget> createState() =>
      _BaseTextControllerFactoryWidgetState();
}

class _BaseTextControllerFactoryWidgetState
    extends State<BaseTextControllerFactoryWidget> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.textEditHookWidget!(textEditingController, focusNode);
  }
}
