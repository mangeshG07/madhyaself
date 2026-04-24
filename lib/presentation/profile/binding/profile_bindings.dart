import '../../../core/exporters/app_export.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));

    // Profile repository
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find()));

    // Usecases
    Get.lazyPut(() => ProfileUsecase(Get.find()));
    Get.lazyPut(() => CommonDataUsecase(Get.find()));
    Get.lazyPut(() => GetViewUsecase(Get.find()));
    Get.lazyPut(() => GetShortlistUsecase(Get.find()));
    Get.lazyPut(() => GetInterestUsecase(Get.find()));
    Get.lazyPut(() => DeleteInterestUsecase(Get.find()));
    Get.lazyPut(() => UpdateInterestUsecase(Get.find()));
    Get.lazyPut(() => SendInterestUsecase(Get.find()));
    Get.lazyPut(() => UpdateProfileUsecase(Get.find()));
    Get.lazyPut(() => LocationDataUsecase(Get.find()));
    Get.lazyPut(() => ShortlistProfileUsecase(Get.find()));
    Get.lazyPut(() => GetPageUsecase(Get.find()));
    Get.lazyPut(() => GetPageDetailsUsecase(Get.find()));
    Get.lazyPut(() => ShortlistProfileUsecase(Get.find()));
    Get.lazyPut(() => BlockedProfileUsecase(Get.find()));
    Get.lazyPut(() => ReportedProfileUsecase(Get.find()));

    // Controllers
    Get.lazyPut(
      () => ProfileController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
    Get.lazyPut(() => ViewedController(Get.find()));
    Get.lazyPut(() => BlockController(Get.find()));
    Get.lazyPut(() => ReportedController(Get.find()));
    Get.lazyPut(() => ShortlistController(Get.find(), Get.find()));
    Get.lazyPut(
      () => InterestController(Get.find(), Get.find(), Get.find(), Get.find()),
    );
  }
}
