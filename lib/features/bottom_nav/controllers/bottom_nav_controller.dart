import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/authentication/login/screens/login_screen.dart';
import 'package:mndesai/features/bottom_nav/repositories/bottom_navigation_repo.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/helpers/device_helper.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';
import 'package:mndesai/utils/helpers/version_info_helper.dart';

class BottomNavController extends GetxController {
  var isLoading = false.obs;
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> checkAppVersion() async {
    isLoading.value = true;
    String? deviceId = await DeviceHelper().getDeviceId();

    if (deviceId == null) {
      showErrorSnackbar('Login Failed', 'Unable to fetch device ID.');
      isLoading.value = false;
      return;
    }

    try {
      String? version = await VersionService.getVersion();

      var result = await BottomNavigationRepo.getVersion(
        version: version,
        deviceId: deviceId,
      );

      if (result is List && result.isEmpty) {
        return;
      }
    } catch (e) {
      if (e
          .toString()
          .contains('Please update your app with latest version.')) {
        Get.dialog(
          AlertDialog(
            title: Text(
              'Update Required',
              style: TextStyles.kBoldDMSans(
                fontSize: FontSizes.k20FontSize,
              ),
            ),
            content: Text(
              e.toString(),
              style: TextStyles.kRegularDMSans(
                fontSize: FontSizes.k16FontSize,
              ),
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       Get.back();
            //     },
            //     child: Text('Update Now'),
            //   ),
            // ],
          ),
          barrierDismissible: false,
        );
      } else if (e.toString().contains('Please login again.')) {
        // 403 - Show login again dialog and logout
        Get.dialog(
          AlertDialog(
            title: Text(
              'Session Expired',
              style: TextStyles.kBoldDMSans(
                fontSize: FontSizes.k20FontSize,
              ),
            ),
            content: Text(
              e.toString(),
              style: TextStyles.kRegularDMSans(
                fontSize: FontSizes.k16FontSize,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  logoutUser();
                },
                child: Text(
                  'Login Again',
                ),
              ),
            ],
          ),
          barrierDismissible: false,
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

  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      await SecureStorageHelper.clearAll();

      Get.offAll(
        () => LoginScreen(),
      );

      showSuccessSnackbar(
        'Logged Out',
        'You have been successfully logged out.',
      );
    } catch (e) {
      showErrorSnackbar(
        'Logout Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
