import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/authentication/otp/controllers/otp_controller.dart';
import 'package:mndesai/features/authentication/reset_password/screens/reset_password_screen.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_button.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({
    super.key,
    required this.mobileNumber,
  });

  final String mobileNumber;

  final OtpController _controller = Get.put(
    OtpController(),
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
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                padding: AppPaddings.ph30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP Verification',
                      style: TextStyles.kRegularDMSans(
                        color: kColorTextPrimary,
                        fontSize: FontSizes.k40FontSize,
                      ),
                    ),
                    Text(
                      'Enter the 6-digit OTP sent to your mobile number.',
                      style: TextStyles.kRegularDMSans(
                        color: kColorGrey,
                        fontSize: FontSizes.k16FontSize,
                      ).copyWith(
                        height: 1.25,
                      ),
                    ),
                    AppSpaces.v30,
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _controller.otpController,
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
                    AppSpaces.v30,
                    AppButton(
                      title: 'Verify OTP',
                      buttonColor: kColorPrimary,
                      onPressed: () {
                        _controller.hasAttemptedSubmit.value = true;
                        if (_controller.otpController.text.length < 6) {
                          showErrorSnackbar(
                            'Invalid',
                            'Please enter a 6-digit OTP',
                          );
                        } else {
                          Get.offAll(
                            () => ResetPasswordScreen(
                              mobileNumber: mobileNumber,
                            ),
                          );
                        }
                      },
                    ),
                    AppSpaces.v30,
                    Center(
                      child: Obx(
                        () {
                          return AppTextButton(
                            onPressed: () {},
                            title: _controller.resendEnabled.value
                                ? 'Resend OTP'
                                : 'Resend in ${_controller.timerValue.value}s',
                            style: TextStyles.kRegularDMSans(
                              fontSize: FontSizes.k16FontSize,
                              color: _controller.resendEnabled.value
                                  ? kColorPrimary
                                  : kColorGrey,
                            ).copyWith(
                              height: 1,
                              decoration: TextDecoration.underline,
                              decorationColor: kColorPrimary,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
