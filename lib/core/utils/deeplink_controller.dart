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

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.length < 3) return;

    final type = uri.pathSegments[1];
    final id = uri.pathSegments[2];

    Get.toNamed(Routes.othersProfile, arguments: {'id': id});
  }
}
