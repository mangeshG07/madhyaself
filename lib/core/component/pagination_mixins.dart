import 'package:get/get.dart';

mixin PaginationMixin<T> {
  final RxBool isLoading = false.obs;
  final RxBool isLoadMore = false.obs;

  final RxList<T> items = <T>[].obs;

  int currentPage = 1;
  int perPage = 10;
  bool hasMore = true;

  void resetPagination() {
    currentPage = 1;
    hasMore = true;
    items.clear();
  }

  void startLoading({bool showLoading = true}) {
    currentPage == 1 ? isLoading.value = showLoading : isLoadMore.value = true;
  }

  void handleSuccess(List<T> newItems) {
    if (currentPage == 1) {
      items.assignAll(newItems);
    } else {
      items.addAll(newItems);
    }

    hasMore = newItems.length >= perPage;
    if (hasMore) currentPage++;
  }

  void stopLoading() {
    isLoading.value = false;
    isLoadMore.value = false;
  }
}
