import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/bill_entry/repositories/bill_entry_repo.dart';
import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/features/point_calculation/models/product_dm.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';

class BillEntryController extends GetxController {
  var isLoading = false.obs;
  final billEntryFormKey = GlobalKey<FormState>();

  var products = <ProductDm>[].obs;
  var productNames = <String>[].obs;
  var addedProducts = <Map<String, dynamic>>[].obs;

  var customerNameController = TextEditingController();
  var vehicleNoController = TextEditingController();
  var remarkController = TextEditingController();
  var srNoController = TextEditingController();
  var dateController = TextEditingController();
  var selectedProduct = ''.obs;
  var selectedProductCode = ''.obs;
  var selectedProductShortName = ''.obs;
  var selectedProductRate = 0.0.obs;
  var qtyController = TextEditingController();
  var rateController = TextEditingController();
  var amountController = TextEditingController();

  var cardNoController = TextEditingController();
  final Rx<CardInfoDm?> cardInfo = Rx<CardInfoDm?>(null);

  var isCardSelected = false.obs;
  var isCardNoFieldVisible = true.obs;
  void toggleCardVisibility() {
    isCardNoFieldVisible.value = !isCardNoFieldVisible.value;
  }

  Future<void> getProducts() async {
    try {
      isLoading.value = true;

      final fetchedProducts = await BillEntryRepo.getProducts();

      products.assignAll(fetchedProducts);
      productNames.assignAll(
        fetchedProducts.map(
          (product) => product.iName,
        ),
      );
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onProductSelected(String productName) {
    selectedProduct.value = productName;

    final productObj = products.firstWhere(
      (product) => product.iName == productName,
    );

    selectedProductCode.value = productObj.iCode;
    selectedProductShortName.value = productObj.shortName;
    if (productObj.rate != null) {
      selectedProductRate.value = productObj.rate!;
    } else {
      selectedProductRate.value = 0.0;
    }

    rateController.text = selectedProductRate.value.toString();
  }

  Future<void> getCardInfo() async {
    isLoading.value = true;
    try {
      final fetchedCardInfo = await BillEntryRepo.getCardInfo(
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
