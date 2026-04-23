import 'package:madhya/core/exporters/app_export.dart';

class OtherProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherUserRepository>(
      () => OtherProfileRepositoryImpl(Get.find()),
    );
    Get.lazyPut(() => OtherProfileUsecase(Get.find()));
    Get.lazyPut(() => BlockUserUsecase(Get.find()));
    Get.lazyPut(() => ReportProfileUsecase(Get.find()));
    Get.lazyPut(
      () => OtherProfileController(Get.find(), Get.find(), Get.find()),
    );
  }
}
