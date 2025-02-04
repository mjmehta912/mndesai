import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/bill_entry/controllers/bill_entry_controller.dart';
import 'package:mndesai/features/bill_entry/widgets/bill_entry_card.dart';
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
  void initState() {
    super.initState();

    _controller.isCardNoFieldVisible.value = true;
    _controller.isCardSelected.value = false;
    _controller.addedProducts.clear();
    _controller.cardNoController.clear();
    _controller.vehicleNos.clear();
    _controller.vehicleNoController.clear();
    _controller.cardInfo.value = null;
    _controller.remarkController.clear();
    _controller.customerNameController.text = 'Cash Sales';
    _controller.selectedSalesman.value = '';
    _controller.selectedSalesmanCode.value = '';
    _controller.getSalesMen();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _controller.vehicleNos.clear();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Bill Entry',
              actions: [
                Obx(
                  () => _controller.isCardSelected.value &&
                          !_controller.isCardNoFieldVisible.value
                      ? IconButton(
                          onPressed: () {
                            _controller.cardNoController.clear();
                            _controller.addedProducts.clear();
                            _controller.cardInfo.value = null;
                            _controller.vehicleNoController.clear();
                            _controller.vehicleNos.clear();
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
              padding: AppPaddings.custom(
                left: 15,
                right: 15,
                top: 5,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.isCardSelected.value = true;
                            _controller.isCardNoFieldVisible.value = true;
                            _controller.addedProducts.clear();
                            _controller.cardNoController.clear();
                            _controller.vehicleNoController.clear();
                            _controller.vehicleNos.clear();
                            _controller.selectedSalesman.value = '';
                            _controller.selectedSalesmanCode.value = '';
                            _controller.salesmen.clear();
                            _controller.salesmanNames.clear();
                            _controller.cardInfo.value = null;
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
                          onTap: () async {
                            _controller.isCardSelected.value = false;
                            _controller.addedProducts.clear();
                            _controller.vehicleNoController.clear();
                            _controller.vehicleNos.clear();
                            _controller.salesmen.clear();
                            _controller.salesmanNames.clear();
                            _controller.selectedSalesman.value = '';
                            _controller.selectedSalesmanCode.value = '';
                            _controller.remarkController.clear();
                            _controller.customerNameController.text =
                                'Cash Sales';

                            await _controller.getSalesMen();
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
                                  'Cash',
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
                                          AppSpaces.v60,
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'PLEASE ENTER A ',
                                                  style:
                                                      TextStyles.kRegularDMSans(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ).copyWith(
                                                    height: 1.25,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'CARD NO.',
                                                  style: TextStyles.kBoldDMSans(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                    color: kColorPrimary,
                                                  ).copyWith(
                                                    height: 1.25,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' OR ',
                                                  style:
                                                      TextStyles.kRegularDMSans(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ).copyWith(
                                                    height: 1.25,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'MOBILE NO.',
                                                  style: TextStyles.kBoldDMSans(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
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
                                            controller:
                                                _controller.cardNoController,
                                            hintText: 'Card or Mobile',
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
                                                          .text.length ==
                                                      6 ||
                                                  _controller.cardNoController
                                                          .text.length ==
                                                      10) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                await _controller.getCardInfo();

                                                if (_controller
                                                        .cardInfo.value !=
                                                    null) {
                                                  await _controller
                                                      .getSalesMen();
                                                  _controller
                                                      .toggleCardVisibility();
                                                } else {
                                                  _controller.cardNoController
                                                      .clear();
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
                                      )
                                    : Column(
                                        children: [
                                          AppSpaces.v10,
                                          AppTextFormField(
                                            controller:
                                                _controller.vehicleNoController,
                                            hintText: 'Vehicle No.',
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z0-9]')),
                                              UpperCaseTextInputFormatter(),
                                            ],
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                _controller.getVehicleNos(
                                                    searchText: value);
                                              } else {
                                                _controller.vehicleNos.clear();
                                              }
                                            },
                                          ),
                                          Obx(
                                            () {
                                              if (_controller
                                                  .vehicleNos.isEmpty) {
                                                return const SizedBox.shrink();
                                              } else {
                                                return Column(
                                                  children: [
                                                    AppSpaces.v10,
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: kColorWhite,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: kColorGrey
                                                                .withOpacity(
                                                                    0.3)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: kColorGrey
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight:
                                                            0.2.screenHeight,
                                                      ),
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount: _controller
                                                            .vehicleNos.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final vehicleNo =
                                                              _controller
                                                                      .vehicleNos[
                                                                  index];
                                                          return GestureDetector(
                                                            onTap: () {
                                                              _controller
                                                                      .vehicleNoController
                                                                      .text =
                                                                  vehicleNo
                                                                      .vehicleNo;
                                                              _controller
                                                                  .vehicleNos
                                                                  .clear();
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    15.appWidth,
                                                                vertical:
                                                                    8.appHeight,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kColorWhite,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    vehicleNo
                                                                        .vehicleNo,
                                                                    style: TextStyles
                                                                        .kMediumDMSans(
                                                                      fontSize:
                                                                          FontSizes
                                                                              .k16FontSize,
                                                                    ),
                                                                  ),
                                                                  if (index !=
                                                                      _controller
                                                                              .vehicleNos
                                                                              .length -
                                                                          1)
                                                                    Divider(
                                                                      color: kColorGrey
                                                                          .withOpacity(
                                                                              0.3),
                                                                      height: 1,
                                                                    ),
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
                                          AppSpaces.v14,
                                          Obx(
                                            () => AppDropdown(
                                              items: _controller.salesmanNames,
                                              hintText: 'Salesman',
                                              onChanged: (value) {
                                                _controller
                                                    .onSalesmanSelected(value!);
                                              },
                                              selectedItem: _controller
                                                      .selectedSalesman
                                                      .value
                                                      .isNotEmpty
                                                  ? _controller
                                                      .selectedSalesman.value
                                                  : null,
                                            ),
                                          ),
                                          AppSpaces.v10,
                                          BillEntryCard(
                                            controller: _controller,
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
                                                buttonWidth: 0.4.screenWidth,
                                                titleSize:
                                                    FontSizes.k16FontSize,
                                                title: 'Add Product',
                                                onPressed: () async {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  await _controller
                                                      .getProducts();
                                                  _showAddProductDialog();
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

                                                return _addedProductCard(
                                                  product,
                                                  () {
                                                    _controller
                                                        .deleteProduct(index);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                              } else {
                                return Column(
                                  children: [
                                    AppSpaces.v10,
                                    AppTextFormField(
                                      controller:
                                          _controller.customerNameController,
                                      hintText: 'Customer Name',
                                    ),
                                    AppSpaces.v14,
                                    AppTextFormField(
                                      controller:
                                          _controller.vehicleNoController,
                                      hintText: 'Vehicle No.',
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9]')),
                                        UpperCaseTextInputFormatter(),
                                      ],
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          _controller.getVehicleNos(
                                              searchText: value);
                                        } else {
                                          _controller.vehicleNos.clear();
                                        }
                                      },
                                    ),
                                    Obx(
                                      () {
                                        if (_controller.vehicleNos.isEmpty) {
                                          return const SizedBox.shrink();
                                        } else {
                                          return Column(
                                            children: [
                                              AppSpaces.v10,
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: kColorWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: kColorGrey
                                                          .withOpacity(0.3)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: kColorGrey
                                                          .withOpacity(0.2),
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                constraints: BoxConstraints(
                                                  maxHeight: 0.2.screenHeight,
                                                ),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount: _controller
                                                      .vehicleNos.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final vehicleNo =
                                                        _controller
                                                            .vehicleNos[index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        _controller
                                                                .vehicleNoController
                                                                .text =
                                                            vehicleNo.vehicleNo;
                                                        _controller.vehicleNos
                                                            .clear();
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              15.appWidth,
                                                          vertical: 8.appHeight,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kColorWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              vehicleNo
                                                                  .vehicleNo,
                                                              style: TextStyles
                                                                  .kMediumDMSans(
                                                                fontSize: FontSizes
                                                                    .k16FontSize,
                                                              ),
                                                            ),
                                                            if (index !=
                                                                _controller
                                                                        .vehicleNos
                                                                        .length -
                                                                    1)
                                                              Divider(
                                                                color: kColorGrey
                                                                    .withOpacity(
                                                                        0.3),
                                                                height: 1,
                                                              ),
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
                                    AppSpaces.v14,
                                    Obx(
                                      () => AppDropdown(
                                        items: _controller.salesmanNames,
                                        hintText: 'Salesman',
                                        onChanged: (value) {
                                          _controller
                                              .onSalesmanSelected(value!);
                                        },
                                        selectedItem: _controller
                                                .selectedSalesman
                                                .value
                                                .isNotEmpty
                                            ? _controller.selectedSalesman.value
                                            : null,
                                      ),
                                    ),
                                    AppSpaces.v14,
                                    AppTextFormField(
                                      controller: _controller.remarkController,
                                      hintText: 'Remarks',
                                    ),
                                    AppSpaces.v14,
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
                                    AppSpaces.v14,
                                    Obx(
                                      () => ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _controller.addedProducts.length,
                                        itemBuilder: (context, index) {
                                          final product =
                                              _controller.addedProducts[index];

                                          return _addedProductCard(
                                            product,
                                            () {
                                              _controller.deleteProduct(index);
                                            },
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
                  Obx(
                    () => _controller.isCardSelected.value &&
                            _controller.isCardNoFieldVisible.value
                        ? const SizedBox.shrink()
                        : _controller.addedProducts.isEmpty
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                        _controller.saveBillEntry();
                                      }
                                    },
                                  ),
                                ],
                              ),
                  ),
                  AppSpaces.v20,
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

  Card _addedProductCard(
    Map<String, dynamic> product,
    VoidCallback onTap,
  ) {
    return Card(
      color: kColorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: kColorPrimary,
        ),
      ),
      child: Padding(
        padding: AppPaddings.p6,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0.5.screenWidth,
                  child: Text(
                    product['PRODUCT_NAME'],
                    style: TextStyles.kMediumDMSans(
                      color: kColorTextPrimary,
                      fontSize: FontSizes.k18FontSize,
                    ),
                  ),
                ),
                Text(
                  product['QTY'].toString(),
                  style: TextStyles.kMediumDMSans(
                    color: kColorTextPrimary,
                    fontSize: FontSizes.k18FontSize,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onTap,
                  child: Icon(
                    Icons.delete,
                    color: kColorRed,
                    size: 20,
                  ),
                ),
                Text(
                  product['AMOUNT'].toString(),
                  style: TextStyles.kMediumDMSans(
                    color: kColorTextPrimary,
                    fontSize: FontSizes.k18FontSize,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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
}
