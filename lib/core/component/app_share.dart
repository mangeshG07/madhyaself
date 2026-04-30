import '../exporters/app_export.dart';


class AppShare {
  static final String _baseUrl = ApiConstants.base;

  /// Generate share link
  static String generateLink({required String username}) {
    return '$_baseUrl/profile-details/$username';
  }

  /// Share link
  static Future<void> share({required String username}) async {
    final link = generateLink(username: username);

    await SharePlus.instance.share(ShareParams(text: link));
  }
}
