import 'package:madhya/core/exporters/app_export.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = getIt<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.startTimer();
  }

  @override
  void dispose() {
    controller.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Obx(
                () => PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = controller.onboardingData[index];

                    return OnboardingComponent(
                      controller: controller,
                      description: data['description']!,
                      image: data['image']!,
                      onNextPressed: controller.startAutoScroll,
                      title: data['title']!,
                    );
                  },
                  onPageChanged: (int page) {
                    controller.currentPage.value = page.toDouble();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppButton(
                type: AppButtonType.secondary,
                text: 'Skip',
                textColor: theme.brightness == Brightness.light
                    ? AppColors.lightTextLowColor
                    : Colors.white,
                backgroundColor: theme.brightness == Brightness.light
                    ? AppColors.grey300
                    : AppColors.grey800,
                onTap: () async {
                  await LocalStorage.setBool('isOnboarded', true);
                  Get.offAllNamed(Routes.login);
                },
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
