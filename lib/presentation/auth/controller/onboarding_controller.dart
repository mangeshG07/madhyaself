import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class AuthController extends GetxController {
  final pageController = PageController(initialPage: 0);
  final currentPage = 0.0.obs;
  Timer? timer;

  final onboardingData = [
    {
      'description':
          'Discover compatible profiles based on your preferences, community, and lifestyle.',
      'image': AppAssets.onboarding_1,
      'title': 'Find Your\nPerfect Match',
    },
    {
      'description':
          'Send interests, chat securely, and get to know your potential life partner.',
      'image': AppAssets.onboarding_2,
      'title': 'Express Interest &\nStart Conversations',
    },
    {
      'description':
          'Verified members and secure privacy settings to ensure a trusted matchmaking experience.',
      'image': AppAssets.onboarding_3,
      'title': 'Safe &\nVerified Profiles',
    },
  ].obs;

  void startAutoScroll() {
    if (pageController.page! < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (currentPage.value < onboardingData.length - 1) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }

      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage.value.toInt(),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
