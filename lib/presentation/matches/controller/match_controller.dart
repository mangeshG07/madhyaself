import 'package:madhya/core/exporters/app_export.dart';

class MatchController extends GetxController with PaginationMixin {
  final GetMatchesUsecase _getMatchesUsecase;
  MatchController(this._getMatchesUsecase);

  final selectedCategory = '0'.obs;
  final selectedFilter = RxnString();
  final category = [
    {'name': 'All Matches', 'icon': HugeIcons.strokeRoundedUserMultiple02},
    {'name': 'Top Matches', 'icon': HugeIcons.strokeRoundedDashboardSpeed01},
    {'name': 'New Profiles', 'icon': HugeIcons.strokeRoundedUserLove02},
    {'name': 'Premium Profiles', 'icon': HugeIcons.strokeRoundedCrown},
    {'name': 'Nearby Matches', 'icon': HugeIcons.strokeRoundedLocation04},
  ].obs;

  Future<void> getMatchList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _getMatchesUsecase.call(
        UserRequest(
          userid,
          type: selectedCategory.value.toString(),
          pageNo: currentPage.toString(),
          view: selectedFilter.value ?? '1',
        ),
      );
      if (response['common']['status'] == true) {
        final List list = response['data']['matches'] ?? [];

        handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }
}
