import 'package:in_app_purchase/in_app_purchase.dart';
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

  /// =========================================
  /// COMMON VARIABLES
  /// =========================================

  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isCheckOutLoading = false.obs;

  final selectedType = 0.obs;

  final onlinePlans = [].obs;
  final offlinePlans = [].obs;

  final paymentMethods = [].obs;
  final planDetails = {}.obs;

  final selectedPayment = 0.obs;
  final selectedPaymentId = ''.obs;

  /// =========================================
  /// APPLE IAP VARIABLES
  /// =========================================
  ///
  final InAppPurchase iap = InAppPurchase.instance;

  late StreamSubscription<List<PurchaseDetails>> purchaseSubscription;

  final products = <ProductDetails>[].obs;

  final productIds = {
    'com.madhyasthi.app.basic',
    'com.madhyasthi.app.standard',
    'com.madhyasthi.app.marry',
    'com.madhyasthi.app.premium',
    'com.madhyasthi.app.assisted',
    'com.madhyasthi.app.marry2',
  };

  Future<void> getPlans() async {
    try {
      isLoading(true);

      final userid = await SecureStorageService.read('user_id') ?? '';
      final response = await _getPlanUsecase(UserRequest(userid));
      if (response['common']['status'] == true) {
        dynamic plans;

        if(Platform.isAndroid){
          plans = response['data']['android_plans'] ?? [];
        }else{
          plans = response['data']['ios_plans'] ?? [];
        }
        // planList.value = response['data'] ?? [];
        onlinePlans.value = plans
            .where((e) => e['plan_status'] == 'online')
            .toList();

        offlinePlans.value = plans
            .where((e) => e['plan_status'] == 'offline')
            .toList();
      } else {
        _clearPlans();
      }
    } finally {
      isLoading(false);
    }
  }

  void _clearPlans() {
    onlinePlans.clear();
    offlinePlans.clear();
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
    String key,
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
          number: checkoutRes['mobile_no'] ?? '',
          orderId: checkoutRes['razorpayOrderId'] ?? '',
          price: int.parse(price),
          productName: checkoutRes['name'] ?? '',
          key: key,
        );
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
          orderId,
          payId,
          signature,
          status,
        ),
      );
      if (response['common']['status'] == true) {
        if (response['data']['payment_status'] == 'success') {
          AllDialogs().showOrderSuccessDialog(
            () {
              Get.offAllNamed(Routes.mainScreen);
            },
            "",
            response['common']['message'],
          );
        }
      } else {
        AllDialogs().showOrderSuccessDialog(
          () {
            Get.back();
          },
          "Order is Failed....",
          response['common']['message'],
        );
      }
    } finally {
      isCheckOutLoading(false);
    }
  }

  /// =========================================
  /// RAZORPAY
  /// =========================================
  final Razorpay _razorpay = Razorpay();

  void openRazorPaySession({
    required int price,
    required String productName,
    required String number,
    // required String email,
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
        'prefill': {'contact': '+91$number'},
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
    // showAlertDialog(
    //   "Payment Failed",
    //   "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    // );
    verifyPayment('', '', selectedPaymentId.value, '', '2');
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    await verifyPayment(
      response.paymentId!,
      response.orderId!,
      selectedPaymentId.value,
      response.signature!,
      '1',
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    // showAlertDialog("External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(String title, String message) {
    AlertDialog alert = AlertDialog(title: Text(title), content: Text(message));

    Get.dialog(alert);
  }

  /// =========================================
  /// INIT
  /// =========================================

  @override
  void onInit() {
    super.onInit();

    if (Platform.isIOS) {
      initAppleIAP();
    }
  }

  @override
  void onClose() {
    if (Platform.isIOS) {
      purchaseSubscription.cancel();
    }

    _razorpay.clear();

    super.onClose();
  }

  /// =========================================
  /// APPLE IAP INIT
  /// =========================================

  Future<void> initAppleIAP() async {
    final bool available = await iap.isAvailable();
      print('available=====>$available');
    if (!available) {
      debugPrint("Apple IAP Not Available");
      return;
    }

    /// Listen Purchase Updates
    purchaseSubscription = iap.purchaseStream.listen(listenToPurchaseUpdated);
    print('purchaseSubscription=====>$purchaseSubscription');
    /// Load Products
    await loadProducts();
  }

  /// =========================================
  /// LOAD APPLE PRODUCTS
  /// =========================================

  Future<void> loadProducts() async {
    try {
      final ProductDetailsResponse response = await iap.queryProductDetails(
        productIds,
      );
      print('response= ProductDetailsResponse====>$response');

      if (response.error != null) {
        print('response.error====>${response.error}');
        debugPrint(response.error.toString());
      }
      print('esponse.productDetails====>${response.productDetails}');
      products.value = response.productDetails;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// =========================================
  /// BUY APPLE SUBSCRIPTION
  /// =========================================

  Future<void> buyApplePlan(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      await iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// =========================================
  /// PURCHASE LISTENER
  /// =========================================

  Future<void> listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          debugPrint("Payment Pending");
          break;

        case PurchaseStatus.purchased:
          debugPrint("Payment Success");

          await verifyApplePayment(purchase);

          break;

        case PurchaseStatus.restored:
          debugPrint("Purchase Restored");

          await verifyApplePayment(purchase);

          break;

        case PurchaseStatus.error:
          debugPrint(purchase.error.toString());

          Get.snackbar("Failed", "Payment Failed");

          break;

        case PurchaseStatus.canceled:
          debugPrint("Cancelled");
          break;
      }

      /// IMPORTANT
      if (purchase.pendingCompletePurchase) {
        await iap.completePurchase(purchase);
      }
    }
  }

  /// =========================================
  /// VERIFY APPLE PAYMENT
  /// =========================================

  Future<void> verifyApplePayment(PurchaseDetails purchase) async {
    try {
      isCheckOutLoading(true);

      // final userid = await SecureStorageService.read('user_id') ?? '';

      /// APPLE RECEIPT
    // purchase.verificationData.serverVerificationData;


      verifyPayment(
        purchase.productID,
        purchase.purchaseID!,
        selectedPaymentId.value,
        // response.signature!,
        ''
        '','1'
      );


      // final response = await _verifyPaymentUsecase(
      //   VerifyPaymentRequest(
      //     userid,
      //
      //     /// product id
      //     purchase.productID,
      //
      //     /// transaction id
      //     purchase.purchaseID ?? '',
      //
      //     /// receipt
      //     receipt,
      //
      //     /// success
      //     '1',
      //   ),
      // );
      //
      // if (response['common']['status'] == true) {
      //   if (response['data']['payment_status'] == 'success') {
      //     AllDialogs().showOrderSuccessDialog(
      //       () {
      //         Get.offAllNamed(Routes.mainScreen);
      //       },
      //       "",
      //       response['common']['message'],
      //     );
      //   }
      // } else {
      //   Get.snackbar("Failed", response['common']['message']);
      // }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isCheckOutLoading(false);
    }
  }

  /// =========================================
  /// RESTORE PURCHASE
  /// =========================================

  Future<void> restorePurchase() async {
    try {
      await iap.restorePurchases();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}


// 1. Upload build
// 2. Wait 30 mins
// 3. Logout sandbox
// 4. Restart iPhone
// 5. Login sandbox again
// 6. Reinstall app
// 7. Test again