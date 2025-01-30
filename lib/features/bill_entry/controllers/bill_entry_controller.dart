import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/bill_entry/models/vehicle_no_dm.dart';
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

  var selectedProduct = ''.obs;
  var selectedProductCode = ''.obs;
  var selectedProductShortName = ''.obs;
  var selectedProductRate = 0.0.obs;
  var qtyController = TextEditingController();
  var rateController = TextEditingController();
  var amountController = TextEditingController();

  var cardNoController = TextEditingController();
  final Rx<CardInfoDm?> cardInfo = Rx<CardInfoDm?>(null);

  var vehicleNos = <VehicleNoDm>[].obs;

  var isCardSelected = false.obs;
  var isCardNoFieldVisible = true.obs;
  void toggleCardVisibility() {
    isCardNoFieldVisible.value = !isCardNoFieldVisible.value;
  }

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
      qtyController.clear();
      amountController.clear();
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

  Future<void> getVehicleNos({
    String searchText = '',
  }) async {
    try {
      isLoading.value = true;

      final fetchedVehicleNos = await BillEntryRepo.getVehicleNos(
        pCode: isCardSelected.value
            ? cardInfo.value != null
                ? cardInfo.value!.pCode
                : ''
            : '00000001',
        searchText: searchText,
      );

      vehicleNos.assignAll(fetchedVehicleNos);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveBillEntry() async {
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

      var response = await BillEntryRepo.saveBillEntry(
        type: 'B',
        pCode: isCardSelected.value
            ? cardInfo.value != null
                ? cardInfo.value!.pCode
                : ''
            : '00000001',
        amount: totalAmount,
        vehicleNo:
            vehicleNoController.text.isNotEmpty ? vehicleNoController.text : '',
        cardNo: isCardSelected.value
            ? cardInfo.value != null
                ? cardInfo.value!.cardNo.toString()
                : ''
            : '',
        typeCode: isCardSelected.value
            ? cardInfo.value != null
                ? cardInfo.value!.typeCode
                : ''
            : '',
        items: itemsToSend,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        showSuccessDialog(
          Get.context!,
          message,
        );

        if (isCardSelected.value) {
          cardNoController.clear();
          addedProducts.clear();
          cardInfo.value = null;
          vehicleNoController.clear();
          vehicleNos.clear();
          toggleCardVisibility();
        } else {
          vehicleNos.clear();
          vehicleNoController.clear();
          remarkController.clear();
          customerNameController.text = 'Cash Sales';
          addedProducts.clear();
        }
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
