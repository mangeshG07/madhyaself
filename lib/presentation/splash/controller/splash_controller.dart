import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class SplashController extends GetxController {
  void checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final isOnboarded = await LocalStorage.getBool('isOnboarded') ?? false;

    final token = await SecureStorageService.read('token') ?? '';

    /// ✅ 1. First check onboarding
    if (isOnboarded != true) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }

    /// ✅ 2. Then check login
    if (token.isEmpty) {
      Get.offAllNamed(Routes.login);
    } else {
      Get.offAllNamed(Routes.mainScreen);
    }
  }
}
