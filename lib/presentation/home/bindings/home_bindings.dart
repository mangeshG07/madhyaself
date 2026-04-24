import 'package:madhya/core/exporters/app_export.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(Get.find()));
    Get.lazyPut(() => HomeUsecase(Get.find()));

    Get.lazyPut(() => HomeController(Get.find()));
  }
}
