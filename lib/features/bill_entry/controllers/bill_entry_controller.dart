import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/bill_entry/models/vehicle_no_dm.dart';
import 'package:mndesai/features/bill_entry/repositories/bill_entry_repo.dart';
import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/features/point_calculation/models/product_dm.dart';
import 'package:mndesai/features/virtual_card_generation/models/salesman_dm.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_button.dart';

class BillEntryController extends GetxController {
  var isLoading = false.obs;
  final billEntryFormKey = GlobalKey<FormState>();
  final productsFormKey = GlobalKey<FormState>();

  var products = <ProductDm>[].obs;
  var productNames = <String>[].obs;
  var addedProducts = <Map<String, dynamic>>[].obs;

  var salesmen = <SalesmanDm>[].obs;
  var salesmanNames = <String>[].obs;
  var selectedSalesman = ''.obs;
  var selectedSalesmanCode = ''.obs;

  var customerNameController = TextEditingController();
  var vehicleNoController = TextEditingController();
  var remarkController = TextEditingController();

  var selectedProduct = ''.obs;
  var selectedProductCode = ''.obs;
  var selectedProductShortName = ''.obs;
  var selectedProductRate = 0.0.obs;
  var selectedProductPointRate = 0.0.obs;
  var selectedProductSpecialRate = 0.0.obs;
  var selectedProductDateWise = false.obs;
  var selectedProductMinimumLimit = 0.0.obs;
  var selectedProductMaximumLimit = 0.0.obs;
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
      "PointRate": selectedProductPointRate.value
    };
    addedProducts.add(product);

    selectedProduct.value = '';
    selectedProductCode.value = '';
    selectedProductShortName.value = '';
    selectedProductRate.value = 0.0;
    selectedProductPointRate.value = 0.0;
    selectedProductSpecialRate.value = 0.0;
    selectedProductDateWise.value = false;
    selectedProductMinimumLimit.value = 0.0;
    selectedProductMaximumLimit.value = 0.0;
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

      final fetchedProducts = await BillEntryRepo.getProducts(
        pCode: isCardSelected.value
            ? cardInfo.value != null
                ? cardInfo.value!.pCode
                : ''
            : '00000001',
      );

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
    selectedProductPointRate.value = productObj.pointRate!;
    selectedProductMinimumLimit.value = productObj.minLimit;
    selectedProductMaximumLimit.value = productObj.maxLimit;
    if (productObj.dateWise == true && productObj.rate != null) {
      qtyController.clear();
      amountController.clear();
      selectedProductRate.value = productObj.rate!;
      rateController.text = selectedProductRate.value.toString();
    } else if (productObj.dateWise == true && productObj.rate == null) {
      qtyController.clear();
      amountController.clear();
      selectedProductSpecialRate.value = productObj.salesRate;
      rateController.text = selectedProductSpecialRate.value.toString();
    } else if (productObj.dateWise == false) {
      qtyController.clear();
      amountController.clear();
      selectedProductSpecialRate.value = productObj.salesRate;
      rateController.text = selectedProductSpecialRate.value.toString();
    } else {
      selectedProductRate.value = 0.0;
      rateController.text = selectedProductRate.value.toString();
    }
  }

  Future<void> getSalesMen() async {
    isLoading.value = false;
    try {
      final fetchedSalesmen = await BillEntryRepo.getSalesmen();

      salesmen.assignAll(fetchedSalesmen);
      salesmanNames.assignAll(
        fetchedSalesmen.map(
          (se) => se.seName,
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

  void onSalesmanSelected(String salesmanName) {
    selectedSalesman.value = salesmanName;

    final salesmanObj = salesmen.firstWhere(
      (se) => se.seName == salesmanName,
    );

    selectedSalesmanCode.value = salesmanObj.seCode;
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
            "PointRate": product['PointRate'],
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
        seCode: selectedSalesmanCode.value.isNotEmpty
            ? selectedSalesmanCode.value
            : '',
        items: itemsToSend,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        if (isCardSelected.value) {
          cardNoController.clear();
          addedProducts.clear();
          cardInfo.value = null;
          vehicleNoController.clear();
          vehicleNos.clear();
          selectedSalesman.value = '';
          selectedSalesmanCode.value = '';
          salesmen.clear();
          salesmanNames.clear();
          toggleCardVisibility();
          String message = response['message'];
          double totalPoints = response['TotalPoints'];
          double prevPoints = response['PrevPoints'];
          double currentPoints = totalPoints - prevPoints;
          String cardNo = response['CardNo'];
          String mobileNo = response['MobileNo'];
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: kColorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: AppPaddings.p10,
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        kSuccessLottieGif,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        message,
                        style: TextStyles.kBoldDMSans(
                          color: Colors.green,
                        ).copyWith(
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpaces.v10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Card No. : ',
                            style: TextStyles.kRegularDMSans(
                              color: kColorTextPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1.25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            cardNo,
                            style: TextStyles.kBoldDMSans(
                              color: kColorTextPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1.25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mobile No. : ',
                            style: TextStyles.kRegularDMSans(
                              color: kColorTextPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1.25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            mobileNo,
                            style: TextStyles.kBoldDMSans(
                              color: kColorTextPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1.25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      AppSpaces.v6,
                      Text(
                        'Previous Points : $prevPoints',
                        style: TextStyles.kMediumDMSans(
                          color: kColorTextPrimary,
                          fontSize: FontSizes.k16FontSize,
                        ).copyWith(
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpaces.v4,
                      Text(
                        'Current Points : $currentPoints',
                        style: TextStyles.kBoldDMSans(
                          color: kColorPrimary,
                          fontSize: FontSizes.k18FontSize,
                        ).copyWith(
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Total Points : $totalPoints',
                        style: TextStyles.kBoldDMSans(
                          color: kColorTextPrimary,
                        ).copyWith(
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpaces.v10,
                      AppButton(
                        onPressed: () {
                          Get.back();
                        },
                        title: 'OK',
                      ),
                      AppSpaces.v10,
                      AppButton(
                        buttonColor: kColorWhite,
                        titleColor: kColorPrimary,
                        onPressed: () {},
                        title: 'Print',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          vehicleNos.clear();
          vehicleNoController.clear();
          remarkController.clear();
          customerNameController.text = 'Cash Sales';
          addedProducts.clear();
          selectedSalesman.value = '';
          selectedSalesmanCode.value = '';
          salesmen.clear();
          salesmanNames.clear();
          await getSalesMen();
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: kColorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: AppPaddings.p10,
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        kSuccessLottieGif,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        message,
                        style: TextStyles.kBoldDMSans(
                          color: Colors.green,
                        ).copyWith(
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpaces.v10,
                      AppButton(
                        onPressed: () {
                          Get.back();
                        },
                        title: 'OK',
                      ),
                      AppSpaces.v10,
                      AppButton(
                        buttonColor: kColorWhite,
                        titleColor: kColorPrimary,
                        onPressed: () {},
                        title: 'Print',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
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
