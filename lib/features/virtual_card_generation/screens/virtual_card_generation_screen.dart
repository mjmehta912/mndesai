import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/virtual_card_generation/controllers/virtual_card_generation_controller.dart';
import 'package:mndesai/utils/formatters/text_input_formatters.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_button.dart';
import 'package:mndesai/widgets/app_date_picker_field.dart';
import 'package:mndesai/widgets/app_dropdown_search.dart';
import 'package:mndesai/widgets/app_loading_overlay.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class VirtualCardGenerationScreen extends StatefulWidget {
  const VirtualCardGenerationScreen({
    super.key,
  });

  @override
  State<VirtualCardGenerationScreen> createState() =>
      _VirtualCardGenerationScreenState();
}

class _VirtualCardGenerationScreenState
    extends State<VirtualCardGenerationScreen> {
  final VirtualCardGenerationController _controller = Get.put(
    VirtualCardGenerationController(),
  );

  @override
  void initState() {
    super.initState();

    _controller.birthDateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    _controller.cardIssueDateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
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
              title: 'Virtual Card Generation',
            ),
            body: Padding(
              padding: AppPaddings.p14,
              child: SingleChildScrollView(
                child: Form(
                  key: _controller.virtualCardFenerationFormKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        controller: _controller.mobileNoController,
                        hintText: 'Mobile No.',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (value.length != 10) {
                            return 'Please enter a 10-digit mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MobileNumberInputFormatter(),
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      AppSpaces.v10,
                      AppTextFormField(
                        controller: _controller.nameController,
                        hintText: 'Name',
                      ),
                      AppSpaces.v10,
                      AppDatePickerTextFormField(
                        dateController: _controller.birthDateController,
                        hintText: 'Birth Date',
                      ),
                      AppSpaces.v10,
                      AppTextFormField(
                        controller: _controller.availableCardNoController,
                        hintText: 'Available Card No.',
                      ),
                      AppSpaces.v10,
                      AppDatePickerTextFormField(
                        dateController: _controller.cardIssueDateController,
                        hintText: 'Card Issue Date',
                      ),
                      AppSpaces.v10,
                      Obx(
                        () => AppDropdown(
                          items: [],
                          hintText: 'Ref. Card No.',
                          onChanged: (value) {
                            _controller.selectedRefCardNo.value = value!;
                          },
                          selectedItem:
                              _controller.selectedRefCardNo.value.isNotEmpty
                                  ? _controller.selectedRefCardNo.value
                                  : null,
                        ),
                      ),
                      AppSpaces.v20,
                      AppButton(
                        title: 'Allot & Send SMS',
                        onPressed: () {
                          if (_controller
                              .virtualCardFenerationFormKey.currentState!
                              .validate()) {}
                        },
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
