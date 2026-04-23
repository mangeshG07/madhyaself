import '../../../core/exporters/app_export.dart';

class MatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatchesRepository>(() => MatchesRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetMatchesUsecase(Get.find()));
    Get.lazyPut(() => MatchController(Get.find()));
  }
}
