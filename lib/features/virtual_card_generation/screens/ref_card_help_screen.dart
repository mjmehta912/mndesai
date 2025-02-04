import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/virtual_card_generation/controllers/ref_card_help_controller.dart';
import 'package:mndesai/features/virtual_card_generation/controllers/virtual_card_generation_controller.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';
import 'package:mndesai/utils/screen_utils/app_spacings.dart';
import 'package:mndesai/widgets/app_appbar.dart';
import 'package:mndesai/widgets/app_text_form_field.dart';

class RefCardHelpScreen extends StatelessWidget {
  RefCardHelpScreen({
    super.key,
  });

  final RefCardHelpController _controller = Get.put(
    RefCardHelpController(),
  );

  final VirtualCardGenerationController virtualCardGenerationController =
      Get.find<VirtualCardGenerationController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppAppbar(
          title: 'Cards',
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: kColorTextPrimary,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _controller.fetchRefCards();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                AppTextFormField(
                  controller: _controller.searchController,
                  hintText: 'Search Card',
                  suffixIcon: const Icon(
                    Icons.search,
                  ),
                  onChanged: (query) {
                    _controller.searchQuery.value = query;
                  },
                ),
                AppSpaces.v12,
                Obx(
                  () {
                    if (_controller.isLoading.value) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kColorPrimary,
                          ),
                        ),
                      );
                    }
                    if (_controller.refCards.isEmpty &&
                        !_controller.isLoading.value) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'No Cards found.',
                            style: TextStyles.kMediumDMSans(
                              fontSize: FontSizes.k18FontSize,
                            ),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification &&
                              scrollNotification.metrics.extentAfter == 0) {
                            _controller.fetchRefCards(
                              loadMore: true,
                            );
                          }
                          return false;
                        },
                        child: Obx(
                          () => ListView.builder(
                            itemCount: _controller.refCards.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _controller.refCards.length) {
                                return _controller.isLoadingMore.value
                                    ? Padding(
                                        padding: AppPaddings.p16,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: kColorPrimary,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }
                              final refCard = _controller.refCards[index];
                              return GestureDetector(
                                onTap: () {
                                  virtualCardGenerationController
                                      .refCardNoController
                                      .text = refCard.cardNo.toString();
                                  Get.back();
                                },
                                child: Card(
                                  color: kColorWhite,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: kColorTextPrimary,
                                      )),
                                  child: Padding(
                                    padding: AppPaddings.p10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          refCard.name,
                                          style: TextStyles.kMediumDMSans(
                                            fontSize: FontSizes.k18FontSize,
                                            color: kColorPrimary,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              refCard.cardNo.toString(),
                                              style: TextStyles.kBoldDMSans(
                                                fontSize: FontSizes.k16FontSize,
                                              ).copyWith(
                                                height: 1.25,
                                              ),
                                            ),
                                            Text(
                                              refCard.mobileNo,
                                              style: TextStyles.kBoldDMSans(
                                                fontSize: FontSizes.k16FontSize,
                                              ).copyWith(
                                                height: 1.25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
