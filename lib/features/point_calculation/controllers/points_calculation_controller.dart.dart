import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/features/point_calculation/models/product_dm.dart';
import 'package:mndesai/features/point_calculation/repositories/points_calculation_repo.dart';
import 'package:mndesai/features/point_calculation/screens/slip_pdf_screen.dart';
import 'package:mndesai/features/virtual_card_generation/models/salesman_dm.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_button.dart';

class PointsCalculationController extends GetxController {
  var isLoading = false.obs;

  final Rx<CardInfoDm?> cardInfo = Rx<CardInfoDm?>(null);
  var productsFormKey = GlobalKey<FormState>();

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
  var selectedProductPointRate = 0.0.obs;
  var selectedProductSpecialRate = 0.0.obs;
  var selectedProductDateWise = false.obs;
  var selectedProductMinimumLimit = 0.0.obs;
  var selectedProductMaximumLimit = 0.0.obs;
  var qtyController = TextEditingController();
  var rateController = TextEditingController();
  var amountController = TextEditingController();
  var salesmen = <SalesmanDm>[].obs;
  var salesmanNames = <String>[].obs;
  var selectedSalesman = ''.obs;
  var selectedSalesmanCode = ''.obs;

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
      "PointRate": selectedProductPointRate.value
    };
    addedProducts.add(product);

    selectedProduct.value = '';
    selectedProductCode.value = '';
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

      final fetchedProducts = await PointsCalculationRepo.getProducts(
        pCode: cardInfo.value != null ? cardInfo.value!.pCode : '',
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
      final fetchedSalesmen = await PointsCalculationRepo.getSalesmen();

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
            "PointRate": product['PointRate'],
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
        seCode: selectedSalesmanCode.value.isNotEmpty
            ? selectedSalesmanCode.value
            : '',
        items: itemsToSend,
      );

      if (response != null && response['data'][0].containsKey('message')) {
        String message = response['data'][0]['message'];
        double totalPoints = response['data'][0]['TotalPoints'];
        double prevPoints = response['data'][0]['PrevPoints'];
        double currentPoints = totalPoints - prevPoints;
        String cardNo = response['data'][0]['CardNo'];
        String mobileNo = response['data'][0]['MobileNo'];
        String pName = response['data'][0]['PNAME'];
        String tranNo = response['data'][0]['TRANNO'];
        var itemData = response['itemdata'];

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
                      onPressed: () {
                        List<Map<String, dynamic>> formattedItemData =
                            (itemData as List<dynamic>)
                                .map<Map<String, dynamic>>(
                          (item) {
                            double amount = item['AMOUNT'];
                            String productName = item['Product'];
                            double qty = item['QTY'];

                            return {
                              "Product": productName,
                              "Amount": amount.toString(),
                              "QTY": qty.toString(),
                            };
                          },
                        ).toList();
                        downloadSlip(
                          pName: pName,
                          mobileNo: mobileNo,
                          cardNo: cardNo,
                          tranNo: tranNo.toString(),
                          prevPoints: prevPoints.toString(),
                          currentPoints: currentPoints.toString(),
                          totalPoints: totalPoints.toString(),
                          itemData: formattedItemData,
                        );
                      },
                      title: 'Print',
                    ),
                  ],
                ),
              ),
            );
          },
        );

        cardNoController.clear();
        addedProducts.clear();
        selectedSalesman.value = '';
        selectedSalesmanCode.value = '';
        salesmen.clear();
        salesmanNames.clear();
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

  Future<void> downloadSlip({
    required String pName,
    required String mobileNo,
    required String cardNo,
    required String tranNo,
    required String prevPoints,
    required String currentPoints,
    required String totalPoints,
    required List<Map<String, dynamic>> itemData,
  }) async {
    try {
      isLoading.value = true;

      final pdfBytes = await PointsCalculationRepo.downloadSlip(
        pName: pName,
        mobileNo: mobileNo,
        cardNo: cardNo,
        tranNo: tranNo,
        lastPoint: prevPoints,
        reward: currentPoints,
        totalPoint: totalPoints,
        itemData: itemData,
      );

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        Get.to(
          () => SlipPdfScreen(
            pdfBytes: pdfBytes,
            title: pName,
          ),
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
