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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppText(
                text: '${controller.searchList.length} search results found!',
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(child: _buildTopMatchList()),
        ],
      ),
    );
  }

  Widget _buildTopMatchList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: AppLoader.circular(color: AppColors.lightPrimary));
      }

      if (controller.searchList.isEmpty) {
        return _emptyState();
      }

      return MasonryGridView.count(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 4,
        itemCount: controller.searchList.length,
        itemBuilder: (context, index) {
          final match = controller.searchList[index];

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
              'matchPercent': match['match_percentage'] ?? 0,
            },
            onTap: () => Get.toNamed(
              Routes.othersProfile,
              arguments: {'id': match['id']?.toString() ?? ''},
            ),
          );
        },
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
