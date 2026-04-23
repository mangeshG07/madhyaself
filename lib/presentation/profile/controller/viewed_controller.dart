import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class ViewedController extends GetxController with PaginationMixin {
  final GetViewUsecase _getViewUsecase;

  ViewedController(this._getViewUsecase);

  final selectedType = 0.obs;

  Future<void> getViewList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _getViewUsecase.call(
        UserRequest(
          userid,
          type: selectedType.value == 0 ? '' : 'viewed_by_me',
          pageNo: currentPage.toString(),
        ),
      );
      if (response['common']['status'] == true) {
        final List list = response['data']['view_data'] ?? [];

        handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }
}
