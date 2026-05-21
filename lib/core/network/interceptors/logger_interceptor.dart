// core/network/interceptors/logger_interceptor.dart
import 'dart:developer';
import 'package:madhya/core/exporters/app_export.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(options, handler) {
    log("➡️ REQUEST: ${options.method} ${options.uri}");
    log("Headers: ${options.headers}");
    log("Body: ${options.data}");
    handler.next(options);
  }

  @override
  void onResponse(response, handler) {
    log("✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}");
    log("Data: ${response.data}");
    final isLoggedOut = response.data['user_login'] == false;
    if (isLoggedOut) {
      CustomSnackbar.show(
        message: "You have logged in on another device. Please login again.",
        context: Get.context!,
        type: SnackbarType.error,
      );

      Future.microtask(() async {
        await SecureStorageService.clear();
        await LocalStorage.clear();

        Get.offAllNamed(Routes.login);
        return;
      });
    }
    handler.next(response);
  }

  @override
  void onError(err, handler) {
    log("❌ ERROR: ${err.message}");
    handler.next(err);
  }
}
