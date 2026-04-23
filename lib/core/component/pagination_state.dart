

import '../exporters/app_export.dart';

class PaginationState<T> {
  final RxBool isLoading = false.obs;
  final RxBool isLoadMore = false.obs;
  final RxList<T> items = <T>[].obs;

  int currentPage = 1;
  int perPage = 10;
  bool hasMore = true;

  void reset() {
    currentPage = 1;
    hasMore = true;
    items.clear();
  }

  void startLoading({bool showLoading = true}) {
    currentPage == 1 ? isLoading.value = showLoading : isLoadMore.value = true;
  }

  void handleSuccess(List<T> newItems, {bool isOthers = false}) {
    if (isOthers) {
      items.addAll(newItems);
    } else {
      if (currentPage == 1) {
        items.assignAll(newItems);
      } else {
        items.addAll(newItems);
      }
    }

    hasMore = newItems.length >= perPage;
    if (hasMore) currentPage++;
  }

  void stopLoading() {
    isLoading.value = false;
    isLoadMore.value = false;
  }
}
