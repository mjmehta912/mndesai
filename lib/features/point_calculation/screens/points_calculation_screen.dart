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
    _controller.isCardNoFieldVisible.value = true;
    _controller.addedProducts.clear();
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
                        Text(
                          'Card No.',
                          style: TextStyles.kRegularDMSans(
                            fontSize: FontSizes.k36FontSize,
                          ),
                        ),
                        AppSpaces.v20,
                        AppTextFormField(
                          controller: _controller.cardNoController,
                          hintText: 'Card No.',
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
                            if (_controller.cardNoController.text.length < 6) {
                              showErrorSnackbar(
                                'Invalid',
                                'Please enter a card no.',
                              );
                            } else {
                              await _controller.getCardInfo();
                              _controller.toggleCardVisibility();
                              FocusManager.instance.primaryFocus?.unfocus();
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
                        AppButton(
                          title: 'Save',
                          onPressed: () {},
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => AppDropdown(
                    items: _controller.productNames,
                    hintText: 'Product',
                    onChanged: (value) => _controller.onProductSelected(value!),
                    selectedItem: _controller.selectedProduct.value.isNotEmpty
                        ? _controller.selectedProduct.value
                        : null,
                  ),
                ),
                AppSpaces.v10,
                AppTextFormField(
                  controller: _controller.qtyController,
                  hintText: 'Qty',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final qty = double.tryParse(value) ?? 0;
                    final rate = _controller.selectedProductRate.value;
                    _controller.amountController.text =
                        (qty * rate).toStringAsFixed(2);
                  },
                ),
                AppSpaces.v10,
                AppTextFormField(
                  controller: _controller.rateController,
                  hintText: 'Rate',
                  keyboardType: TextInputType.number,
                  onChanged: null,
                ),
                AppSpaces.v10,
                AppTextFormField(
                  controller: _controller.amountController,
                  hintText: 'Amount',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0;
                    final rate = _controller.selectedProductRate.value;
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
                    _controller.addedProducts.add({
                      'productName': _controller.selectedProduct.value,
                      'qty': _controller.qtyController.text,
                      'rate': _controller.rateController.text,
                      'amount': _controller.amountController.text,
                    });

                    _controller.selectedProduct.value = '';
                    _controller.selectedProductCode.value = '';
                    _controller.selectedProductShortName.value = '';
                    _controller.selectedProductRate.value = 0.0;
                    _controller.qtyController.clear();
                    _controller.rateController.clear();
                    _controller.amountController.clear();

                    Get.back();
                  },
                ),
              ],
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
            'Product',
            'Qty',
            'Rate',
            'Amount',
          ]
              .map(
                (text) => _buildTableCell(
                  text,
                  isHeader: true,
                ),
              )
              .toList(),
        ),
        for (var product in _controller.addedProducts)
          TableRow(
            children: [
              'productName',
              'qty',
              'rate',
              'amount',
            ]
                .map(
                  (key) => _buildTableCell(product[key]!),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
  }) {
    return TableCell(
      child: Padding(
        padding: AppPaddings.p6,
        child: Text(
          text,
          style: isHeader
              ? TextStyles.kMediumDMSans(
                  color: kColorWhite,
                  fontSize: FontSizes.k14FontSize,
                )
              : TextStyles.kMediumDMSans(
                  color: kColorTextPrimary,
                  fontSize: FontSizes.k16FontSize,
                ),
        ),
      ),
    );
  }
}
