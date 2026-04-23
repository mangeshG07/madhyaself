import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class ShortlistController extends GetxController with PaginationMixin {
  final GetShortlistUsecase _getShortlistUsecase;
  final ShortlistProfileUsecase _shortlistProfileUsecase;

  ShortlistController(this._getShortlistUsecase, this._shortlistProfileUsecase);

  final selectedType = 0.obs;

  Future<void> getShortList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _getShortlistUsecase.call(
        UserRequest(
          userid,
          type: selectedType.value == 0 ? '' : 'shortlisted_by_me',
          pageNo: currentPage.toString(),
        ),
      );
      if (response['common']['status'] == true) {
        final List list = response['data']['shortlisted_data'] ?? [];

        handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }

  RxBool isSuccess = false.obs;
  RxBool isShortListing = false.obs;

  Future<void> shortListPeople(String receiverId) async {
    isShortListing(true);
    isSuccess(false);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _shortlistProfileUsecase.call(
        InterestRequested(userid, receiverId),
      );
      if (response['common']['status'] == true) {
        isSuccess(true);
        Get.snackbar(
          'Success',
          response['common']['message'],
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          'Failed',
          response['common']['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isShortListing(false);
    }
  }
}
