import 'package:madhya/core/exporters/app_export.dart';

class NotificationController extends GetxController
    with PaginationMixin<dynamic> {
  final GetNotificationUsecase _getNotificationUsecase;
  final ReadNotification _notification;

  NotificationController(this._getNotificationUsecase, this._notification);

  // =================== FETCH NOTIFICATION DATA ===================
  Future<void> getNotificationList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _getNotificationUsecase.call(
        UserRequest(userid, pageNo: currentPage.toString()),
      );
      if (response['common']['status'] == true) {
        final List list = response['data'] ?? [];

        handleSuccess(list);
      }
    } catch (_) {
      // debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }

  Future<void> readNotification(String notificationId) async {
    try {
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _notification.call(
        UserRequest(userid, view: notificationId),
      );

      if (res['common']['status'] == true) {
        await getNotificationList(isRefresh: true);
      }
    } finally {}
  }
}
