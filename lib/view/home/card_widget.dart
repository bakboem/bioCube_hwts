/*
 * Project Name:  [HWST]
 * File: /Users/bakbeom/work/truepass/lib/view/home/card_one_widget.dart
 * Created Date: 2023-02-04 20:19:38
 * Last Modified: 2023-04-16 16:39:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hwst/enums/image_type.dart';
import 'package:hwst/enums/record_status.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/service/cache_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/view/home/camera/camera_view_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/globalProvider/face_detection_provider.dart';
import 'package:hwst/globalProvider/core_verify_process_provider.dart';

class CardWidget extends StatefulWidget {
  const CardWidget(
      {super.key, required this.cardType, required this.isOverThanIphone10});
  final String cardType;
  final bool isOverThanIphone10;
  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCard1TopColorBox(double colorBoxHeight, double cardWidth) {
    var cardType = widget.cardType;
    return Container(
      decoration: BoxDecoration(
          color:
              cardType == '1' ? AppColors.deepIconColor : AppColors.whiteText,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSize.radius15))),
      height: colorBoxHeight,
      width: cardWidth,
    );
  }

  Widget _buildMessageWidget(BuildContext context) {
    return Selector<CoreVerifyProcessProvider, Tuple3<bool?, bool?, String?>>(
      selector: (context, provider) => Tuple3(
          provider.isBleSuccess, provider.isNfcSuccess, provider.message),
      builder: (context, tuple, _) {
        var bleSuccess = tuple.item1 != null && tuple.item1!;
        var nfcSuccess = tuple.item2 != null && tuple.item2!;
        if (bleSuccess || nfcSuccess) {
          return AppText.text(tr('process_success'));
        }

        if (tuple.item3 != null) {
          return AppText.text(
              tuple.item3 == 'nfcStart' || tuple.item3 == 'bleStart'
                  ? tr('start')
                  : tuple.item3 == 'nfc passReady' ||
                          tuple.item3 == 'peripheral Ready'
                      ? tr('peripheral_ready')
                      : tuple.item3 == 'permisson_for_bidden'
                          ? tr('permisson_for_bidden')
                          : '');
        }
        return SizedBox();
      },
    );
  }

  Widget _buildCardTextContents(BuildContext context, double cardWidth) {
    var cardType = widget.cardType;
    var userCard = CacheService.getUserCard()!;
    var avataSize = AppSize.cardAvataWidth;

    return Expanded(
        child: Container(
      width: cardWidth,
      decoration: BoxDecoration(
          color: cardType == '1' ? AppColors.card1BgColor : AppColors.whiteText,
          borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(AppSize.radius15))),
      child: Column(
        children: [
          defaultSpacing(
              height: cardType == '1'
                  ? AppSize.defaultListItemSpacing * 3
                  : avataSize),
          defaultSpacing(multiple: 2),
          AppText.text(userCard.mName!, style: AppTextStyle.bold30),
          defaultSpacing(),
          AppText.text(userCard.mCoName!, style: AppTextStyle.bold_16),
          defaultSpacing(multiple: 2),
          _buildMessageWidget(context)
        ],
      ),
    ));
  }

  Widget _buildUserAvata(
      BuildContext context, double cardWidth, double cardHeight) {
    var cardType = widget.cardType;
    var userCard = CacheService.getUserCard()!;
    var avataSize = AppSize.cardAvataWidth;
    var colorBoxHeight = cardHeight * .35;
    var tempAvata = () {
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/people.png'),
                fit: BoxFit.contain),
            borderRadius: BorderRadius.circular(
                cardType == '3' ? (avataSize * 2) / 2 : AppSize.radius25)),
      );
    }();
    return Positioned(
        top: cardType == '1' ? colorBoxHeight * .3 : colorBoxHeight - avataSize,
        left: cardWidth / 2 - avataSize,
        child: Container(
            width: avataSize * 2,
            height: avataSize * 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  cardType == '3' ? (avataSize * 2) / 2 : AppSize.radius25),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: userCard.mPhoto!.replaceAll('//TruePass1.0', ''),
                progressIndicatorBuilder: (context, _, __) {
                  return tempAvata;
                },
                errorWidget: (context, e, f) {
                  return tempAvata;
                },
              ),
            )));
  }

  Widget _buildCompanyLogo(
      BuildContext context, double cardHeight, double cardWidth) {
    var cardType = widget.cardType;
    var logoWidth = cardWidth * .4;
    return Positioned(
        top: cardType == '1' ? null : AppSize.defaultListItemSpacing * 3,
        bottom: cardType == '1' ? cardHeight * .1 : null,
        left: cardWidth / 2 - logoWidth / 2,
        child: Padding(
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: logoWidth,
            child: Image.asset(ImageType.COMPANY.path),
          ),
        ));
  }

  Widget _buildDoubleBorder(double cardWidth, double cardHeight) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(AppSize.radius15)),
    );
  }

  Widget _buildCard(BuildContext context, double cardWidth, double cardHeight) {
    final cardType = widget.cardType;
    var colorBoxHeight = cardHeight * .35;
    final isNotCard2 = cardType == '1' || cardType == '3';
    final isCard1 = cardType == '1';
    return Selector<CoreVerifyProcessProvider, bool>(
        selector: (context, provider) => provider.isShowCamera,
        builder: (context, isShowCamera, _) {
          return Container(
            width: cardWidth + AppSize.elevation,
            height: cardHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isShowCamera ? Colors.black : null,
              borderRadius: isShowCamera
                  ? BorderRadius.all(Radius.circular(AppSize.radius15))
                  : null,
            ),
            margin: isNotCard2 ? EdgeInsets.all(10) : null,
            child: Card(
                shadowColor: AppColors.textGrey,
                elevation: AppSize.elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: isNotCard2
                      ? BorderRadius.all(Radius.circular(AppSize.radius15))
                      : BorderRadius.zero,
                  side: isNotCard2
                      ? isCard1
                          ? BorderSide(
                              color: AppColors.defaultText,
                              width: AppSize.card1BorderWidth)
                          : BorderSide.none
                      : BorderSide(
                          color: AppColors.textGrey,
                          width: AppSize.cardBorderWidth),
                ),
                child: isShowCamera
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSize.radius15),
                              topRight: Radius.circular(AppSize.radius15),
                              bottomRight: Radius.circular(AppSize.radius15),
                              bottomLeft: Radius.circular(AppSize.radius15),
                            ),
                            child: CameraViewPage(
                              key: Key('fromCardPage'),
                            ),
                          ),
                          // Consumer<FaceDetectionProvider>(
                          //     builder: (context, provider, _) {
                          //   return provider.faceInfo != null &&
                          //           provider.faceInfo!.isNotEmpty &&
                          //           provider.isShowFaceLine
                          //       ? CameraOverlayWidget(info: provider.faceInfo!)
                          //       : SizedBox();
                          // }),

                          Selector<FaceDetectionProvider, bool?>(
                            selector: (context, provider) =>
                                provider.isMatchSuccess,
                            builder: (context, issuccess, _) {
                              return issuccess == null || issuccess
                                  ? SizedBox()
                                  : SizedBox(
                                      width: AppSize.realWidth / 2,
                                      height: AppSize.realWidth / 2,
                                      child: AppImage.getImage(ImageType.FAILD),
                                    );
                            },
                          ),
                          Selector<FaceDetectionProvider, RecordStatus>(
                            selector: (context, provider) =>
                                provider.recordstatus,
                            builder: (context, status, _) {
                              return status == RecordStatus.WORKING
                                  ? Lottie.asset(
                                      'assets/lottie/face.json',
                                      controller: _controller
                                        ..addListener(() {
                                          if (_controller.isCompleted) {
                                            _controller.repeat();
                                          }
                                        }),
                                      onLoaded: (comp) {
                                        _controller
                                          ..duration = Duration(seconds: 5)
                                          ..forward();
                                      },
                                      options: LottieOptions(),
                                    )
                                  : SizedBox();
                            },
                          ),
                          Selector<FaceDetectionProvider, RecordStatus>(
                            selector: (context, provider) =>
                                provider.recordstatus,
                            builder: (context, suatus, _) {
                              return suatus == RecordStatus.END
                                  ? SizedBox(
                                      width: AppSize.realWidth / 2,
                                      height: AppSize.realWidth / 2,
                                      child:
                                          AppImage.getImage(ImageType.SUCCESS),
                                    )
                                  : SizedBox();
                            },
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Column(
                            children: [
                              _buildCard1TopColorBox(colorBoxHeight, cardWidth),
                              _buildCardTextContents(context, cardWidth)
                            ],
                          ),
                          _buildCompanyLogo(context, cardHeight, cardWidth),
                          _buildUserAvata(context, cardWidth, cardHeight),
                          isCard1
                              ? _buildDoubleBorder(cardWidth, cardHeight)
                              : SizedBox(),
                        ],
                      )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var cardWidth = AppSize.defaultContentsWidth * .8;
    var cardHeight = widget.isOverThanIphone10
        ? cardWidth * 1.65
        : Platform.isAndroid
            ? AppSize.realWidth > 600
                ? cardWidth * 1.4
                : cardWidth * 1.55
            : cardWidth * 1.55;
    pr(widget.cardType);
    return _buildCard(context, cardWidth, cardHeight);
  }
}
