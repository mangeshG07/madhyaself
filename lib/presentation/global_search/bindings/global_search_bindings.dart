import 'package:madhya/core/exporters/app_export.dart';

class GlobalSearchBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find()));

    Get.lazyPut(() => LocationDataUsecase(Get.find()));
    Get.lazyPut(() => CommonDataUsecase(Get.find()));

    Get.lazyPut(() => GlobalSearchController(Get.find(), Get.find()));
  }
}
