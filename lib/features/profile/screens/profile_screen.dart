import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/authentication/reset_password/screens/reset_password_screen.dart';
import 'package:mndesai/features/profile/controllers/profile_controller.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/helpers/version_info_helper.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      'Welcome, ${_controller.fullName.value}',
                      style: TextStyles.kMediumDMSans(),
                    ),
                  ),
                  AppSpaces.v20,
                  ListTile(
                    title: Text(
                      'Reset Password',
                      style: TextStyles.kRegularDMSans(
                        fontSize: FontSizes.k22FontSize,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 25,
                      color: kColorTextPrimary,
                    ),
                    onTap: () {
                      Get.to(
                        ResetPasswordScreen(
                          mobileNumber: _controller.mobileNumber.value,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            AppButton(
              title: 'Sign Out',
              onPressed: () {
                _controller.logoutUser();
              },
            ),
            AppSpaces.v10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyles.kRegularDMSans(
                      fontSize: FontSizes.k16FontSize,
                      color: kColorTextPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: "Developed by ",
                      ),
                      TextSpan(
                        text: "Jinee Infotech",
                        style: TextStyles.kRegularDMSans(
                          fontSize: FontSizes.k16FontSize,
                          color: kColorPrimary,
                        ).copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: kColorPrimary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri url = Uri.parse(
                              "https://jinee.in/Default.aspx",
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                      ),
                      TextSpan(text: "  |  "),
                      WidgetSpan(
                        child: FutureBuilder<String>(
                          future: VersionService.getVersion(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "v...",
                                style: TextStyles.kRegularDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                  color: kColorBlack,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "vError",
                                style: TextStyles.kRegularDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                  color: kColorRed,
                                ),
                              );
                            } else {
                              return Text(
                                "v${snapshot.data}",
                                style: TextStyles.kRegularDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                  color: kColorBlack,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpaces.v20,
          ],
        ),
      ),
    );
  }
}
