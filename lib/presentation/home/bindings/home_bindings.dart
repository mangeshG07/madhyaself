import 'package:madhya/core/exporters/app_export.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        getIt<HomeUsecase>(),
        Get.find<ChatController>(),
        Get.find<GlobalSearchController>(),
      ),
    );

    Get.lazyPut<FirebaseTokenController>(
      () => FirebaseTokenController(getIt<FirebaseTokenUsecase>()),
    );

    Get.lazyPut<NotificationController>(
      () => NotificationController(
        getIt<GetNotificationUsecase>(),
        getIt<ReadNotification>(),
      ),
    );
    // Get.lazyPut(() => HomeUsecase(Get.find()));
    //
    // Get.lazyPut(() => HomeController(Get.find()));
    // Get.lazyPut(
    //       () => InterestController(Get.find(), Get.find(), Get.find(), Get.find()),
    // );
  }
}
