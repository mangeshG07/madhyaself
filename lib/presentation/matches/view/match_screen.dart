import 'package:madhya/core/exporters/app_export.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final controller = Get.find<MatchController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedFilter.value = null;
      checkInternetAndShowPopup();
      controller.getMatchList(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: Column(
        spacing: 16.h,
        children: [
          _buildTopCategory(theme),
          Expanded(child: _buildTopMatchList(theme)),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      surfaceTintColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      centerTitle: false,
      title: AppText(
        text: 'Matches',
        fontSize: 22.sp,
        style: theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        AppIconButton(
          onPressed: () => _matchFilter(theme),
          icon: HugeIcons.strokeRoundedFilter,
          iconColor: Colors.grey,
          backgroundColor: theme.inputDecorationTheme.fillColor,
        ),
      ],
    );
  }

  Widget _buildTopCategory(ThemeData theme) {
    return SizedBox(
      height: Get.height * 0.05,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.category.length,
        itemBuilder: (context, index) {
          return categoryTile(
            index: index,
            name: controller.category[index]['name']?.toString() ?? '',
            icon: controller.category[index]['icon'],
            theme: theme,
          );
        },
      ),
    );
  }

  Future<dynamic> _matchFilter(ThemeData theme) {
    return Get.bottomSheet(
      backgroundColor: theme.scaffoldBackgroundColor,
      SafeArea(
        child: Obx(
          () => Container(
            decoration: BoxDecoration(borderRadius: AppRadius.topXL),
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.h,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Filter',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20.sp,
                          color: AppColors.grey600,
                        ),
                        onPressed: () => Get.back(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: 'Not Viewed',
                  type: AppButtonType.outline,
                  backgroundColor: Colors.white,
                  onTap: () => controller.selectedFilter.value = 0.toString(),
                  textStyle: theme.textTheme.titleSmall,
                  textColor: AppColors.lightTextMidColor,
                  borderColor: controller.selectedFilter.value == '0'
                      ? AppColors.lightPrimary
                      : AppColors.grey200,
                ),
                AppButton(
                  text: 'Viewed',
                  onTap: () => controller.selectedFilter.value = 1.toString(),
                  type: AppButtonType.outline,
                  backgroundColor: Colors.white,
                  textStyle: theme.textTheme.titleSmall,
                  textColor: AppColors.lightTextMidColor,
                  borderColor: controller.selectedFilter.value == '1'
                      ? AppColors.lightPrimary
                      : AppColors.grey200,
                ),
                AppButton(
                  text: 'Apply',
                  onTap: () async {
                    Get.back();
                    await controller.getMatchList(isRefresh: true);
                  },
                  type: AppButtonType.secondary,
                  backgroundColor: AppColors.lightPrimary,
                  textColor: Colors.white,
                  borderColor: AppColors.grey200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopMatchList(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return CustomShimmerWidget.grid(
          baseColor: theme.brightness == Brightness.light
              ? Colors.grey.shade300
              : Colors.grey.shade800,
          highlightColor: theme.brightness == Brightness.light
              ? Colors.grey.shade100
              : Colors.grey.shade700,
          itemCount: 4,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          width: double.infinity,
          childAspectRatio: 0.6,
        );
      }

      if (controller.items.isEmpty) {
        return _emptyState();
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hasMore &&
              !controller.isLoadMore.value &&
              !controller.isLoading.value) {
            controller.getMatchList(showLoading: false);
          }
          return false;
        },
        child: Column(
          children: [
            Expanded(
              child: MasonryGridView.count(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 4,
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final match = controller.items[index];

                  return CompactCard(
                    details: {
                      'username': match['username'] ?? '',
                      'name': match['name'] ?? '',
                      'id': match['id'] ?? '',
                      'age': getAgeJob(match),
                      'address': getAddress(match),
                      'image': match['profile_image']?.toString() ?? '',
                      'isVerified': match['is_verified'].toString() == '1'
                          ? true
                          : false,
                      'isPremium': match['is_premium'].toString() == '1'
                          ? true
                          : false,
                      'isHide': match['hide_photos'] != '0',
                      'matchPercent': match['match_percentage'] ?? 0,
                    },
                    onTap: () => Get.toNamed(
                      Routes.othersProfile,
                      arguments: {
                        'id': match['id']?.toString() ?? '',
                        'source': 'deeplink',
                      },
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              if (controller.isLoadMore.value) {
                // Still loading next page
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: AppLoader.circular(color: AppColors.lightPrimary),
                );
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
      );
    });
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.noMatchFound, width: Get.width * 0.35.w),
          SizedBox(height: 10.h),
          AppText(
            text: 'No Matches yet',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: 'Start exploring and Matches profiles',
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget categoryTile({
    required String name,
    required int index,
    required dynamic icon,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () async {
        controller.selectedCategory.value = index.toString();
        await controller.getMatchList(isRefresh: true);
      },
      child: Obx(
        () => Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: controller.selectedCategory.value == index.toString()
                ? AppColors.lightSecondary
                : theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Row(
              spacing: 4.w,
              children: [
                HugeIcon(
                  icon: icon,
                  size: 14.r,
                  color: controller.selectedCategory.value == index.toString()
                      ? Colors.white
                      : AppColors.lightTextLowColor,
                ),
                AppText(
                  text: name,
                  textAlign: TextAlign.center,
                  fontSize: 12.sp,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: controller.selectedCategory.value == index.toString()
                        ? Colors.white
                        : AppColors.lightTextLowColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
