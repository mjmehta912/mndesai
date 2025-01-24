import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/point_calculation/controllers/point_calculation_controller.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_date_picker_field.dart';
import 'package:mndesai/widgets/app_dropdown_search.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class PointCalculationScreen extends StatelessWidget {
  PointCalculationScreen({
    super.key,
  });

  final PointCalculationController _controller = Get.put(
    PointCalculationController(),
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
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Point Calculation',
            ),
            body: Padding(
              padding: AppPaddings.p14,
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      AppTextFormField(
                        controller: TextEditingController(),
                        hintText: 'Serial No.',
                      ),
                      AppSpaces.v10,
                      AppDatePickerTextFormField(
                        dateController: TextEditingController(),
                        hintText: 'Date',
                      ),
                      AppSpaces.v10,
                      AppTextFormField(
                        controller: TextEditingController(),
                        hintText: 'Card No.',
                      ),
                      AppSpaces.v10,
                      AppTextFormField(
                        controller: TextEditingController(),
                        hintText: 'Member',
                      ),
                      AppSpaces.v10,
                      AppTextFormField(
                        controller: TextEditingController(),
                        hintText: 'Card Type',
                      ),
                      AppSpaces.v10,
                      AppButton(
                        title: 'Add Product',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: kColorWhite,
                                surfaceTintColor: kColorWhite,
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
                                      AppDropdown(
                                        items: [],
                                        hintText: 'Product',
                                        onChanged: (value) {},
                                      ),
                                      AppSpaces.v10,
                                      AppTextFormField(
                                        controller: TextEditingController(),
                                        hintText: 'Qty',
                                        keyboardType: TextInputType.number,
                                      ),
                                      AppSpaces.v10,
                                      AppTextFormField(
                                        controller: TextEditingController(),
                                        hintText: 'Rate',
                                        keyboardType: TextInputType.number,
                                      ),
                                      AppSpaces.v10,
                                      AppTextFormField(
                                        controller: TextEditingController(),
                                        hintText: 'Amount',
                                        keyboardType: TextInputType.number,
                                      ),
                                      AppSpaces.v20,
                                      AppButton(
                                        title: 'Add',
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      AppSpaces.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                '₹ 1000',
                                style: TextStyles.kBoldDMSans(
                                  fontSize: FontSizes.k20FontSize,
                                ),
                              ),
                            ],
                          ),
                          AppButton(
                            buttonWidth: 0.5.screenWidth,
                            title: 'Save',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
