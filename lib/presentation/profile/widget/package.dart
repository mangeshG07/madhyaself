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
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(
                child: AppLoader.circular(
                  color: AppColors.lightPrimary,
                  size: 20.r,
                  strokeWidth: 2.5,
                ),
              )
            : controller.planList.isEmpty
            ? Center(
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
              )
            : FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    spacing: 20.h,
                    children: [
                      _buildToggle(isLight),
                      _buildHeader(theme),
                      _buildPackageGrid(theme, isLight),
                    ],
                  ),
                ),
              ),
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
                  // height: 1.4,
                ),

                // Action Button
                AppButton(
                  text: isPopular ? '👑 Get Premium' : 'Get Started',
                  onTap: () => _showPremiumDialog(plan),
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
                            ?  AppColors.lightPrimary : Colors.white,
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

  void _showPremiumDialog(dynamic plan) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rocket_launch,
                  size: 40.sp,
                  color: AppColors.lightPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              AppText(
                text: 'Ready to Upgrade?',
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8.h),
              AppText(
                text:
                    'Get ${plan['name'] ?? 'Premium'} and start your journey today!',
                fontSize: 14.sp,
                textAlign: TextAlign.center,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Maybe Later',
                      onTap: () => Navigator.pop(context),
                      type: AppButtonType.outline,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton(
                      text: 'Proceed',
                      onTap: () {
                        Navigator.pop(context);
                        // Add payment navigation logic
                      },
                      backgroundColor: AppColors.lightPrimary,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
