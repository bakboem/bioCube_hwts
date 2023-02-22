/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_animation_components.dart
 * Created Date: 2022-07-14 21:54:05
 * Last Modified: 2023-02-22 22:40:58
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:flutter/widgets.dart';
import 'package:hwst/enums/offset_direction_type.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/function_of_print.dart';

typedef AnimationCallBack = bool Function();

//        [OffsetDirectionType] 설명.
//                            |
//                       y   ++ (UP == (x=0,y++))
//                            |
//                            |
// --x ++( LEFT== x++,y=0) -------- x--  (RIGHT == (x--, y=0))----------
//                            |
//                            |
//                   y  --  (DOWN == (x=0, y--))
//                            |
//
// 애니메이션  =  이동하려는 방향의 축의 값 * animationController.value
class WidgetOfOffSetAnimationWidget extends StatefulWidget {
  const WidgetOfOffSetAnimationWidget(
      {Key? key,
      this.body,
      this.height,
      this.animationSwich,
      this.offset,
      this.controller,
      this.width,
      this.offsetType})
      : super(key: key);
  final Widget? body;
  final Offset? offset;
  final double? width;
  final double? height;
  final AnimationController? controller;
  final AnimationCallBack?
      animationSwich; // true = animationController.forward()   false = animationController.reverse()
  final OffsetDirectionType? offsetType;
  @override
  State<WidgetOfOffSetAnimationWidget> createState() =>
      _WidgetOfOffSetAnimationWidgetState();
}

class _WidgetOfOffSetAnimationWidgetState
    extends State<WidgetOfOffSetAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double? startPoint;

  @override
  void initState() {
    super.initState();
    animationController = widget.controller ??
        AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 300),
            reverseDuration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted &&
        widget.animationSwich != null &&
        widget.animationSwich!.call()) {
      pr('forward');
      animationController.forward();
    } else if (mounted &&
        widget.animationSwich != null &&
        !widget.animationSwich!.call()) {
      // log가 2번 찍히는 것은 animation 이 SetState() 를 작동 하였기 때문입니다.
      pr('reverse');
      animationController.reverse();
    }
    return Positioned(
        bottom: widget.offsetType == OffsetDirectionType.UP ||
                widget.offsetType == OffsetDirectionType.DOWN
            ? 0
            : null,
        right: widget.offsetType == OffsetDirectionType.LEFT ||
                widget.offsetType == OffsetDirectionType.RIGHT
            ? 0
            : null,
        child: AnimatedBuilder(
            animation: animationController,
            builder: (context, _) {
              return Transform.translate(
                  offset: widget.offsetType == OffsetDirectionType.UP
                      ? Offset(widget.offset!.dx,
                          widget.offset!.dy * animationController.value)
                      : widget.offsetType == OffsetDirectionType.DOWN
                          ? Offset(widget.offset!.dx,
                              -(widget.offset!.dy) * animationController.value)
                          : widget.offsetType == OffsetDirectionType.LEFT
                              ? Offset(
                                  widget.offset!.dx * animationController.value,
                                  widget.offset!.dy)
                              : Offset(
                                  -(widget.offset!.dx) *
                                      animationController.value,
                                  widget.offset!.dy),
                  child: Container(
                      height: widget.height,
                      width: widget.width ?? AppSize.realWidth,
                      decoration: widget.offsetType != OffsetDirectionType.UP &&
                              widget.offsetType != OffsetDirectionType.DOWN
                          ? BoxDecoration(
                              boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textGrey.withOpacity(0.5),
                                    blurRadius: AppSize.radius5,
                                    offset: Offset(0, -3),
                                  ),
                                ],
                              border: Border(
                                  top: BorderSide(
                                      width: .3,
                                      color: AppColors.textFieldUnfoucsColor)),
                              color: AppColors.whiteText)
                          : animationController.status ==
                                  AnimationStatus.completed
                              ? BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textGrey.withOpacity(0.5),
                                    blurRadius: AppSize.radius5,
                                    offset: Offset(0, -3),
                                  ),
                                ], color: AppColors.whiteText)
                              : BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textGrey.withOpacity(0.5),
                                    blurRadius: AppSize.radius5,
                                    offset: Offset(0, -3),
                                  ),
                                ], color: AppColors.whiteText),
                      alignment: Alignment.bottomCenter,
                      child: widget.body));
            }));
  }
}
