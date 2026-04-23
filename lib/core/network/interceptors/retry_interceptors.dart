import '../../exporters/app_export.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;

  RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String message = "Something went wrong. Please try again.";

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout. Please check your internet.";
        break;

      case DioExceptionType.sendTimeout:
        message = "Request timeout. Please try again.";
        break;

      case DioExceptionType.receiveTimeout:
        message = "Server is taking too long to respond.";
        break;

      case DioExceptionType.badResponse:
        message = _handleStatusCode(err.response?.statusCode);
        break;

      case DioExceptionType.cancel:
        message = "Request was cancelled.";
        break;

      case DioExceptionType.connectionError:
        message = "No internet connection. Please check your network.";
        break;

      case DioExceptionType.unknown:
        message = "Unexpected error occurred.";
        break;
      case DioExceptionType.badCertificate:
        message = "Something went wrong. Please try again.";
        break;
    }

    /// Retry only for network issues
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.receiveTimeout) {
      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    _showError(message);
    return handler.next(err);
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad request. Please try again.";
      case 401:
        return "Session expired. Please login again.";
      case 403:
        return "You don’t have permission.";
      case 404:
        return "Requested resource not found.";
      case 500:
        return "Server error. Please try later.";
      default:
        return "Something went wrong. Try again.";
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
