/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_rotation_animation_components.dart
 * Created Date: 2022-07-14 23:02:16
 * Last Modified: 2023-01-26 18:42:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

typedef AnimationCallBack = bool Function();

class WidgetOfRotationAnimationComponents extends StatefulWidget {
  const WidgetOfRotationAnimationComponents(
      {Key? key, this.animationSwich, this.body, this.rotationValue})
      : super(key: key);
  final AnimationCallBack? animationSwich;
  final Widget? body;
  final double? rotationValue;
  @override
  State<WidgetOfRotationAnimationComponents> createState() =>
      _WidgetOfRotationAnimationComponentsState();
}

class _WidgetOfRotationAnimationComponentsState
    extends State<WidgetOfRotationAnimationComponents>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isStartTrain = false;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted && widget.animationSwich!.call()) {
      _animationController.forward();
    } else if (mounted && !widget.animationSwich!.call()) {
      _animationController.reverse();
    }
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Transform.rotate(
              angle: widget.rotationValue! * _animationController.value,
              child: widget.body);
        });
  }
}
