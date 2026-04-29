import 'package:madhya/core/network/dio_client.dart';
import '../exporters/app_export.dart' hide ApiClient;

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    final dio = DioClient.create();
    //
    Get.put<ApiService>(ApiService(dio), permanent: true);
    Get.lazyPut(
      () => InterestController(Get.find(), Get.find(), Get.find(), Get.find()),
      fenix: true,
    );
  }
}
