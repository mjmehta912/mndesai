import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/point_calculation/controllers/points_calculation_controller.dart.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';

class PointsCalculationCard extends StatelessWidget {
  const PointsCalculationCard({
    super.key,
    required PointsCalculationController controller,
  }) : _controller = controller;

  final PointsCalculationController _controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          kImageBlankCard,
          fit: BoxFit.cover,
        ),
        Positioned(
          left: 15,
          top: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Points Balance',
                style: TextStyles.kRegularDMSans(
                  fontSize: FontSizes.k14FontSize,
                  color: kColorWhite,
                ),
              ),
              Obx(
                () => Text(
                  _controller.cardInfo.value != null
                      ? _controller.cardInfo.value!.balance != null
                          ? _controller.cardInfo.value!.balance.toString()
                          : '0.0'
                      : '0.0',
                  style: TextStyles.kBoldDMSans(
                    color: kColorWhite,
                    fontSize: FontSizes.k22FontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => Text(
                  'Serial #  ${_controller.cardInfo.value != null ? _controller.cardInfo.value!.pcSrNo : ''}',
                  style: TextStyles.kRegularDMSans(
                    fontSize: FontSizes.k14FontSize,
                    color: kColorWhite,
                  ),
                ),
              ),
              Obx(
                () => Text(
                  'Card #  ${_controller.cardInfo.value != null ? _controller.cardInfo.value!.cardNo : ''}',
                  style: TextStyles.kRegularDMSans(
                    fontSize: FontSizes.k14FontSize,
                    color: kColorWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 15,
          bottom: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card Type',
                style: TextStyles.kRegularDMSans(
                  color: kColorWhite,
                  fontSize: FontSizes.k16FontSize,
                ),
              ),
              Obx(
                () => Text(
                  _controller.cardInfo.value != null
                      ? _controller.cardInfo.value!.cardType
                      : '',
                  style: TextStyles.kSemiBoldDMSans(
                    color: kColorWhite,
                    fontSize: FontSizes.k18FontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          bottom: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(
                  DateTime.now(),
                ),
                style: TextStyles.kBoldDMSans(
                  color: kColorWhite,
                  fontSize: FontSizes.k18FontSize,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(
                  DateTime.now(),
                ),
                style: TextStyles.kMediumDMSans(
                  color: kColorWhite,
                  fontSize: FontSizes.k16FontSize,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 15,
          right: 0,
          top: 0,
          bottom: 0,
          child: Obx(
            () => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _controller.cardInfo.value != null
                    ? _controller.cardInfo.value!.member
                    : '',
                style: TextStyles.kBoldSofiaSansSemiCondensed(
                  color: kColorWhite,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
