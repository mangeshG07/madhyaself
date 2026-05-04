import 'package:madhya/core/exporters/app_export.dart';

class InterestController extends GetxController with PaginationMixin {
  final GetInterestUsecase _getInterestUsecase;
  final UpdateInterestUsecase _updateInterestUsecase;
  final DeleteInterestUsecase _deleteInterestUsecase;
  final SendInterestUsecase _sendInterestUsecase;

  InterestController(
    this._getInterestUsecase,
    this._updateInterestUsecase,
    this._deleteInterestUsecase,
    this._sendInterestUsecase,
  );

  final selectedType = 0.obs;

  final List<String> labels = [
    'All',
    'Received',
    'Sent',
    'Accepted',
    'Declined',
  ];

  Future<void> getInterestList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';
    try {
      final response = await _getInterestUsecase.call(
        UserRequest(
          userid,
          type: selectedType.value.toString(),
          pageNo: currentPage.toString(),
        ),
      );
      if (response['common']['status'] == true) {
        final List list = response['data']['interest_data'] ?? [];

        handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }

  final isDeleting = false.obs;
  final isSending = false.obs;
  final isUpdating = false.obs;

  RxString deletingId = ''.obs;
  RxBool isSuccess = false.obs;

  Future<void> sendInterest(String receiverId, String msg) async {
    isSending(true);
    isSuccess(false);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _sendInterestUsecase.call(
        InterestRequested(userid, receiverId, status: msg),
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
        Get.back();
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
      isSending(false);
    }
  }

  Future<void> deleteInterest(String interestId) async {
    deletingId.value = interestId;
    isDeleting(true);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _deleteInterestUsecase.call(
        InterestRequested(userid, interestId),
      );
      if (response['common']['status'] == true) {
        Get.snackbar('Success', response['common']['message']);
        await getInterestList(isRefresh: true);
      } else {
        Get.snackbar('Failed', response['common']['message']);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      deletingId.value = '';
      isDeleting(false);
    }
  }

  Future<void> updateInterest(String interestId, String status) async {
    deletingId.value = interestId;
    isUpdating(true);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _updateInterestUsecase.call(
        InterestRequested(userid, interestId, status: status),
      );
      if (response['common']['status'] == true) {
        Get.snackbar('Success', response['common']['message']);
        await getInterestList(isRefresh: true);
      } else {
        Get.snackbar('Failed', response['common']['message']);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      deletingId.value = '';
      isUpdating(false);
    }
  }
}
