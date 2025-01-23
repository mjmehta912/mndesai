import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';

void showErrorSnackbar(
  String title,
  String message,
) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: kColorRed,
    duration: const Duration(
      seconds: 3,
    ),
    margin: const EdgeInsets.all(10),
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(
      milliseconds: 750,
    ),
    titleText: Text(
      title,
      style: TextStyles.kMediumDMSans(
        color: kColorWhite,
        fontSize: FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDMSans(
        fontSize: FontSizes.k16FontSize,
        color: kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDMSans(
          color: kColorWhite,
          fontSize: FontSizes.k24FontSize,
        ),
      ),
    ),
  );
}

void showSuccessSnackbar(
  String title,
  String message,
) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: kColorGrey,
    duration: const Duration(
      seconds: 3,
    ),
    margin: const EdgeInsets.all(10),
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(
      milliseconds: 750,
    ),
    titleText: Text(
      title,
      style: TextStyles.kMediumDMSans(
        color: kColorWhite,
        fontSize: FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDMSans(
        fontSize: FontSizes.k16FontSize,
        color: kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDMSans(
          color: kColorWhite,
          fontSize: FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}
