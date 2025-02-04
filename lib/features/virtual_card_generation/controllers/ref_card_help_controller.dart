import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mndesai/features/virtual_card_generation/models/card_help_dm.dart';
import 'package:mndesai/features/virtual_card_generation/repositories/virtual_card_generation_repo.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';

class RefCardHelpController extends GetxController {
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  var isFetchingData = false;

  var refCards = <CardHelpDm>[].obs;

  var searchController = TextEditingController();
  var searchQuery = ''.obs;

  var currentPage = 1;
  var pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchRefCards();
    debounceSearchQuery();
  }

  void debounceSearchQuery() {
    debounce(
      searchQuery,
      (_) => fetchRefCards(),
      time: const Duration(
        milliseconds: 300,
      ),
    );
  }

  Future<void> fetchRefCards({
    bool loadMore = false,
  }) async {
    if (loadMore && !hasMoreData.value) return;
    if (isFetchingData) return;
    try {
      isFetchingData = true;
      if (!loadMore) {
        isLoading.value = true;
        currentPage = 1;
        refCards.clear();
      } else {
        isLoadingMore.value = true;
      }

      var fetchedCards = await VirtualCardGenerationRepo.getRefCardNos(
        pageIndex: currentPage,
        pageSize: pageSize,
        searchText: searchQuery.value,
      );

      if (fetchedCards.isNotEmpty) {
        refCards.addAll(fetchedCards);
        currentPage++;
      } else {
        hasMoreData(false);
      }
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isFetchingData = false;
    }
  }
}
