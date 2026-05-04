import '../../../core/exporters/app_export.dart';

class PartnerPrefsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferenceController>(
      () => PreferenceController(
        getIt<GetPartPrefUsecase>(),
        getIt<CommonDataUsecase>(),
        getIt<LocationDataUsecase>(),
        getIt<UpdatePrefsUsecase>(),
      ),
    );

    // Get.lazyPut<PartnerPreferenceRepository>(
    //   () => PartnerPreferenceRepositoryImpl(Get.find()),
    // );
    // Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    // Get.lazyPut(() => CommonDataUsecase(Get.find()));
    // Get.lazyPut(() => LocationDataUsecase(Get.find()));
    // Get.lazyPut(() => GetPartPrefUsecase(Get.find()));
    // Get.lazyPut(() => UpdatePrefsUsecase(Get.find()));
    // Get.lazyPut(
    //   () =>
    //       PreferenceController(Get.find(), Get.find(), Get.find(), Get.find()),
    // );
  }
}
