import 'package:madhya/core/exporters/app_export.dart';

class LoginController extends GetxController {
  final LoginUsecase _loginUsecase;

  LoginController(this._loginUsecase);

  final numberController = TextEditingController();
  final loginKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  void login() async {
    if (!loginKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _loginUsecase(
        LoginRequest(numberController.text.trim()),
      );

      if (response['common']['status'] == true) {
        Get.snackbar('Success', response['common']['message']);
        Get.toNamed(Routes.verifyOTP);
      }
    } catch (e) {
      AppLogger.error(e);
    } finally {
      isLoading.value = false;
    }
  }
}
