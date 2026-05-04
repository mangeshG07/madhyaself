import '../../../core/exporters/app_export.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController(getIt<VerifyOtpUsecase>()));

    // Get.lazyPut(() => VerifyOtpUsecase(Get.find()));
    // Get.lazyPut(() => OtpController(Get.find()));
  }
}
