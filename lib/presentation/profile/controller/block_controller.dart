import 'package:madhya/core/exporters/app_export.dart';

class BlockController extends GetxController with PaginationMixin<dynamic> {
  final BlockedProfileUsecase _blockUserUsecase;

  BlockController(this._blockUserUsecase);

  Future<void> getBlockList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _blockUserUsecase.call(UserRequest(userid));
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
