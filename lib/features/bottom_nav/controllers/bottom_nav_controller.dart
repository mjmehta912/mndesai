import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/bottom_nav/repositories/bottom_navigation_repo.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/helpers/version_info_helper.dart';

class BottomNavController extends GetxController {
  var isLoading = false.obs;
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> checkAppVersion() async {
    isLoading.value = true;
    try {
      String? version = await VersionService.getVersion();
      var result = await BottomNavigationRepo.getVersion(
        version: version,
      );

      if (result is List && result.isEmpty) {
        return;
      }
    } catch (e) {
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
        ),
        barrierDismissible: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
