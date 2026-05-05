import '../../../core/exporters/app_export.dart';

class Package extends StatefulWidget {
  const Package({super.key});

  @override
  State<Package> createState() => _PackageState();
}

class _PackageState extends State<Package> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final controller = Get.find<PlanController>();
  final pController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.getPlans();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: 'Packages'),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            spacing: 20.h,
            children: [
              _buildCurrentPlanCard(theme),
              _buildToggle(isLight),
              _buildHeader(theme),
              _buildPackageGrid(theme, isLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard(ThemeData theme) {
    final planName = pController.planDetails['plan_name'] ?? 'Free Plan';
    final endDate = pController.planDetails['end_date'] ?? 'No expiry';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium,
              color: theme.colorScheme.onSurface,
              size: 24.sp,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Current Plan',
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),

                SizedBox(height: 4.h),

                AppText(
                  text: planName,
                  fontSize: 18.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(height: 4.h),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: AppColors.grey600,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AppText(
                        text: 'Valid till $endDate',
                        fontSize: 12.sp,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Icon(Icons.verified, color: Colors.blue, size: 22.sp),
        ],
      ),
    );
  }

  Widget _buildToggle(bool isLight) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(6.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isLight ? AppColors.grey100 : AppColors.grey800,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            toggleItem(
              title: 'Online Plan',
              isSelected: controller.selectedType.value == 0,
              onTap: () async {
                controller.selectedType.value = 0;
                // await controller.getShortList(isRefresh: true);
              },
              isLight: isLight,
            ),
            SizedBox(width: 8.w),
            toggleItem(
              title: 'Offline Plan',
              isSelected: controller.selectedType.value == 1,
              onTap: () async {
                controller.selectedType.value = 1;
                // await controller.getShortList(isRefresh: true);
              },
              isLight: isLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      spacing: 8.h,
      children: [
        AppText(
          text: 'Choose Your Perfect Plan',
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        AppText(
          text:
              'Unlock premium features and connect with your perfect match faster',
          fontSize: 14.sp,
          textAlign: TextAlign.center,
          color: Colors.grey.shade600,
          maxLines: 4,
          // height: 1.4,
        ),
      ],
    );
  }

  Widget _buildPackageGrid(ThemeData theme, bool isLight) {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return SingleChildScrollView(
          child: CustomShimmerWidget.list(
            itemCount: 10,
            width: double.infinity,
            height: Get.height * 0.48.h,
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
          ),
        );
      }
      if (controller.planList.isEmpty) {
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64.sp,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16.h),
              AppText(
                text: 'No Plans Found',
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.planList.length,
        itemBuilder: (context, index) {
          final plan = controller.planList[index];
          final isPopular = index == 1; // Mark middle plan as popular
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildPackageCard(theme, plan, isPopular, isLight),
          );
        },
      );
    });
  }

  Widget _buildPackageCard(
    ThemeData theme,
    dynamic plan,
    bool isPopular,
    bool isLight,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isPopular
            ? Border.all(color: AppColors.lightPrimary, width: 2)
            : Border.all(color: theme.dividerTheme.color!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular) _buildPopularBadge(),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.h,
              children: [
                // Plan Name & Duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: plan['name'] ?? '',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          if (plan['duration_days'] != null)
                            AppText(
                              text: '${plan['duration_days']} Days',
                              fontSize: 13.sp,
                              color: Colors.grey.shade600,
                            ),
                        ],
                      ),
                    ),
                    _buildPriceTag(plan, theme),
                  ],
                ),

                // Description
                AppText(
                  text:
                      plan['description'] ??
                      'Fast-track your perfect match with premium benefits',
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                  maxLines: 4,
                ),

                // Action Button
                AppButton(
                  text: isPopular ? '👑 Get Premium' : 'Get Started',
                  onTap: () => Get.toNamed(
                    Routes.paymentScreen,
                    arguments: {'id': plan['id']?.toString() ?? ''},
                  ),
                  backgroundColor: isPopular
                      ? AppColors.lightPrimary
                      : Colors.grey.shade100,
                  textColor: isPopular ? Colors.white : AppColors.lightPrimary,
                  borderColor: AppColors.lightPrimary,
                  type: isPopular
                      ? AppButtonType.primary
                      : AppButtonType.outline,
                  borderRadius: 12.r,
                ),

                // Features Section
                _buildFeatureSection(theme, plan),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBadge() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lightPrimary, AppColors.lightPink],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: AppText(
        text: '⭐ MOST POPULAR',
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPriceTag(dynamic plan, ThemeData theme) {
    final price = plan['final_price']?.toString() ?? '';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? AppColors.lightPrimary.withValues(alpha: 0.1)
            : AppColors.grey800,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 4.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: '₹',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: theme.brightness == Brightness.light
                ? AppColors.lightPrimary
                : Colors.white,
          ),
          AppText(
            text: price,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: theme.brightness == Brightness.light
                ? AppColors.lightPrimary
                : Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection(ThemeData theme, dynamic plan) {
    final features = plan['features'] ?? [];

    if (features.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: theme.dividerTheme.color, height: 8.h),
        SizedBox(height: 8.h),
        AppText(
          text: 'What\'s included:',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 12.h),
        ...features.map<Widget>((feature) {
          if (feature is Map<String, dynamic>) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.light
                          ? AppColors.lightPrimary.withValues(alpha: 0.1)
                          : AppColors.grey800,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14.sp,
                      color: AppColors.lightPrimary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AppText(
                      text: feature['name'] ?? '',
                      fontSize: 13.sp,
                      maxLines: 4,
                    ),
                  ),
                  if (feature['limit'] != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.light
                            ? Colors.grey.shade100
                            : AppColors.grey800,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: AppText(
                        text: feature['limit'].toString(),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.brightness == Brightness.light
                            ? AppColors.lightPrimary
                            : Colors.white,
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox();
        }).toList(),
      ],
    );
  }
}
