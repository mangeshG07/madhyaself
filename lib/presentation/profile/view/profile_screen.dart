import 'package:madhya/core/exporters/app_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: Obx(
        () => controller.isLoading.isTrue
            ? AppLoader.circular(color: AppColors.lightPrimary)
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  spacing: 12.h,
                  children: [
                    _buildProfileHeader(theme),
                    _buildCompletionCard(theme),
                    _buildSectionCard(controller.menuList, theme),
                  ],
                ),
              ),
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      centerTitle: false,
      title: Image.asset(AppAssets.appLogoEnglish, height: 28.h),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 51.r,
            backgroundColor: Colors.grey.shade200,
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: AppColors.grey100,
              child: ClipOval(
                child: FadeInImage(
                  placeholder: const AssetImage(AppAssets.appLogo),
                  image: NetworkImage(
                    controller.profileDetails['profile_image'] ?? '',
                  ),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  fadeInDuration: const Duration(milliseconds: 300),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppAssets.appLogo,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          AppText(
            text: capitalizeFirst(controller.profileDetails['name'] ?? ''),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: 'MDYST0250M',
            fontSize: 12.sp,
            color: AppColors.lightTextLowColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard(ThemeData theme) {
    final percent =
        (controller.profileDetails['profile_completion'] ?? 0) / 100;

    if (controller.profileDetails['profile_completion'].toString() == '100') {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.brightness == Brightness.light
                ? AppColors.lightPrimary.withValues(alpha: 0.1)
                : AppColors.lightMidPrimary.withValues(alpha: 0.5),
            Colors.white24,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        spacing: 12.h,
        children: [
          Column(
            spacing: 6.h,
            children: [
              AppText(
                text: "Complete Your Profile",
                fontSize: 16.sp,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.brightness == Brightness.light
                      ? AppColors.lightPrimary
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppText(
                text:
                    "Add more details to increase your chances\nof finding the perfect match.",
                fontSize: 12.sp,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            spacing: 10.w,
            children: [
              AppText(
                text: '${(percent * 100).toInt()}% ',
                fontSize: 12.sp,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percent),
                  duration: const Duration(milliseconds: 800),
                  builder: (_, value, __) {
                    return LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(10.r),
                      value: value,
                      minHeight: 6.h,
                      backgroundColor: theme.dividerTheme.color,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.lightSecondary,
                      ),
                    );
                  },
                ),
              ),
              AppText(
                text: 'Profile Completed',
                fontSize: 12.sp,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem(dynamic menu, ThemeData theme) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: menu['onTap'],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? AppColors.lightPrimary.withValues(alpha: 0.05)
                    : AppColors.lightPink.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: HugeIcon(
                icon: menu['icon'],
                color: theme.brightness == Brightness.light
                    ? AppColors.lightPrimary
                    : Colors.white,
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText(
                text: menu['title'] ?? '',
                fontSize: 14.sp,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: 20.r,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<dynamic> list, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(list.length, (index) {
          final menu = list[index];
          return Column(
            children: [
              _menuItem(menu, theme),
              if (index != list.length - 1)
                Divider(
                  height: 0,
                  thickness: 0.6,
                  indent: 50.w,
                  endIndent: 12.w,
                  color: theme.dividerTheme.color,
                ),
            ],
          );
        }),
      ),
    );
  }
}
