import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/features/point_calculation/repositories/points_calculation_repo.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';

class PointsCalculationController extends GetxController {
  var isLoading = false.obs;

  final Rx<CardInfoDm?> cardInfo = Rx<CardInfoDm?>(null);

  var isCardNoFieldVisible = true.obs;
  void toggleCardVisibility() {
    isCardNoFieldVisible.value = !isCardNoFieldVisible.value;
  }

  var cardNoController = TextEditingController();

  Future<void> getCardInfo() async {
    isLoading.value = false;
    try {
      final fetchedCardInfo = await PointsCalculationRepo.getCardInfo(
        cardNo: cardNoController.text.trim(),
      );

      cardInfo.value = fetchedCardInfo;
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
