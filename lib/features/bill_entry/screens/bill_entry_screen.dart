import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/bill_entry/controllers/bill_entry_controller.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
import 'package:mndesai/utils/formatters/text_input_formatters.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_date_picker_field.dart';
import 'package:mndesai/widgets/app_dropdown_search.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class BillEntryScreen extends StatefulWidget {
  const BillEntryScreen({
    super.key,
  });

  @override
  State<BillEntryScreen> createState() => _BillEntryScreenState();
}

class _BillEntryScreenState extends State<BillEntryScreen> {
  final BillEntryController _controller = Get.put(
    BillEntryController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppAppbar(
              title: 'Bill Entry',
            ),
            body: Padding(
              padding: AppPaddings.p14,
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.isCardSelected.value = true;
                            _controller.addedProducts.clear();
                            _controller.srNoController.clear();
                            _controller.dateController.clear();
                            _controller.customerNameController.clear();
                            _controller.vehicleNoController.clear();
                            _controller.remarkController.clear();
                          },
                          child: SizedBox(
                            width: 0.275.screenWidth,
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.zero,
                              color: _controller.isCardSelected.value
                                  ? kColorPrimary
                                  : kColorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                side: BorderSide(
                                  color: kColorPrimary,
                                ),
                              ),
                              child: Padding(
                                padding: AppPaddings.p6,
                                child: Text(
                                  'Card',
                                  style: TextStyles.kMediumDMSans(
                                    color: _controller.isCardSelected.value
                                        ? kColorWhite
                                        : kColorPrimary,
                                    fontSize: FontSizes.k18FontSize,
                                  ).copyWith(
                                    height: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.isCardSelected.value = false;
                            _controller.isCardNoFieldVisible.value = true;
                            _controller.cardNoController.clear();
                            _controller.addedProducts.clear();

                            _controller.customerNameController.text =
                                'Cash Sales';
                          },
                          child: SizedBox(
                            width: 0.275.screenWidth,
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.zero,
                              color: !_controller.isCardSelected.value
                                  ? kColorPrimary
                                  : kColorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                side: BorderSide(
                                  color: kColorPrimary,
                                ),
                              ),
                              child: Padding(
                                padding: AppPaddings.p6,
                                child: Text(
                                  'Cash Sales',
                                  style: TextStyles.kMediumDMSans(
                                    color: !_controller.isCardSelected.value
                                        ? kColorWhite
                                        : kColorPrimary,
                                    fontSize: FontSizes.k18FontSize,
                                  ).copyWith(
                                    height: 1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpaces.v20,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx(
                            () {
                              if (_controller.isCardSelected.value) {
                                return _controller.isCardNoFieldVisible.value
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppSpaces.v60,
                                          AppSpaces.v40,
                                          Text(
                                            'Card No.',
                                            style: TextStyles.kRegularDMSans(
                                              fontSize: FontSizes.k36FontSize,
                                            ),
                                          ),
                                          AppSpaces.v20,
                                          AppTextFormField(
                                            controller:
                                                _controller.cardNoController,
                                            hintText: 'Card No.',
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              MobileNumberInputFormatter(),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                          ),
                                          AppSpaces.v20,
                                          AppButton(
                                            title: 'Continue',
                                            onPressed: () async {
                                              if (_controller.cardNoController
                                                      .text.length <
                                                  6) {
                                                showErrorSnackbar(
                                                  'Invalid',
                                                  'Please enter a card no.',
                                                );
                                              } else {
                                                await _controller.getCardInfo();
                                                _controller
                                                    .toggleCardVisibility();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    : Column(
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
                                                      style: TextStyles
                                                          .kRegularDMSans(
                                                        fontSize: FontSizes
                                                            .k14FontSize,
                                                        color: kColorWhite,
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => Text(
                                                        _controller.cardInfo
                                                                    .value !=
                                                                null
                                                            ? _controller
                                                                .cardInfo
                                                                .value!
                                                                .balance
                                                                .toString()
                                                            : '0.0',
                                                        style: TextStyles
                                                            .kBoldDMSans(
                                                          color: kColorWhite,
                                                          fontSize: FontSizes
                                                              .k22FontSize,
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
                                                        style: TextStyles
                                                            .kRegularDMSans(
                                                          fontSize: FontSizes
                                                              .k14FontSize,
                                                          color: kColorWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Card #  ${_controller.cardNoController.text}',
                                                      style: TextStyles
                                                          .kRegularDMSans(
                                                        fontSize: FontSizes
                                                            .k14FontSize,
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
                                                      style: TextStyles
                                                          .kRegularDMSans(
                                                        color: kColorWhite,
                                                        fontSize: FontSizes
                                                            .k16FontSize,
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => Text(
                                                        _controller.cardInfo
                                                                    .value !=
                                                                null
                                                            ? _controller
                                                                .cardInfo
                                                                .value!
                                                                .cardType
                                                            : '',
                                                        style: TextStyles
                                                            .kSemiBoldDMSans(
                                                          color: kColorWhite,
                                                          fontSize: FontSizes
                                                              .k18FontSize,
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
                                                      DateFormat('dd MMM yyyy')
                                                          .format(
                                                        DateTime.now(),
                                                      ),
                                                      style: TextStyles
                                                          .kBoldDMSans(
                                                        color: kColorWhite,
                                                        fontSize: FontSizes
                                                            .k18FontSize,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('HH:mm')
                                                          .format(
                                                        DateTime.now(),
                                                      ),
                                                      style: TextStyles
                                                          .kMediumDMSans(
                                                        color: kColorWhite,
                                                        fontSize: FontSizes
                                                            .k16FontSize,
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      _controller.cardInfo
                                                                  .value !=
                                                              null
                                                          ? _controller.cardInfo
                                                              .value!.member
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  await _controller
                                                      .getProducts();
                                                  showDialog(
                                                    // ignore: use_build_context_synchronously
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            kColorWhite,
                                                        surfaceTintColor:
                                                            kColorWhite,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Padding(
                                                          padding: AppPaddings
                                                              .combined(
                                                            horizontal:
                                                                15.appWidth,
                                                            vertical:
                                                                15.appHeight,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Obx(
                                                                () =>
                                                                    AppDropdown(
                                                                  items: _controller
                                                                      .productNames,
                                                                  hintText:
                                                                      'Product',
                                                                  onChanged:
                                                                      (value) {
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
                                                                controller:
                                                                    _controller
                                                                        .qtyController,
                                                                hintText: 'Qty',
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                onChanged:
                                                                    (value) {
                                                                  final qty =
                                                                      double.tryParse(
                                                                              value) ??
                                                                          0;
                                                                  final rate =
                                                                      _controller
                                                                          .selectedProductRate
                                                                          .value;
                                                                  _controller
                                                                      .amountController
                                                                      .text = (qty *
                                                                          rate)
                                                                      .toStringAsFixed(
                                                                          2);
                                                                },
                                                              ),
                                                              AppSpaces.v10,
                                                              AppTextFormField(
                                                                controller:
                                                                    _controller
                                                                        .rateController,
                                                                hintText:
                                                                    'Rate',
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                              ),
                                                              AppSpaces.v10,
                                                              AppTextFormField(
                                                                controller:
                                                                    _controller
                                                                        .amountController,
                                                                hintText:
                                                                    'Amount',
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                onChanged:
                                                                    (value) {
                                                                  final amount =
                                                                      double.tryParse(
                                                                              value) ??
                                                                          0;
                                                                  final rate =
                                                                      _controller
                                                                          .selectedProductRate
                                                                          .value;
                                                                  if (rate !=
                                                                      0) {
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
                                                                  final qty =
                                                                      _controller
                                                                          .qtyController
                                                                          .text;
                                                                  final rate =
                                                                      _controller
                                                                          .rateController
                                                                          .text;
                                                                  final amount =
                                                                      _controller
                                                                          .amountController
                                                                          .text;

                                                                  // Create a map for the new product
                                                                  final addedProduct =
                                                                      {
                                                                    'productName':
                                                                        productName,
                                                                    'qty': qty,
                                                                    'rate':
                                                                        rate,
                                                                    'amount':
                                                                        amount,
                                                                  };

                                                                  // Add the product to the list
                                                                  _controller
                                                                      .addedProducts
                                                                      .add(
                                                                          addedProduct);

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
                                          Obx(
                                            () => ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: _controller
                                                  .addedProducts.length,
                                              itemBuilder: (context, index) {
                                                final product = _controller
                                                    .addedProducts[index];

                                                return Card(
                                                  color: kColorWhite,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                      color: kColorPrimary,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: AppPaddings.p6,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          product[
                                                              'productName'],
                                                          style: TextStyles
                                                              .kMediumDMSans(
                                                            color:
                                                                kColorTextPrimary,
                                                            fontSize: FontSizes
                                                                .k18FontSize,
                                                          ),
                                                        ),
                                                        Text(
                                                          product['qty'],
                                                          style: TextStyles
                                                              .kMediumDMSans(
                                                            color:
                                                                kColorTextPrimary,
                                                            fontSize: FontSizes
                                                                .k18FontSize,
                                                          ),
                                                        ),
                                                        Text(
                                                          product['amount'],
                                                          style: TextStyles
                                                              .kMediumDMSans(
                                                            color:
                                                                kColorTextPrimary,
                                                            fontSize: FontSizes
                                                                .k18FontSize,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                              } else {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 0.45.screenWidth,
                                          child: AppTextFormField(
                                            controller:
                                                _controller.srNoController,
                                            hintText: 'Sr. No.',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.45.screenWidth,
                                          child: AppDatePickerTextFormField(
                                            dateController:
                                                _controller.dateController,
                                            hintText: 'Date',
                                          ),
                                        )
                                      ],
                                    ),
                                    AppSpaces.v10,
                                    AppTextFormField(
                                      controller:
                                          _controller.customerNameController,
                                      hintText: 'Customer Name',
                                    ),
                                    AppSpaces.v10,
                                    AppTextFormField(
                                      controller:
                                          _controller.vehicleNoController,
                                      hintText: 'Vehicle No.',
                                    ),
                                    AppSpaces.v10,
                                    AppTextFormField(
                                      controller: _controller.remarkController,
                                      hintText: 'Remarks',
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
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        AppPaddings.combined(
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
                                                              TextInputType
                                                                  .number,
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
                                                                .toStringAsFixed(
                                                                    2);
                                                          },
                                                        ),
                                                        AppSpaces.v10,
                                                        AppTextFormField(
                                                          controller: _controller
                                                              .rateController,
                                                          hintText: 'Rate',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                        ),
                                                        AppSpaces.v10,
                                                        AppTextFormField(
                                                          controller: _controller
                                                              .amountController,
                                                          hintText: 'Amount',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
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
                                                            final qty =
                                                                _controller
                                                                    .qtyController
                                                                    .text;
                                                            final rate =
                                                                _controller
                                                                    .rateController
                                                                    .text;
                                                            final amount =
                                                                _controller
                                                                    .amountController
                                                                    .text;

                                                            // Create a map for the new product
                                                            final addedProduct =
                                                                {
                                                              'productName':
                                                                  productName,
                                                              'qty': qty,
                                                              'rate': rate,
                                                              'amount': amount,
                                                            };

                                                            // Add the product to the list
                                                            _controller
                                                                .addedProducts
                                                                .add(
                                                                    addedProduct);

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
                                    Obx(
                                      () => ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _controller.addedProducts.length,
                                        itemBuilder: (context, index) {
                                          final product =
                                              _controller.addedProducts[index];

                                          return Card(
                                            color: kColorWhite,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: kColorPrimary,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: AppPaddings.p6,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['productName'],
                                                    style: TextStyles
                                                        .kMediumDMSans(
                                                      color: kColorTextPrimary,
                                                      fontSize:
                                                          FontSizes.k18FontSize,
                                                    ),
                                                  ),
                                                  Text(
                                                    product['qty'],
                                                    style: TextStyles
                                                        .kMediumDMSans(
                                                      color: kColorTextPrimary,
                                                      fontSize:
                                                          FontSizes.k18FontSize,
                                                    ),
                                                  ),
                                                  Text(
                                                    product['amount'],
                                                    style: TextStyles
                                                        .kMediumDMSans(
                                                      color: kColorTextPrimary,
                                                      fontSize:
                                                          FontSizes.k18FontSize,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppButton(
                    title: 'Save',
                    onPressed: () {},
                  ),
                ],
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
