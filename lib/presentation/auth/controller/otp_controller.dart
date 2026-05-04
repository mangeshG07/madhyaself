import 'package:madhya/core/exporters/app_export.dart';

class OtpController extends GetxController with CodeAutoFill {
  final VerifyOtpUsecase verifyOtpUsecase;
  OtpController(this.verifyOtpUsecase);

  final otpController = TextEditingController();
  final verifyKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final start = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    startTimer();
    listenForCode();
    SmsAutoFill().getAppSignature;
    super.onInit();
  }

  @override
  void codeUpdated() {
    if (code != null) {
      otpController.text = extractOtp(code!);
    }
  }

  void startTimer() {
    start.value = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (start.value == 0) {
        _timer?.cancel();
      } else {
        start.value--;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  /// Extract OTP from full SMS
  String extractOtp(String sms) {
    final exp = RegExp(r'\b\d{6}\b');
    return exp.firstMatch(sms)?.group(0) ?? "";
  }

  Future<void> verifyOTP(String number) async {
    if (!verifyKey.currentState!.validate()) return;
    try {
      isLoading(true);
      final response = await verifyOtpUsecase.call(
        VerifyOtpRequest(phone: number, otp: otpController.text),
      );
      if (response['common']['status'] == true) {
        await SecureStorageService.write('token', response['user']['auth_key']);
        await SecureStorageService.write(
          'user_id',
          response['user']['id'].toString(),
        );

        Get.snackbar('Success', response['common']['message']);

        if (response['user']['is_user_exist'] == true) {
          Get.offAllNamed(Routes.mainScreen);
        } else {
          Get.offAllNamed(Routes.registerScreen);
        }
      } else {
        Get.snackbar('Failed', response['common']['message']);
        if (response['data']['is_user_exist'] == false) {
          Get.toNamed(Routes.registerScreen);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    SmsAutoFill().unregisterListener();
    otpController.dispose();
    super.onClose();
  }
}
