import 'package:madhya/core/exporters/app_export.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});
  final controller = getIt<NavigationController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: theme.brightness,
        ),
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: NavigationController
                .widgetOptions[controller.currentIndex.value],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              boxShadow: [
                if (theme.brightness == Brightness.light)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  )
                else
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: BottomNavigationBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                selectedItemColor: AppColors.lightPrimary,
                unselectedItemColor: Colors.grey.shade400,
                showUnselectedLabels: true,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                currentIndex: controller.currentIndex.value,
                onTap: controller.updateIndex,

                items: [
                  _buildNavItem(
                    HugeIcons.strokeRoundedAnalyticsUp,
                    'Home',
                    0,
                    controller.currentIndex.value == 0,
                    theme,
                  ),
                  _buildNavItem(
                    HugeIcons.strokeRoundedFavouriteSquare,
                    'Matches',
                    1,
                    controller.currentIndex.value == 1,
                    theme,
                  ),
                  _buildNavItem(
                    HugeIcons.strokeRoundedMailbox01,
                    'Mailbox',
                    2,
                    controller.currentIndex.value == 2,
                    theme,
                    iconSize: Get.width * 0.05,
                  ),
                  _buildNavItem(
                    HugeIcons.strokeRoundedUser,
                    'Profile',
                    3,
                    controller.currentIndex.value == 3,
                    theme,
                    iconSize: Get.width * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    dynamic icon,
    String label,
    int index,
    bool isSelected,
    ThemeData theme, {
    double? iconSize,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: theme.inputDecorationTheme.fillColor,
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: index == 0
            ? Image.asset(
                AppAssets.navIcon,
                width: Get.width * 0.055.w,
                color: isSelected ? null : Colors.grey.shade400,
              )
            : HugeIcon(
                size: iconSize ?? Get.width * 0.06,
                icon: icon,
                color: isSelected
                    ? AppColors.lightPrimary
                    : Colors.grey.shade400,
              ),
      ),
      label: label,
    );
  }
}
