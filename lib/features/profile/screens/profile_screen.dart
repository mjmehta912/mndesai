import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/profile/controllers/profile_controller.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
  });

  final ProfileController _controller = Get.put(
    ProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Services',
      ),
      body: Padding(
        padding: AppPaddings.p14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Obx(
                    () => Text(
                      'Welcome, ${_controller.fullName}',
                      style: TextStyles.kMediumDMSans(),
                    ),
                  ),
                ],
              ),
            ),
            AppSpaces.v10,
            AppButton(
              title: 'Sign Out',
              onPressed: () {
                _controller.logoutUser();
              },
            ),
            AppSpaces.v20,
          ],
        ),
      ),
    );
  }
}
