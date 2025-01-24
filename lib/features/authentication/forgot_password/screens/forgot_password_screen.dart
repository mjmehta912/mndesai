import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/authentication/forgot_password/controllers/forgot_password_controller.dart';
import 'package:mndesai/features/authentication/otp/screens/otp_screen.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/formatters/text_input_formatters.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({
    super.key,
  });

  final ForgotPasswordController _controller = Get.put(
    ForgotPasswordController(),
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
                child: Form(
                  key: _controller.forgotPasswordFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forgot Password',
                        style: TextStyles.kRegularDMSans(
                          color: kColorTextPrimary,
                          fontSize: FontSizes.k40FontSize,
                        ),
                      ),
                      Text(
                        'Please enter your 10-digit mobile number to get an OTP.',
                        style: TextStyles.kRegularDMSans(
                          color: kColorGrey,
                          fontSize: FontSizes.k16FontSize,
                        ).copyWith(
                          height: 1.25,
                        ),
                      ),
                      AppSpaces.v30,
                      AppTextFormField(
                        controller: _controller.mobileNumberController,
                        hintText: 'Mobile Number',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (value.length != 10) {
                            return 'Please enter a 10-digit mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MobileNumberInputFormatter(),
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      AppSpaces.v30,
                      AppButton(
                        title: 'Get OTP',
                        onPressed: () {
                          _controller.hasAttemptedSubmit.value = true;
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_controller.forgotPasswordFormKey.currentState!
                              .validate()) {
                            Get.to(
                              () => OtpScreen(
                                mobileNumber:
                                    _controller.mobileNumberController.text,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
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
