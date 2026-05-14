import 'package:app_links/app_links.dart';
import '../exporters/app_export.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLinkString();
      if (initialLink != null) {
        _handleDeepLink(Uri.parse(initialLink.toString()));
      }
    } catch (_) {}

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleDeepLink(Uri.parse(uri.toString()));
    }, onError: (_) {});
  }

  void _handleDeepLink(Uri uri) async {
    final token = await SecureStorageService.read('token') ?? '';

    if (uri.pathSegments.length < 2) return;
    final routeType = uri.pathSegments[0];
    final slug = uri.pathSegments[1];

    if (routeType == "profile-details") {
      final id = slug.replaceAll(RegExp(r'[^0-9]'), '');
      if (token.isEmpty) {
        Get.offAllNamed(Routes.login);
      } else {
        if (id.isNotEmpty) {
          Get.toNamed(
            Routes.othersProfile,
            arguments: {'id': id, 'source': 'deeplink'},
          );
        }
      }
    }
  }
}
