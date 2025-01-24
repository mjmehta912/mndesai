import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  var mobileNumberController = TextEditingController();
  var passwordController = TextEditingController();

  var hasAttemptedLogin = false.obs;

  var obscuredText = true.obs;
  void togglePasswordVisibility() {
    obscuredText.value = !obscuredText.value;
  }

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    mobileNumberController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedLogin.value) {
      loginFormKey.currentState?.validate();
    }
  }
}
