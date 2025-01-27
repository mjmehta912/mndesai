import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/bill_entry/controllers/bill_entry_controller.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _controller.billEntryFormKey,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppTextFormField(
                                    controller: TextEditingController(),
                                    hintText: 'Vehicle Reg.',
                                  ),
                                ),
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppTextFormField(
                                    controller: TextEditingController(),
                                    hintText: 'Vehicle No.',
                                  ),
                                ),
                              ],
                            ),
                            AppSpaces.v10,
                            AppDropdown(
                              items: [],
                              hintText: 'Vehicle No.',
                              onChanged: (value) {},
                            ),
                            AppSpaces.v10,
                            AppTextFormField(
                              controller: TextEditingController(),
                              hintText: 'Remark',
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
                                              controller:
                                                  TextEditingController(),
                                              hintText: 'Qty',
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            AppSpaces.v10,
                                            AppTextFormField(
                                              controller:
                                                  TextEditingController(),
                                              hintText: 'Rate',
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            AppSpaces.v10,
                                            AppTextFormField(
                                              controller:
                                                  TextEditingController(),
                                              hintText: 'Amount',
                                              keyboardType:
                                                  TextInputType.number,
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
                          ],
                        ),
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
