import 'package:madhya/core/exporters/app_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeController>();
  final navController = getIt<NavigationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getHome();
      checkInternetAndShowPopup();
    });
    getIt<FirebaseTokenController>().updateToken();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: Obx(
        () => controller.isLoading.isTrue
            ?
              // AppLoader.circular()
              _shimmerLoader(theme)
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  spacing: 12.h,
                  children: [
                    _buildSlider(),
                    _buildCompletion(theme),
                    _buildStats(Theme.of(context)),
                    _buildTodayMatch(theme),
                    _buildTopMatch(theme),
                    _buildDiscoverMatch(theme),
                    _buildOnlineUsers(theme),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _shimmerLoader(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 12.h,
        children: [
          CustomShimmerWidget.single(
            width: double.infinity,
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
            height: Get.height * 0.23.h,
          ),
          CustomShimmerWidget.single(
            width: double.infinity,
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
          ),
          CustomShimmerWidget.grid(
            itemCount: 4,
            width: double.infinity,
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
            height: Get.height * 0.12.h,
            childAspectRatio: 1.4,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      surfaceTintColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      centerTitle: false,
      title: Image.asset(
        theme.brightness == Brightness.light
            ? AppAssets.appLogoEnglish
            : AppAssets.appLogoWhite,
        width: 0.4.sw,
      ),
      actions: [
        AppIconButton(
          onPressed: () => Get.toNamed(
            Routes.searchScreen,
            arguments: {
              'hasBasicFilter': controller.hasBasicFilter,
              'hasAdvancedFilter': controller.hasAdvancedFilter,
            },
          ),
          icon: HugeIcons.strokeRoundedSearch01,
          iconColor: Colors.grey,
          backgroundColor: theme.inputDecorationTheme.fillColor,
        ),
        AppIconButton(
          onPressed: () => Get.toNamed(Routes.notificationScreen),
          icon: HugeIcons.strokeRoundedNotification02,
          iconColor: Colors.grey,
          backgroundColor: theme.inputDecorationTheme.fillColor,
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return Obx(
      () => AppCarouselImageVideoSlider(
        margin: const EdgeInsets.only(bottom: 8),
        activeIndicatorColor: AppColors.lightPrimary,
        sliderItems: List<Map<String, dynamic>>.from(controller.sliderList),
        height: Get.height * 0.23,
        placeholder: Image.asset(AppAssets.defaultImage, width: 0.4.sw),
      ),
    );
  }

  Widget _buildCompletion(ThemeData theme) {
    final percent = (controller.profileCompletion.value) / 100;

    if (controller.profileCompletion.value.toString() == '100') {
      return SizedBox();
    }
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.brightness == Brightness.light
              ? AppColors.lightBorderPink
              : AppColors.lightTextMidColor,
        ),
        color: theme.brightness == Brightness.light
            ? AppColors.lightPink
            : AppColors.grey900,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        spacing: 12.w,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Complete Your Profile",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: AppColors.lightPrimary,
                  ),
                ),
                SizedBox(height: 6.h),

                AppText(
                  text: "Add more details to find better matches.",
                  fontSize: 12.sp,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  color: AppColors.lightTextLowColor,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: AppColors.lightTextLowColor,
                  ),
                ),
                SizedBox(height: 10.h),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percent),
                  duration: const Duration(milliseconds: 600),
                  builder: (_, value, __) {
                    return LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(10.r),
                      value: value,
                      minHeight: 8.h,
                      backgroundColor: theme.dividerTheme.color,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.lightSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            // flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.editProfile),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AppText(
                      text: 'Complete',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                      ),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                AppText(
                  text: '${(percent * 100).toInt()}% Profile Completed',
                  fontSize: 12.sp,
                  maxLines: 2,
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: AppColors.lightTextLowColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ThemeData theme) {
    return Obx(
      () => Wrap(
        spacing: 8.w, // horizontal spacing
        runSpacing: 8.h, // vertical spacing
        children: controller.statsData.map((item) {
          return SizedBox(
            width: (Get.width - 50.w) / 2,
            child: GestureDetector(
              onTap: item['onTap'],
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? AppColors.lightPrimary.withValues(alpha: 0.1)
                                : AppColors.lightLowPrimary.withValues(
                                    alpha: 0.1,
                                  ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: HugeIcon(
                            icon: item["icon"] as List<List<dynamic>>,
                            color: AppColors.lightPrimary,
                            size: 20.r,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: AppText(
                            text: item["value"]?.toString() ?? '',
                            fontSize: 12.sp,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.brightness == Brightness.light
                                  ? AppColors.lightTextLowColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AppText(
                            text: item["title"]?.toString() ?? '',
                            fontSize: 16.sp,
                            maxLines: 2,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.brightness == Brightness.light
                                  ? AppColors.lightTextLowColor
                                  : Colors.white,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? theme.primaryColor.withValues(alpha: 0.05)
                                : AppColors.lightLowPrimary.withValues(
                                    alpha: 0.1,
                                  ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowUpRight03,
                            color: AppColors.lightTextLowColor,
                            size: 20.r,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTodayMatch(ThemeData theme) {
    return Obx(() {
      if (controller.todayMatchList.isEmpty) {
        return SizedBox.shrink();
      }
      return Column(
        spacing: 12.h,
        children: [
          buildHeadingWithButton(
            title: "Today's Matches",
            rightText: 'View All',
            onTap: () => navController.updateIndex(1),
            theme: theme,
          ),
          AppCustomSlider(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            imageUrls: controller.todayMatchList,
            height: Get.height * 0.4.h,
          ),
        ],
      );
    });
  }

  Widget _buildTopMatch(ThemeData theme) {
    return Obx(() {
      if (controller.topMatchList.isEmpty) {
        return SizedBox();
      }
      return Column(
        spacing: 12.h,
        children: [
          buildHeadingWithButton(
            title: "Top Matches",
            rightText: 'View All',
            onTap: () => navController.updateIndex(1),
            theme: theme,
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(controller.topMatchList.length, (index) {
                final match = controller.topMatchList[index] ?? {};
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: CompactCard(
                    details: {
                      'name': match['name'] ?? '',
                      'id': match['id']?.toString() ?? '',
                      'age': getAgeJob(match),
                      'address': getAddress(match),
                      'image': match['profile_image']?.toString() ?? '',
                      'isVerified': match['is_verified'].toString() != '0',
                      'isPremium': match['is_premium'].toString() != '0',
                      'isHide': match['hide_photos'].toString() != '0',
                      'username': match['username'] ?? '',
                    },
                    onTap: () => Get.toNamed(
                      Routes.othersProfile,
                      arguments: {
                        'id': match['id']?.toString() ?? '',
                        'source': 'matches',
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
          // SizedBox(
          //   height: Get.height * 0.34.h,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     itemCount: controller.topMatchList.length,
          //     itemBuilder: (_, index) {
          //       final match = controller.topMatchList[index] ?? {};
          //       return CompactCard(
          //         details: {
          //           'username': match['username'] ?? '',
          //           'name': match['name'] ?? '',
          //           'id': match['id']?.toString() ?? '',
          //           'age': getAgeJob(match),
          //           'address': getAddress(match),
          //           'image': match['profile_image']?.toString() ?? '',
          //           'isVerified': match['is_verified'] == '0' ? false : true,
          //           'isPremium': match['isPremium'] ?? false,
          //           'isHide': match['hide_photos'] == '0' ? false : true,
          //         },
          //         onTap: () => Get.toNamed(
          //           Routes.othersProfile,
          //           arguments: {'id': match['id']?.toString() ?? ''},
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      );
    });
  }

  Widget _buildDiscoverMatch(ThemeData theme) {
    return Column(
      spacing: 12.h,
      children: [
        buildHeadingWithButton(
          title: "Discover Matches",
          rightText: 'View All',
          onTap: () {},
          showRight: false,
          theme: theme,
        ),

        Obx(
          () => MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            itemCount: controller.discStatData.length,
            itemBuilder: (context, index) {
              final item = controller.discStatData[index];

              return GestureDetector(
                onTap: item['onTap'],
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? AppColors.lightCardPink
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    spacing: 8.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 12.w,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.light
                                  ? Colors.white
                                  : theme.inputDecorationTheme.fillColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: HugeIcon(
                              icon: item["icon"] as List<List<dynamic>>,
                              color: AppColors.lightPrimary,
                              size: 20.r,
                            ),
                          ),
                          AppText(
                            text: item["value"]?.toString() ?? '',
                            fontSize: 12.sp,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.brightness == Brightness.light
                                  ? AppColors.lightTextLowColor
                                  : Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: AppText(
                              text: item["title"]?.toString() ?? '',
                              fontSize: 14.sp,
                              maxLines: 2,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.brightness == Brightness.light
                                    ? AppColors.lightTextLowColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.light
                                  ? Colors.white
                                  : theme.inputDecorationTheme.fillColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowUpRight03,
                              color: AppColors.lightTextLowColor,
                              size: 20.r,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineUsers(ThemeData theme) {
    return Obx(() {
      if (controller.onlineUserList.isEmpty) {
        return SizedBox.shrink();
      }
      return Column(
        spacing: 12.h,
        children: [
          buildHeadingWithButton(
            title: "Online Users",
            rightText: 'View All',
            onTap: () {},
            showRight: false,
            theme: theme,
          ),

          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemCount: controller.onlineUserList.length,
            itemBuilder: (_, index) {
              final user = controller.onlineUserList[index];
              return GestureDetector(
                onTap: () => Get.toNamed(
                  Routes.othersProfile,
                  arguments: {
                    'id': user['id']?.toString() ?? '',
                    'source': 'matches',
                  },
                ),
                child: _buildOnlineTile(theme, user),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildOnlineTile(ThemeData theme, user) {
    final imageUrl = user['profile_image']?.toString() ?? '';
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: .5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: FadeInImage(
                      placeholder: const AssetImage(AppAssets.defaultImage),
                      image: imageUrl.toString().isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const AssetImage(AppAssets.defaultImage)
                                as ImageProvider,
                      fit: BoxFit.cover,
                      width: 55.w,
                      height: 55.h,
                      fadeInDuration: const Duration(milliseconds: 300),
                      imageErrorBuilder: (_, __, ___) {
                        return Image.asset(
                          AppAssets.defaultImage,
                          fit: BoxFit.cover,
                          width: 55.w,
                          height: 55.h,
                        );
                      },
                    ),
                  ),
                ),

                /// Online indicator
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: user['name']?.toString() ?? '',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (user['username']!.toString().isNotEmpty)
                    AppText(
                      text: "@${user['username'] ?? ''}",
                      fontSize: 12.sp,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
