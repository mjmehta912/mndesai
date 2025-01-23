import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/authentication/register/controllers/register_controller.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
import 'package:mndesai/utils/formatters/text_input_formatters.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({
    super.key,
  });

  final RegisterController _controller = Get.put(
    RegisterController(),
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
            resizeToAvoidBottomInset: true,
            body: Center(
              child: SingleChildScrollView(
                padding: AppPaddings.ph30,
                child: Form(
                  key: _controller.registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create account',
                        style: TextStyles.kSemiBoldDMSans(
                          color: kColorTextPrimary,
                          fontSize: FontSizes.k36FontSize,
                        ),
                      ),
                      AppSpaces.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 0.4.screenWidth,
                            child: AppTextFormField(
                              controller: _controller.firstNameController,
                              hintText: 'First Name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              inputFormatters: [
                                TitleCaseTextInputFormatter(),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 0.4.screenWidth,
                            child: AppTextFormField(
                              controller: _controller.lastNameController,
                              hintText: 'Last Name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              inputFormatters: [
                                TitleCaseTextInputFormatter(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSpaces.v20,
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
                      AppSpaces.v20,
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
                          isObscure: _controller.obscuredNewPassword.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _controller.toggleNewPasswordVisibility();
                            },
                            icon: Icon(
                              _controller.obscuredNewPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      AppSpaces.v20,
                      Obx(
                        () => AppTextFormField(
                          controller: _controller.confirmPasswordController,
                          hintText: 'Confirm Password',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _controller.passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          isObscure: _controller.obscuredConfirmPassword.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _controller.toggleConfirmPasswordVisibility();
                            },
                            icon: Icon(
                              _controller.obscuredConfirmPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      AppSpaces.v40,
                      AppButton(
                        title: 'Register',
                        onPressed: () {
                          _controller.hasAttemptedSubmit.value = true;
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_controller.registerFormKey.currentState!
                              .validate()) {}
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
