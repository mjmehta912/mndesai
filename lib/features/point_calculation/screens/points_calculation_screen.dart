import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/point_calculation/controllers/points_calculation_controller.dart.dart';
import 'package:mndesai/features/point_calculation/widgets/points_calculation_card.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
import 'package:mndesai/utils/formatters/text_input_formatters.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_dropdown_search.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class PointsCalculationScreen extends StatefulWidget {
  const PointsCalculationScreen({
    super.key,
  });

  @override
  State<PointsCalculationScreen> createState() =>
      _PointsCalculationScreenState();
}

class _PointsCalculationScreenState extends State<PointsCalculationScreen> {
  final PointsCalculationController _controller = Get.put(
    PointsCalculationController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.cardNoController.clear();
    _controller.addedProducts.clear();
    _controller.cardInfo.value = null;
    _controller.selectedSalesman.value = '';
    _controller.selectedSalesmanCode.value = '';
    _controller.salesmen.clear();
    _controller.salesmanNames.clear();
    _controller.isCardNoFieldVisible.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Points Calculation',
              actions: [
                Obx(
                  () => !_controller.isCardNoFieldVisible.value
                      ? IconButton(
                          onPressed: () {
                            _controller.cardNoController.clear();
                            _controller.addedProducts.clear();
                            _controller.cardInfo.value = null;
                            _controller.selectedSalesman.value = '';
                            _controller.selectedSalesmanCode.value = '';
                            _controller.salesmen.clear();
                            _controller.salesmanNames.clear();
                            _controller.toggleCardVisibility();
                          },
                          icon: Icon(
                            Icons.refresh,
                          ),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Obx(
                () {
                  if (_controller.isCardNoFieldVisible.value) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'PLEASE ENTER A ',
                                style: TextStyles.kRegularDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                ).copyWith(
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: 'CARD NO.',
                                style: TextStyles.kBoldDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                  color: kColorPrimary,
                                ).copyWith(
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: ' OR ',
                                style: TextStyles.kRegularDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                ).copyWith(
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: 'MOBILE NO.',
                                style: TextStyles.kBoldDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                  color: kColorPrimary,
                                ).copyWith(
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpaces.v20,
                        AppTextFormField(
                          controller: _controller.cardNoController,
                          hintText: 'Card or Mobile',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            MobileNumberInputFormatter(),
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        AppSpaces.v20,
                        AppButton(
                          title: 'Continue',
                          onPressed: () async {
                            if (_controller.cardNoController.text.length == 6 ||
                                _controller.cardNoController.text.length ==
                                    10) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await _controller.getCardInfo();

                              if (_controller.cardInfo.value != null) {
                                _controller.toggleCardVisibility();
                                await _controller.getSalesMen();
                              } else {
                                _controller.cardNoController.clear();
                                showErrorSnackbar(
                                  'Error',
                                  'Mobile No. or Card No. doesnot exist',
                                );
                              }
                            } else {
                              showErrorSnackbar(
                                'Invalid',
                                'Please enter a valid card no. or a mobile no.',
                              );
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                PointsCalculationCard(
                                  controller: _controller,
                                ),
                                AppSpaces.v10,
                                Obx(
                                  () => AppDropdown(
                                    items: _controller.salesmanNames,
                                    hintText: 'Salesman',
                                    onChanged: (value) {
                                      _controller.onSalesmanSelected(value!);
                                    },
                                    selectedItem: _controller
                                            .selectedSalesman.value.isNotEmpty
                                        ? _controller.selectedSalesman.value
                                        : null,
                                  ),
                                ),
                                AppSpaces.v10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppButton(
                                      icon: SvgPicture.asset(
                                        kIconFuel,
                                        height: 25,
                                        width: 25,
                                      ),
                                      buttonWidth: 0.5.screenWidth,
                                      title: 'Add Product',
                                      onPressed: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        _controller.selectedProduct.value = '';
                                        _controller.selectedProductCode.value =
                                            '';
                                        _controller.selectedProductShortName
                                            .value = '';
                                        _controller.selectedProductRate.value =
                                            0.0;
                                        _controller.selectedProductSpecialRate
                                            .value = 0.0;
                                        _controller.selectedProductPointRate
                                            .value = 0.0;
                                        _controller.selectedProductDateWise
                                            .value = false;
                                        _controller.selectedProductMinimumLimit
                                            .value = 0.0;
                                        _controller.selectedProductMaximumLimit
                                            .value = 0.0;
                                        _controller.qtyController.clear();
                                        _controller.rateController.clear();
                                        _controller.amountController.clear();
                                        await _controller.getProducts();
                                        _showAddProductDialog();
                                      },
                                    ),
                                  ],
                                ),
                                AppSpaces.v10,
                                Obx(
                                  () => _controller.addedProducts.isNotEmpty
                                      ? _buildProductTable()
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => _controller.addedProducts.isEmpty
                              ? const SizedBox.shrink()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total Amount',
                                          style: TextStyles.kRegularDMSans(
                                            fontSize: FontSizes.k16FontSize,
                                          ),
                                        ),
                                        Text(
                                          '₹ ${_controller.totalAmount.toString()}',
                                          style: TextStyles.kBoldDMSans(),
                                        ),
                                      ],
                                    ),
                                    AppButton(
                                      buttonWidth: 0.5.screenWidth,
                                      title: 'Save',
                                      onPressed: () {
                                        if (_controller.addedProducts.isEmpty) {
                                          showErrorSnackbar(
                                            'No Products added.',
                                            'Please add a product to continue',
                                          );
                                        } else {
                                          _controller.savePointsEntry();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                        ),
                        AppSpaces.v20,
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          backgroundColor: kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: AppPaddings.combined(
              horizontal: 15.appWidth,
              vertical: 15.appHeight,
            ),
            child: Form(
              key: _controller.productsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => AppDropdown(
                      items: _controller.productNames,
                      hintText: 'Product',
                      onChanged: (value) =>
                          _controller.onProductSelected(value!),
                      selectedItem: _controller.selectedProduct.value.isNotEmpty
                          ? _controller.selectedProduct.value
                          : null,
                      validatorText: 'Please select a product.',
                    ),
                  ),
                  AppSpaces.v10,
                  AppTextFormField(
                    controller: _controller.qtyController,
                    hintText: 'Qty',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a qty.';
                      }

                      if (double.parse(value) <= 0) {
                        return 'Qty must be greater than 0';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final qty = double.tryParse(value) ?? 0;
                      final rate =
                          double.tryParse(_controller.rateController.text) ?? 0;
                      _controller.amountController.text =
                          (qty * rate).toStringAsFixed(2);
                    },
                  ),
                  AppSpaces.v10,
                  AppTextFormField(
                    controller: _controller.rateController,
                    hintText: 'Rate',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final rate = double.tryParse(value) ?? 0;
                      final qty =
                          double.tryParse(_controller.qtyController.text) ?? 0;
                      _controller.amountController.text =
                          (qty * rate).toStringAsFixed(2);
                    },
                  ),
                  AppSpaces.v10,
                  AppTextFormField(
                    controller: _controller.amountController,
                    hintText: 'Amount',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final amount = double.tryParse(value) ?? 0;
                      final rate =
                          double.tryParse(_controller.rateController.text) ?? 0;
                      if (rate != 0) {
                        _controller.qtyController.text =
                            (amount / rate).toStringAsFixed(2);
                      }
                    },
                  ),
                  AppSpaces.v20,
                  AppButton(
                    title: 'Add',
                    onPressed: () {
                      if (_controller.productsFormKey.currentState!
                          .validate()) {
                        if (_controller.selectedProductMaximumLimit > 0 &&
                            double.parse(_controller.amountController.text) >
                                _controller.selectedProductMaximumLimit.value) {
                          Get.dialog(
                            AlertDialog(
                              title: Text(
                                'Alert',
                                style: TextStyles.kSemiBoldDMSans(
                                  color: kColorPrimary,
                                ),
                              ),
                              content: Text(
                                'Entered amount ${double.parse(_controller.amountController.text)} exceeds the limit ${_controller.selectedProductMaximumLimit.value}. Do you want to continue?',
                                style: TextStyles.kMediumDMSans(
                                  fontSize: FontSizes.k16FontSize,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'No',
                                    style: TextStyles.kSemiBoldDMSans(
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Yes',
                                    style: TextStyles.kSemiBoldDMSans(
                                      color: kColorPrimary,
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                    Get.back();
                                    _controller.addProduct();
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          _controller.addProduct();
                          Get.back();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductTable() {
    return Table(
      border: TableBorder.all(
        color: kColorTextPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: kColorPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          children: [
            'PRODUCT',
            'QTY',
            'RATE',
            'AMOUNT',
            'ACTION',
          ]
              .map(
                (text) => _buildTableCell(
                  text,
                  isHeader: true,
                ),
              )
              .toList(),
        ),
        for (var i = 0; i < _controller.addedProducts.length; i++)
          TableRow(
            children: [
              _buildTableCell(_controller.addedProducts[i]['PRODUCT_NAME']),
              _buildTableCell(_controller.addedProducts[i]['QTY'].toString()),
              _buildTableCell(_controller.addedProducts[i]['RATE'].toString()),
              _buildTableCell(
                  _controller.addedProducts[i]['AMOUNT'].toString()),
              _buildTableCell(
                InkWell(
                  child: Icon(
                    Icons.delete,
                    color: kColorRed,
                    size: 20,
                  ),
                  onTap: () => _controller.deleteProduct(i),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTableCell(dynamic content, {bool isHeader = false}) {
    return TableCell(
      child: Padding(
        padding: AppPaddings.p6,
        child: content is Widget
            ? content
            : Text(
                content.toString(),
                style: isHeader
                    ? TextStyles.kMediumDMSans(
                        color: kColorWhite,
                        fontSize: FontSizes.k12FontSize,
                      )
                    : TextStyles.kMediumDMSans(
                        color: kColorTextPrimary,
                        fontSize: FontSizes.k14FontSize,
                      ),
              ),
      ),
    );
  }
}
