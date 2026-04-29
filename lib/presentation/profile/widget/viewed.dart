import 'package:madhya/core/exporters/app_export.dart';

class Viewed extends StatefulWidget {
  const Viewed({super.key});

  @override
  State<Viewed> createState() => _ViewedState();
}

class _ViewedState extends State<Viewed> {
  final controller = Get.find<ViewedController>();

  @override
  void initState() {
    super.initState();
    controller.getViewList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Scaffold(
      appBar: CustomAppbar(title: 'Viewed'),
      body: SafeArea(
        child: Column(
          children: [
            _buildToggle(isLight),
            Expanded(child: _buildViewList()),
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
              title: 'Who viewed me',
              isSelected: controller.selectedType.value == 0,
              onTap: () async {
                controller.selectedType.value = 0;
                await controller.getViewList(isRefresh: true);
              },
              isLight: isLight,
            ),
            SizedBox(width: 8.w),
            toggleItem(
              title: 'Viewed by me',
              isSelected: controller.selectedType.value == 1,
              onTap: () async {
                controller.selectedType.value = 1;
                await controller.getViewList(isRefresh: true);
              },
              isLight: isLight,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- GRID ----------------
  Widget _buildViewList() {
    return Obx(() {
      if (controller.isLoading.value) {
        // return const LoadingWidget();
        return Center(child: AppLoader.circular(color: AppColors.lightPrimary));
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
            controller.getViewList(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                itemCount: controller.items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 6.w,
                  childAspectRatio: 0.59.h,
                ),
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
                    },
                    onTap: () => Get.toNamed(
                      Routes.othersProfile,
                      arguments: {
                        'id': controller.selectedType.value == 1
                            ? match['viewed_user_id']?.toString() ?? ''
                            : match['viewer_id']?.toString() ?? '',
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
            text: 'Start exploring and view profiles',
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
