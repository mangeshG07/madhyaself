import 'package:madhya/core/exporters/app_export.dart';

class PlanController extends GetxController {
  final GetPlanUsecase _getPlanUsecase;
  final GetPlanDetailsUsecase _getPlanDetailsUsecase;
  final CheckoutUsecase _checkoutUsecase;
  final VerifyPaymentUsecase _verifyPaymentUsecase;

  PlanController(
    this._getPlanUsecase,
    this._getPlanDetailsUsecase,
    this._checkoutUsecase,
    this._verifyPaymentUsecase,
  );

  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isCheckOutLoading = false.obs;
  final selectedType = 0.obs;
  final planList = [].obs;
  final paymentMethods = [].obs;
  final planDetails = {}.obs;
  final selectedPayment = 0.obs;
  final selectedPaymentId = ''.obs;
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
        planDetails.value = response['data']['plan_details'] ?? {};
        paymentMethods.value = response['data']['payment_methods'] ?? [];
      }
    } finally {
      isDetailsLoading(false);
    }
  }

  Future<void> checkout(
    String planId,
    String price,
    String paymentMethod,
    String type,
  ) async {
    try {
      isCheckOutLoading(true);

      final userid = await SecureStorageService.read('user_id') ?? '';
      final response = await _checkoutUsecase(
        CheckoutRequest(userid, planId, price, paymentMethod, type),
      );
      if (response['common']['status'] == true) {
        final checkoutRes = response['data'] ?? {};
        openRazorPaySession(
          email: checkoutRes['email'] ?? '',
          number: checkoutRes['mobile_no'] ?? '',
          orderId: checkoutRes['razorpayOrderId'] ?? '',
          price: int.parse(price),
          productName: name,
          key: key,
        );
        print('response');
        print(response);
      }
    } finally {
      isCheckOutLoading(false);
    }
  }

  Future<void> verifyPayment(
    String razorpayId,
    String orderId,
    String payId,
    String signature,
    String status,
  ) async {
    try {
      isCheckOutLoading(true);

      final userid = await SecureStorageService.read('user_id') ?? '';
      final response = await _verifyPaymentUsecase(
        VerifyPaymentRequest(
          userid,
          razorpayId,
          razorpayId,
          payId,
          signature,
          status,
        ),
      );
      if (response['common']['status'] == true) {}
    } finally {
      isCheckOutLoading(false);
    }
  }


  final Razorpay _razorpay = Razorpay();

  void openRazorPaySession({
    required int price,
    required String productName,
    required String number,
    required String email,
    required String orderId,
    required String key,
  }) {
    try {
      var options = {
        'key': key,
        'amount': price * 100,
        'name': productName,
        'description': '',
        'order_id': orderId,
        'prefill': {'contact': number, 'email': email},
      };
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        handlePaymentSuccessResponse,
      );
      _razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        handleExternalWalletSelected,
      );

      _razorpay.open(options);
    } finally {}
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
    verifyPayment('', '', selectedPaymentId.value, '2', '');
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    verifyPayment(
      response.paymentId!,
      response.orderId!,
      selectedPaymentId.value,
      '1',
      response.signature!,
    );

    // checkStatus(
    //   orderId: response.paymentId!,
    //   paymentHistoryId: controller.orderId.value,
    //   reason: response.paymentId!,
    //   response: response,
    //   status: 'Success',
    // );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog("External Wallet Selected", "${response.walletName}");
    // checkStatus(
    //   orderId: '',
    //   paymentHistoryId: controller.orderId.value,
    //   reason: response.walletName!,
    //   response: response,
    //   status: 'Failed',
    // );
  }

  void showAlertDialog(String title, String message) {
    // set up the buttons
    // Widget continueButton = ElevatedButton(
    //   child: const Text("Continue"),
    //   onPressed: () {},
    // );
    // // set up the AlertDialog
    AlertDialog alert = AlertDialog(title: Text(title), content: Text(message));
    // show the dialog

    Get.dialog(alert);
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }
}
