import 'package:madhya/core/exporters/app_export.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final controller = Get.find<GlobalSearchController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: 'Search Result',
        actions: [
          AppIconButton(
            onPressed: () => _openFilterSheet(context),
            icon: HugeIcons.strokeRoundedFilter,
            iconColor: Colors.grey,
            backgroundColor: theme.inputDecorationTheme.fillColor,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.h,
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppText(
                  text: '${controller.items.length} search results found!',
                  fontSize: 14.sp,
                ),
              ),
            ),
            Expanded(child: _buildTopMatchList(theme)),
          ],
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
            controller.globalSearch(showLoading: false);
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
                      'isVerified': match['isVerified'] ?? false,
                      'isPremium': match['isPremium'] ?? false,
                      'isHide': match['hide_photos'] != '0',
                      // 'matchPercent': match['match_percentage'] ?? 0,
                    },
                    onTap: () => Get.toNamed(
                      Routes.othersProfile,
                      arguments: {'id': match['id']?.toString() ?? '','source':'matches'},
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

      //
      //   GridView.builder(
      //   // shrinkWrap: true,
      //   // physics: NeverScrollableScrollPhysics(),
      //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      //   itemCount: controller.searchList.length,
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     mainAxisSpacing: 12,
      //     crossAxisSpacing: 4,
      //     childAspectRatio: 0.58,
      //   ),
      //   itemBuilder: (context, index) {
      //     final match = controller.searchList[index];
      //
      //     return CompactCard(
      //       details: {
      //         'name': match['name'] ?? '',
      //         'id': match['id'] ?? '',
      //         'age': getAgeJob(match),
      //         'address': getAddress(match),
      //         'image': match['profile_image']?.toString() ?? '',
      //         'isVerified': match['verified'] ?? false,
      //         'isPremium': match['isPremium'] ?? false,
      //         'isHide': match['hide_photos'] != '0',
      //       },
      //       onTap: () => Get.toNamed(
      //         Routes.othersProfile,
      //         arguments: {'id': match['id']?.toString() ?? ''},
      //       ),
      //     );
      //   },
      // );
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

  void _openFilterSheet(BuildContext context) {
    Get.bottomSheet(SearchFilter(), isScrollControlled: true);
  }
}
