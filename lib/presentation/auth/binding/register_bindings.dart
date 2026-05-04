import '../../../core/exporters/app_export.dart';

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(
        getIt<CommonDataUsecase>(),
        getIt<RegisterUsecase>(),
        getIt<CasteByRelUsecase>(),
        getIt<SubCasteByCasteUsecase>(),
      ),
    );
  }
}
