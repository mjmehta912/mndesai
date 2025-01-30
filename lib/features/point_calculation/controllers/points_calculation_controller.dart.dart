import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/features/point_calculation/models/product_dm.dart';
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
  var products = <ProductDm>[].obs;
  var productNames = <String>[].obs;
  var selectedProduct = ''.obs;
  var selectedProductCode = ''.obs;
  var selectedProductShortName = ''.obs;
  var selectedProductRate = 0.0.obs;
  var qtyController = TextEditingController();
  var rateController = TextEditingController();
  var amountController = TextEditingController();

  var addedProducts = <Map<String, dynamic>>[].obs;

  double get totalAmount {
    return addedProducts.fold(
        0.0, (sum, product) => sum + (product['AMOUNT'] as double));
  }

  void addProduct() {
    final srNo = addedProducts.length + 1;
    final product = {
      "SRNO": srNo,
      "ICODE": selectedProductCode.value,
      "PRODUCT_NAME": selectedProduct.value,
      "QTY": double.tryParse(qtyController.text) ?? 0.0,
      "RATE": double.tryParse(rateController.text) ?? 0.0,
      "AMOUNT": double.tryParse(amountController.text) ?? 0.0,
    };
    addedProducts.add(product);

    selectedProduct.value = '';
    selectedProductCode.value = '';
    selectedProductShortName.value = '';
    selectedProductRate.value = 0.0;
    qtyController.clear();
    rateController.clear();
    amountController.clear();
  }

  void deleteProduct(int index) {
    addedProducts.removeAt(index);

    for (var i = index; i < addedProducts.length; i++) {
      addedProducts[i]["SRNO"] = i + 1;
    }
  }

  Future<void> getCardInfo() async {
    isLoading.value = true;
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

  Future<void> getProducts() async {
    try {
      isLoading.value = true;

      final fetchedProducts = await PointsCalculationRepo.getProducts();

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
      qtyController.clear();
      amountController.clear();
      selectedProductRate.value = productObj.rate!;
    } else {
      selectedProductRate.value = 0.0;
    }

    rateController.text = selectedProductRate.value.toString();
  }

  Future<void> savePointsEntry() async {
    isLoading.value = true;

    try {
      List<Map<String, dynamic>> itemsToSend = addedProducts.map(
        (product) {
          return {
            "SRNO": product["SRNO"],
            "ICODE": product["ICODE"],
            "QTY": product["QTY"],
            "RATE": product["RATE"],
          };
        },
      ).toList();

      var response = await PointsCalculationRepo.savePointsEntry(
        type: 'P',
        pCode: cardInfo.value != null ? cardInfo.value!.pCode : '',
        amount: totalAmount,
        vehicleNo: '',
        cardNo: cardInfo.value != null ? cardInfo.value!.cardNo.toString() : '',
        typeCode: cardInfo.value != null ? cardInfo.value!.typeCode : '',
        items: itemsToSend,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        showSuccessDialog(
          Get.context!,
          message,
        );

        cardNoController.clear();
        addedProducts.clear();
        cardInfo.value = null;
        toggleCardVisibility();
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
