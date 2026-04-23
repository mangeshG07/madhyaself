import 'package:madhya/core/exporters/app_export.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageService.read('token') ?? '';
    options.headers.addAll({
      'Authorization': token.isNotEmpty ? 'Bearer $token' : 'demo',
      'Accept': 'application/json',
    });
    super.onRequest(options, handler);
  }
}
