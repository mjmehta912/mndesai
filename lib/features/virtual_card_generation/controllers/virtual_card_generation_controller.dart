import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualCardGenerationController extends GetxController {
  var isLoading = false.obs;
  final virtualCardFenerationFormKey = GlobalKey<FormState>();

  var mobileNoController = TextEditingController();
  var nameController = TextEditingController();
  var birthDateController = TextEditingController();
  var salesmanController = TextEditingController();
  var availableCardNoController = TextEditingController();
  var cardIssueDateController = TextEditingController();
  var selectedRefCardNo = ''.obs;
}
