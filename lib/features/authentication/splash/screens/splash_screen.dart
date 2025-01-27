import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/authentication/login/screens/login_screen.dart';
import 'package:mndesai/features/bottom_nav/screens/bottom_nav_screen.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
        const Duration(
          seconds: 3,
        ), () async {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Future.delayed(
        const Duration(
          seconds: 1,
        ),
        () {
          if (token != null && token.isNotEmpty) {
            Get.offAll(
              () => BottomNavScreen(),
            );
          } else {
            Get.offAll(
              () => LoginScreen(),
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPrimary,
      body: Center(
        child: Text(
          'M N DESAI',
          style: TextStyles.kBoldDMSans(
            color: kColorWhite,
            fontSize: FontSizes.k36FontSize,
          ),
        ),
      ),
    );
  }
}
