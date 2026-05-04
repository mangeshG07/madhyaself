import 'package:madhya/core/exporters/app_export.dart';
import 'package:madhya/core/network/dio_client.dart';


@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioClient.create();

  // @lazySingleton
  // ApiService apiService(Dio dio) => ApiService(dio);
}




// @module
// abstract class RegisterModule {
//   @lazySingleton
//   Dio get dio => Dio();
// }
