import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/point_calculation/controllers/points_calculation_controller.dart.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PointsCalculationScreen extends StatelessWidget {
  PointsCalculationScreen({
    super.key,
  });

  final PointsCalculationController _controller = Get.put(
    PointsCalculationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Points Calculation',
            ),
            body: Padding(
              padding: AppPaddings.p14,
              child: Obx(
                () {
                  if (_controller.isCardNoFieldVisible.value) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Number',
                          style: TextStyles.kRegularDMSans(
                            fontSize: FontSizes.k36FontSize,
                          ),
                        ),
                        AppSpaces.v20,
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: _controller.cardNoController,
                          keyboardType: TextInputType.number,
                          textStyle: TextStyles.kRegularDMSans(
                            fontSize: FontSizes.k20FontSize,
                            color: kColorTextPrimary,
                          ),
                          cursorColor: kColorTextPrimary,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: kColorLightGrey,
                            activeColor: kColorTextPrimary,
                            inactiveColor: kColorLightGrey,
                            selectedColor: kColorTextPrimary,
                          ),
                          validator: (_) => null,
                        ),
                        AppSpaces.v20,
                        AppButton(
                          title: 'Continue',
                          onPressed: () async {
                            if (_controller.cardNoController.text.length < 6) {
                              showErrorSnackbar(
                                'Invalid',
                                'Please enter a card no.',
                              );
                            } else {
                              await _controller.getCardInfo();
                              _controller.toggleCardVisibility();
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [kColorPrimary, Colors.purpleAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
