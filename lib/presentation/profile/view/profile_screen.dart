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
            ? _buildShimmerLoader(theme)
            : RefreshIndicator(
                onRefresh: () async => await controller.getProfile(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SafeArea(
                    child: Column(
                      // spacing: 12.h,
                      children: [
                        _buildProfileHeader(theme),
                        _buildCompletionCard(theme),
                        _buildSectionCard(controller.menuList, theme),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildShimmerLoader(ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        spacing: 12.h,
        children: [
          CustomShimmerWidget.single(
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
            width: Get.width * 0.45.w,
            height: Get.height * 0.25.w,
          ),
          CustomShimmerWidget.single(
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10.h),
          ),
          CustomShimmerWidget.list(
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
            itemCount: 4,
            width: double.infinity,
            height: Get.height * 0.08.h,
          ),
        ],
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

  // 🔥 PROFILE HEADER
  Widget _buildProfileHeader(ThemeData theme) {
    final imageUrl = controller.profileDetails['hide_photos'] == '0'
        ? controller.profileDetails['profile_image']
        : '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            theme.scaffoldBackgroundColor,
            theme.brightness == Brightness.light
                ? Colors.grey.shade50
                : AppColors.grey800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55.r,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.grey100,
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: const AssetImage(AppAssets.defaultImage),
                    image: (imageUrl != null && imageUrl.toString().isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : const AssetImage(AppAssets.defaultImage)
                              as ImageProvider,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    fadeInDuration: const Duration(milliseconds: 300),
                    imageErrorBuilder: (_, __, ___) {
                      return Image.asset(
                        AppAssets.defaultImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          AppText(
            text: capitalizeFirst(controller.profileDetails['name'] ?? ''),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            style: theme.textTheme.titleLarge?.copyWith(letterSpacing: 0.3),
          ),
          SizedBox(height: 4.h),
          AppText(
            text: controller.profileDetails['username'] ?? '',
            fontSize: 12.sp,
            color: AppColors.lightTextLowColor,
          ),
        ],
      ),
    );
  }

  // 🚀 COMPLETION CARD
  Widget _buildCompletionCard(ThemeData theme) {
    final completion = controller.profileDetails['profile_completion'] ?? 0;
    final percent = completion / 100;

    if (completion.toString() == '100') return const SizedBox();

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.brightness == Brightness.light
                ? AppColors.lightPrimary.withValues(alpha: 0.08)
                : AppColors.lightMidPrimary.withValues(alpha: 0.4),
            theme.cardColor.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  // 🎯 MENU ITEM
  Widget _menuItem(dynamic menu, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: menu['onTap'],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? AppColors.lightPrimary.withValues(alpha: 0.08)
                      : AppColors.lightPink.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(6.w),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 18.r,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📦 SECTION CARD
  Widget _buildSectionCard(List<dynamic> list, ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
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
