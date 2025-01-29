import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/point_calculation/controllers/points_calculation_controller.dart.dart';
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
                                Stack(
                                  children: [
                                    Image.asset(
                                      kImageBlankCard,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      left: 15,
                                      top: 15,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Points Balance',
                                            style: TextStyles.kRegularDMSans(
                                              fontSize: FontSizes.k14FontSize,
                                              color: kColorWhite,
                                            ),
                                          ),
                                          Obx(
                                            () => Text(
                                              _controller.cardInfo.value != null
                                                  ? _controller
                                                      .cardInfo.value!.balance
                                                      .toString()
                                                  : '0.0',
                                              style: TextStyles.kBoldDMSans(
                                                color: kColorWhite,
                                                fontSize: FontSizes.k22FontSize,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 15,
                                      top: 15,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Obx(
                                            () => Text(
                                              'Serial #  ${_controller.cardInfo.value != null ? _controller.cardInfo.value!.pcSrNo : ''}',
                                              style: TextStyles.kRegularDMSans(
                                                fontSize: FontSizes.k14FontSize,
                                                color: kColorWhite,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Card #  ${_controller.cardNoController.text}',
                                            style: TextStyles.kRegularDMSans(
                                              fontSize: FontSizes.k14FontSize,
                                              color: kColorWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 15,
                                      bottom: 15,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Card Type',
                                            style: TextStyles.kRegularDMSans(
                                              color: kColorWhite,
                                              fontSize: FontSizes.k16FontSize,
                                            ),
                                          ),
                                          Obx(
                                            () => Text(
                                              _controller.cardInfo.value != null
                                                  ? _controller
                                                      .cardInfo.value!.cardType
                                                  : '',
                                              style: TextStyles.kSemiBoldDMSans(
                                                color: kColorWhite,
                                                fontSize: FontSizes.k18FontSize,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 15,
                                      bottom: 15,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat('dd MMM yyyy').format(
                                              DateTime.now(),
                                            ),
                                            style: TextStyles.kBoldDMSans(
                                              color: kColorWhite,
                                              fontSize: FontSizes.k18FontSize,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('HH:mm').format(
                                              DateTime.now(),
                                            ),
                                            style: TextStyles.kMediumDMSans(
                                              color: kColorWhite,
                                              fontSize: FontSizes.k16FontSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 15,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Obx(
                                        () => Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _controller.cardInfo.value != null
                                                ? _controller
                                                    .cardInfo.value!.member
                                                : '',
                                            style: TextStyles
                                                .kBoldSofiaSansSemiCondensed(
                                              color: kColorWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                        showDialog(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor: kColorWhite,
                                              surfaceTintColor: kColorWhite,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: AppPaddings.combined(
                                                  horizontal: 15.appWidth,
                                                  vertical: 15.appHeight,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Obx(
                                                      () => AppDropdown(
                                                        items: _controller
                                                            .productNames,
                                                        hintText: 'Product',
                                                        onChanged: (value) {
                                                          _controller
                                                              .onProductSelected(
                                                                  value!);
                                                        },
                                                        selectedItem: _controller
                                                                .selectedProduct
                                                                .value
                                                                .isNotEmpty
                                                            ? _controller
                                                                .selectedProduct
                                                                .value
                                                            : null,
                                                      ),
                                                    ),
                                                    AppSpaces.v10,
                                                    AppTextFormField(
                                                      controller: _controller
                                                          .qtyController,
                                                      hintText: 'Qty',
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        final qty =
                                                            double.tryParse(
                                                                    value) ??
                                                                0;
                                                        final rate = _controller
                                                            .selectedProductRate
                                                            .value;
                                                        _controller
                                                            .amountController
                                                            .text = (qty *
                                                                rate)
                                                            .toStringAsFixed(2);
                                                      },
                                                    ),
                                                    AppSpaces.v10,
                                                    AppTextFormField(
                                                      controller: _controller
                                                          .rateController,
                                                      hintText: 'Rate',
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                    AppSpaces.v10,
                                                    AppTextFormField(
                                                      controller: _controller
                                                          .amountController,
                                                      hintText: 'Amount',
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        final amount =
                                                            double.tryParse(
                                                                    value) ??
                                                                0;
                                                        final rate = _controller
                                                            .selectedProductRate
                                                            .value;
                                                        if (rate != 0) {
                                                          _controller
                                                              .qtyController
                                                              .text = (amount /
                                                                  rate)
                                                              .toStringAsFixed(
                                                                  2);
                                                        }
                                                      },
                                                    ),
                                                    AppSpaces.v20,
                                                    AppButton(
                                                      title: 'Add',
                                                      onPressed: () {
                                                        final productName =
                                                            _controller
                                                                .selectedProduct
                                                                .value;
                                                        final qty = _controller
                                                            .qtyController.text;
                                                        final rate = _controller
                                                            .rateController
                                                            .text;
                                                        final amount =
                                                            _controller
                                                                .amountController
                                                                .text;

                                                        // Create a map for the new product
                                                        final addedProduct = {
                                                          'productName':
                                                              productName,
                                                          'qty': qty,
                                                          'rate': rate,
                                                          'amount': amount,
                                                        };

                                                        // Add the product to the list
                                                        _controller
                                                            .addedProducts
                                                            .add(addedProduct);

                                                        _controller
                                                            .selectedProduct
                                                            .value = '';
                                                        _controller
                                                            .selectedProductCode
                                                            .value = '';
                                                        _controller
                                                            .selectedProductShortName
                                                            .value = '';
                                                        _controller
                                                            .selectedProductRate
                                                            .value = 0.0;
                                                        _controller
                                                            .qtyController
                                                            .clear();
                                                        _controller
                                                            .rateController
                                                            .clear();
                                                        _controller
                                                            .amountController
                                                            .clear();

                                                        Get.back();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                AppSpaces.v10,
                                Obx(() {
                                  return _controller.addedProducts.isNotEmpty
                                      ? Table(
                                          border: TableBorder.all(
                                            color: kColorTextPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          children: [
                                            TableRow(
                                              decoration: BoxDecoration(
                                                color: kColorPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              children: [
                                                TableCell(
                                                  child: Padding(
                                                    padding: AppPaddings.p6,
                                                    child: Text(
                                                      'Product',
                                                      style: TextStyles
                                                          .kMediumDMSans(
                                                        color: kColorWhite,
                                                        fontSize: FontSizes
                                                            .k14FontSize,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: AppPaddings.p6,
                                                    child: Text(
                                                      'Qty',
                                                      style: TextStyles
                                                          .kMediumDMSans(
                                                        color: kColorWhite,
                                                        fontSize: FontSizes
                                                            .k14FontSize,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: AppPaddings.p6,
                                                    child: Text(
                                                      'Rate',
                                                      style: TextStyles
                                                          .kMediumDMSans(
                                                        color: kColorWhite,
                                                        fontSize: FontSizes
                                                            .k14FontSize,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: AppPaddings.p6,
                                                    child: Text(
                                                      'Amount',
                                                      style: TextStyles
                                                          .kMediumDMSans(
                                                        color: kColorWhite,
                                                        fontSize: FontSizes
                                                            .k14FontSize,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            for (var product
                                                in _controller.addedProducts)
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding: AppPaddings.p6,
                                                      child: Text(
                                                        product['productName'],
                                                        style: TextStyles
                                                            .kMediumDMSans(
                                                          color:
                                                              kColorTextPrimary,
                                                          fontSize: FontSizes
                                                              .k16FontSize,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: AppPaddings.p6,
                                                      child: Text(
                                                        product['qty']
                                                            .toString(),
                                                        style: TextStyles
                                                            .kMediumDMSans(
                                                          color:
                                                              kColorTextPrimary,
                                                          fontSize: FontSizes
                                                              .k16FontSize,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: AppPaddings.p6,
                                                      child: Text(
                                                        product['rate']
                                                            .toString(),
                                                        style: TextStyles
                                                            .kMediumDMSans(
                                                          color:
                                                              kColorTextPrimary,
                                                          fontSize: FontSizes
                                                              .k16FontSize,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: AppPaddings.p6,
                                                      child: Text(
                                                        product['amount']
                                                            .toString(),
                                                        style: TextStyles
                                                            .kMediumDMSans(
                                                          color:
                                                              kColorTextPrimary,
                                                          fontSize: FontSizes
                                                              .k16FontSize,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                })
                              ],
                            ),
                          ),
                        ),
                        AppButton(
                          title: 'Save',
                          onPressed: () {},
                        ),
                        AppSpaces.v20
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
}
