import 'package:madhya/core/exporters/app_export.dart';

class Shortlist extends StatefulWidget {
  const Shortlist({super.key});

  @override
  State<Shortlist> createState() => _ShortlistState();
}

class _ShortlistState extends State<Shortlist> {
  final controller = Get.find<ShortlistController>();

  @override
  void initState() {
    super.initState();
    controller.getShortList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Scaffold(
      appBar: CustomAppbar(title: 'Shortlist'),
      body: SafeArea(
        child: Column(
          children: [
            _buildToggle(isLight),
            Expanded(child: _buildShortList(theme)),
          ],
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
              title: 'Who shortlisted me',
              isSelected: controller.selectedType.value == 0,
              onTap: () async {
                controller.selectedType.value = 0;
                await controller.getShortList(isRefresh: true);
              },
              isLight: isLight,
            ),
            SizedBox(width: 8.w),
            toggleItem(
              title: 'Shortlisted by me',
              isSelected: controller.selectedType.value == 1,
              onTap: () async {
                controller.selectedType.value = 1;
                await controller.getShortList(isRefresh: true);
              },
              isLight: isLight,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- GRID ----------------
  Widget _buildShortList(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        // return const LoadingWidget();
        return CustomShimmerWidget.grid(
          itemCount: 4,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          width: double.infinity,
          childAspectRatio: 0.6,   baseColor: theme.brightness == Brightness.light
            ? Colors.grey.shade300
            : Colors.grey.shade800,
          highlightColor: theme.brightness == Brightness.light
              ? Colors.grey.shade100
              : Colors.grey.shade700,
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
            controller.getShortList(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              MasonryGridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                itemCount: controller.items.length,
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 6.w,
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 2,
                //   mainAxisSpacing: 12.h,
                //   crossAxisSpacing: 6.w,
                //   childAspectRatio: 0.59.h,
                // ),
                itemBuilder: (context, index) {
                  final match = controller.items[index];

                  return CompactCard(
                    details: {
                      'name': match['name'] ?? '',
                      'id': match['viewer_id']?.toString() ?? '',
                      'age': getAgeJob(match),
                      'address': getAddress(match),
                      'image': match['profile_image']?.toString() ?? '',
                      'isVerified': match['isVerified'] ?? false,
                      'isPremium': match['isPremium'] ?? false,
                      'isHide': match['hide_photos'] != '0',
                      'username': match['username'] ?? '',
                    },
                    onTap: () => Get.toNamed(
                      Routes.othersProfile,
                      arguments: {
                        'id': controller.selectedType.value == 1
                            ? match['shortlisted_user_id']?.toString() ?? ''
                            : match['user_id']?.toString() ?? '',
                      },
                    ),
                  );
                },
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
        ),
      );

      // Expanded(
      //   child: GridView.builder(
      //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      //     itemCount: list.length,
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2,
      //       mainAxisSpacing: 12.h,
      //       crossAxisSpacing: 6.w,
      //       childAspectRatio: 0.59.h,
      //     ),
      //     itemBuilder: (context, index) {
      //       final match = list[index];
      //
      //       return CompactCard(
      //         details: {
      //           'name': match['name'] ?? '',
      //           'id': match['id'] ?? '',
      //           'age': match['age'] ?? '',
      //           'address': match['address'] ?? '',
      //           'image': match['image']?.toString() ?? '',
      //           'isVerified': match['isVerified'] ?? false,
      //           'isPremium': match['isPremium'] ?? false,
      //         },
      //         onTap: () => Get.toNamed(Routes.othersProfile),
      //       );
      //     },
      //   ),
      // );
    });
  }

  //
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 50.r, color: Colors.grey),
          SizedBox(height: 10.h),
          AppText(
            text: 'No profiles yet',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: 'Start exploring and shortlist profiles',
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
