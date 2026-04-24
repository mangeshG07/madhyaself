import 'package:madhya/core/exporters/app_export.dart';

class ReportedController extends GetxController with PaginationMixin {
  final ReportedProfileUsecase _reportedProfileUsecase;

  ReportedController(this._reportedProfileUsecase);

  Future<void> getReportList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _reportedProfileUsecase.call(UserRequest(userid));
      if (response['common']['status'] == true) {
        final List list = response['data'] ?? [];

        handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }
}
