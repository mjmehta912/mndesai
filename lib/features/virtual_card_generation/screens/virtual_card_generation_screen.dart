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

    _controller.mobileNoController.clear();
    _controller.nameController.clear();
    _controller.refCardNoController.clear();

    _controller.birthDateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );

    initialize();
  }

  void initialize() async {
    await _controller.getCardNo();

    if (_controller.cardData.value != null) {
      _controller.availableCardNoController.text =
          _controller.cardData.value!.cardNo.toString();
    }
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
              child: Column(
                children: [
                  Expanded(
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Card no. cannot be empty';
                                }
                                return null;
                              },
                            ),
                            AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.refCardNoController,
                              hintText: 'Ref. Card No.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    title: 'Allot',
                    onPressed: () async {
                      if (_controller.virtualCardFenerationFormKey.currentState!
                          .validate()) {
                        await _controller.generateVirtualCard();

                        _controller.mobileNoController.clear();
                        _controller.nameController.clear();
                        _controller.refCardNoController.clear();
                        _controller.birthDateController.text =
                            DateFormat('dd-MM-yyyy').format(
                          DateTime.now(),
                        );

                        await _controller.getCardNo();
                        if (_controller.cardData.value != null) {
                          _controller.availableCardNoController.text =
                              _controller.cardData.value!.cardNo.toString();
                        }
                      }
                    },
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
}
