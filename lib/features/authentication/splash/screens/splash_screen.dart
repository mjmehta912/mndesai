import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/authentication/login/screens/login_screen.dart';

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
      ),
      () async {
        Get.offAll(
          () => LoginScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Center(
        child: Text(
          'MN Desai',
        ),
      ),
    );
  }
}