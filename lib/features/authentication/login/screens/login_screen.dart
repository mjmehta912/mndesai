import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/authentication/forgot_password/screens/forgot_password_screen.dart';
import 'package:mndesai/features/authentication/login/controllers/login_controller.dart';
import 'package:mndesai/features/authentication/register/screens/register_screen.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/formatters/text_input_formatters.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_button.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });

  final LoginController _controller = Get.put(
    LoginController(),
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
            resizeToAvoidBottomInset: true,
            backgroundColor: kColorWhite,
            body: Center(
              child: SingleChildScrollView(
                padding: AppPaddings.ph30,
                child: Form(
                  key: _controller.loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Let \'s sign you in',
                        style: TextStyles.kRegularDMSans(
                          fontSize: FontSizes.k36FontSize,
                        ),
                      ),
                      AppSpaces.v30,
                      AppTextFormField(
                        controller: _controller.mobileNumberController,
                        hintText: 'Mobile Number',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a mobile number';
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
                      AppSpaces.v16,
                      Obx(
                        () => AppTextFormField(
                          controller: _controller.passwordController,
                          hintText: 'Password',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          isObscure: _controller.obscuredText.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _controller.togglePasswordVisibility();
                            },
                            icon: Icon(
                              _controller.obscuredText.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppTextButton(
                            onPressed: () {
                              Get.to(
                                () => ForgotPasswordScreen(),
                              );
                            },
                            title: 'Forgot Password?',
                            style: TextStyles.kRegularDMSans(
                              color: kColorPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1,
                              decoration: TextDecoration.underline,
                              decorationColor: kColorPrimary,
                            ),
                          ),
                        ],
                      ),
                      AppSpaces.v30,
                      AppButton(
                        title: 'Sign In',
                        onPressed: () {
                          _controller.hasAttemptedLogin.value = true;
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_controller.loginFormKey.currentState!
                              .validate()) {
                            _controller.loginUser();
                          }
                        },
                      ),
                      AppSpaces.v30,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyles.kRegularDMSans(
                              fontSize: FontSizes.k16FontSize,
                            ),
                          ),
                          AppSpaces.h10,
                          AppTextButton(
                            onPressed: () {
                              Get.to(
                                () => RegisterScreen(),
                              );
                            },
                            title: 'Register',
                            style: TextStyles.kRegularDMSans(
                              color: kColorPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1,
                              decoration: TextDecoration.underline,
                              decorationColor: kColorPrimary,
                            ),
                          ),
                        ],
                      )
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
