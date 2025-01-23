import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  var isLoading = false.obs;

  final TextEditingController otpController = TextEditingController();

  var hasAttemptedSubmit = false.obs;

  var resendEnabled = false.obs;
  var timerValue = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    startResendTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startResendTimer() {
    resendEnabled.value = false;
    timerValue.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) {
        if (timerValue.value > 0) {
          timerValue.value--;
        } else {
          resendEnabled.value = true;
          timer.cancel();
        }
      },
    );
  }
}
