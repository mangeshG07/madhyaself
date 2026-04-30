import 'package:madhya/core/exporters/app_export.dart';

class PlanController extends GetxController {
  final GetPlanUsecase _getPlanUsecase;
  final GetPlanDetailsUsecase _getPlanDetailsUsecase;

  PlanController(this._getPlanUsecase, this._getPlanDetailsUsecase);

  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final selectedType = 0.obs;
  final planList = [].obs;
  final paymentMethods = [].obs;
  final planDetails = {}.obs;

  Future<void> getPlans() async {
    try {
      isLoading(true);

      final userid = await SecureStorageService.read('user_id') ?? '';
      final response = await _getPlanUsecase(UserRequest(userid));
      if (response['common']['status'] == true) {
        planList.value = response['data'] ?? [];
      } else {
        planList.value = [];
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> getPlanDetails(String planId) async {
    try {
      isDetailsLoading(true);

      final userid = await SecureStorageService.read('user_id') ?? '';
      final response = await _getPlanDetailsUsecase(
        UserRequest(userid, type: planId),
      );
      if (response['common']['status'] == true) {
        planList.value = response['data']['plan_details'] ?? {};
        paymentMethods.value = response['data']['payment_methods'] ?? [];
      }
    } finally {
      isDetailsLoading(false);
    }
  }
}
