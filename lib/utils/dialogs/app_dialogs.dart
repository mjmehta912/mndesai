import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_button.dart';

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
    margin: AppPaddings.p10,
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

void showAlertSnackbar(
  String title,
  String message,
) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.yellow,
    duration: const Duration(
      seconds: 5,
    ),
    margin: AppPaddings.p10,
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
        color: kColorTextPrimary,
        fontSize: FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDMSans(
        fontSize: FontSizes.k16FontSize,
        color: kColorTextPrimary,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDMSans(
          color: kColorTextPrimary,
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
    backgroundColor: kColorBlue,
    duration: const Duration(
      seconds: 3,
    ),
    margin: AppPaddings.p10,
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

void showSuccessDialog(
  BuildContext context,
  String message,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: kColorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: AppPaddings.p10,
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                kSuccessLottieGif,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text(
                message,
                style: TextStyles.kMediumDMSans(
                  color: kColorTextPrimary,
                ).copyWith(
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpaces.v10,
              AppButton(
                onPressed: () {
                  Get.back();
                },
                title: '  OK',
              ),
            ],
          ),
        ),
      );
    },
  );
}
