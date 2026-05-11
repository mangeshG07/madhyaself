import '../../../core/exporters/app_export.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    //
    // // Profile repository
    // Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find()));
    //
    // Get.lazyPut(() => ProfileUsecase(Get.find()));
    // Get.lazyPut(() => CommonDataUsecase(Get.find()));
    // Get.lazyPut(() => GetViewUsecase(Get.find()));
    // Get.lazyPut(() => GetShortlistUsecase(Get.find()));
    // Get.lazyPut(() => GetInterestUsecase(Get.find()));
    // Get.lazyPut(() => DeleteInterestUsecase(Get.find()));
    // Get.lazyPut(() => UpdateInterestUsecase(Get.find()));
    // Get.lazyPut(() => SendInterestUsecase(Get.find()));
    // Get.lazyPut(() => UpdateProfileUsecase(Get.find()));
    // Get.lazyPut(() => LocationDataUsecase(Get.find()));
    // Get.lazyPut(() => ShortlistProfileUsecase(Get.find()));
    // Get.lazyPut(() => GetPageUsecase(Get.find()));
    // Get.lazyPut(() => GetPageDetailsUsecase(Get.find()));
    // Get.lazyPut(() => BlockedProfileUsecase(Get.find()));
    // Get.lazyPut(() => ReportedProfileUsecase(Get.find()));
    // Get.lazyPut(() => GetPlanDetailsUsecase(Get.find()));
    // Get.lazyPut(() => GetPlanUsecase(Get.find()));

    // Controllers
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        getIt<ProfileUsecase>(),
        getIt<CommonDataUsecase>(),
        getIt<UpdateProfileUsecase>(),
        getIt<LocationDataUsecase>(),
        getIt<GetPageDetailsUsecase>(),
        getIt<GetPageUsecase>(),
        getIt<SubCasteByCasteUsecase>(),
      ),
    );
    Get.lazyPut<ViewedController>(
      () => ViewedController(getIt<GetViewUsecase>()),
    );
    Get.lazyPut<BlockController>(
      () => BlockController(getIt<BlockedProfileUsecase>()),
    );
    Get.lazyPut<ReportedController>(
      () => ReportedController(getIt<ReportedProfileUsecase>()),
    );
    Get.lazyPut<ShortlistController>(
      () => ShortlistController(
        getIt<GetShortlistUsecase>(),
        getIt<ShortlistProfileUsecase>(),
      ),
    );
    Get.lazyPut<PlanController>(
      () => PlanController(
        getIt<GetPlanUsecase>(),
        getIt<GetPlanDetailsUsecase>(),
        getIt<CheckoutUsecase>(),
        getIt<VerifyPaymentUsecase>(),
      ),
    );

    Get.lazyPut<InterestController>(
      () => InterestController(
        getIt<GetInterestUsecase>(),
        getIt<UpdateInterestUsecase>(),
        getIt<DeleteInterestUsecase>(),
        getIt<SendInterestUsecase>(),
      ),
    );
    // Get.lazyPut(() => ViewedController(Get.find()));
    // Get.lazyPut(() => BlockController(Get.find()));
    // Get.lazyPut(() => ReportedController(Get.find()));
    // Get.lazyPut(() => ShortlistController(Get.find(), Get.find()));
    // Get.lazyPut(() => PlanController(Get.find(), Get.find()));
    // Get.lazyPut(
    //   () => InterestController(Get.find(), Get.find(), Get.find(), Get.find()),
    // );
  }
}
