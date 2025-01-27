import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/authentication/login/repositories/login_repo.dart';
import 'package:mndesai/features/bottom_nav/screens/bottom_nav_screen.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/helpers/device_helper.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

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

  Future<void> loginUser() async {
    isLoading.value = true;
    String? deviceId = await DeviceHelper().getDeviceId();
    if (deviceId == null) {
      showErrorSnackbar(
        'Login Failed',
        'Unable to fetch device ID.',
      );
      isLoading.value = false;
      return;
    }

    try {
      var response = await LoginRepo.loginUser(
        mobileNo: mobileNumberController.text,
        password: passwordController.text,
        fcmToken: '',
        deviceId: deviceId,
      );

      await SecureStorageHelper.write(
        'token',
        response['token'],
      );
      await SecureStorageHelper.write(
        'fullName',
        response['fullName'],
      );

      await SecureStorageHelper.write(
        'userType',
        response['userType'].toString(),
      );

      await SecureStorageHelper.write(
        'userId',
        response['userId'].toString(),
      );

      Get.offAll(
        () => BottomNavScreen(),
      );
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar(
          'Error',
          e['message'],
        );
      } else {
        showErrorSnackbar(
          'Error',
          e.toString(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
