import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mndesai/features/virtual_card_generation/models/card_no_dm.dart';
import 'package:mndesai/features/virtual_card_generation/repositories/virtual_card_generation_repo.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';

class VirtualCardGenerationController extends GetxController {
  var isLoading = false.obs;
  final virtualCardFenerationFormKey = GlobalKey<FormState>();

  final Rx<CardNoDm?> cardData = Rx<CardNoDm?>(null);

  var mobileNoController = TextEditingController();
  var nameController = TextEditingController();
  var birthDateController = TextEditingController();
  var availableCardNoController = TextEditingController();
  var cardIssueDateController = TextEditingController();
  var refCardNoController = TextEditingController();

  Future<void> getCardNo() async {
    isLoading.value = false;
    try {
      final fetchedCardData = await VirtualCardGenerationRepo.getCardNo();

      cardData.value = fetchedCardData;
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateVirtualCard() async {
    isLoading.value = true;

    try {
      var response = await VirtualCardGenerationRepo.generateVirtualCard(
        mobileNo: mobileNoController.text,
        name: nameController.text.isNotEmpty ? nameController.text : '',
        cardNo: availableCardNoController.text,
        refCardNo:
            refCardNoController.text.isNotEmpty ? refCardNoController.text : '',
        dob: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(
            birthDateController.text,
          ),
        ),
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        showSuccessSnackbar(
          'Success',
          message,
        );
      }
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
