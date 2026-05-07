import '../../../core/exporters/app_export.dart';

class BlockUserList extends StatefulWidget {
  const BlockUserList({super.key});

  @override
  State<BlockUserList> createState() => _BlockUserListState();
}

class _BlockUserListState extends State<BlockUserList> {
  final controller = Get.find<BlockController>();
  final unblockController = Get.find<OtherProfileController>();

  @override
  void initState() {
    super.initState();
    controller.getBlockList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: 'Blocked User'),
      body: Obx(() {
        /// 🔹 Initial Loading (Shimmer)
        if (controller.isLoading.isTrue) {
          return SingleChildScrollView(
            child: CustomShimmerWidget.list(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: 10,
              width: double.infinity,
              height: Get.height * 0.08.h,
              baseColor: theme.brightness == Brightness.light
                  ? Colors.grey.shade300
                  : Colors.grey.shade800,
              highlightColor: theme.brightness == Brightness.light
                  ? Colors.grey.shade100
                  : Colors.grey.shade700,
            ),
          );

          // AppLoader.circular(color: AppColors.lightPrimary);
        }

        /// 🔹 Empty State
        if (controller.items.isEmpty) {
          return _buildEmptyState();
        }

        /// 🔹 Feeds + Pagination
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification &&
                scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
                controller.hasMore &&
                !controller.isLoadMore.value &&
                !controller.isLoading.value) {
              controller.getBlockList(showLoading: false);
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (_, index) => const SizedBox(height: 8),
                  itemCount: controller.items.length,
                  itemBuilder: (_, index) {
                    final blockUser = controller.items[index];
                    return _buildBlockTile(theme, blockUser, context);
                  },
                ),

                /// 🔹 Pagination Loader
                Obx(
                  () => controller.isLoadMore.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: AppLoader.circular(
                            color: AppColors.lightPrimary,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBlockTile(ThemeData theme, blockUser, BuildContext context) {
    final imageUrl = blockUser['profile_image']?.toString() ?? '';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(8.w),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: FadeInImage(
                placeholder: const AssetImage(AppAssets.defaultImage),
                image: (imageUrl.toString().isNotEmpty)
                    ? NetworkImage(
                        blockUser['hide_photos'] == '0' ? imageUrl : '',
                      )
                    : const AssetImage(AppAssets.defaultImage) as ImageProvider,
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
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10.r),
            //   child: Image.network(
            //     blockUser['profile_image']?.toString() ?? '',
            //     width: 55.w,
            //     height: 55.h,
            //     fit: BoxFit.cover,
            //     errorBuilder: (_, __, ___) => Container(
            //       width: 55.w,
            //       height: 55.h,
            //       color: Colors.grey.shade200,
            //       child: Icon(Icons.person, color: Colors.grey),
            //     ),
            //   ),
            // ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: blockUser['name']?.toString() ?? '',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.titleMedium,
                  ),
                  AppText(
                    text: "@${blockUser['username'] ?? ''}",
                    fontSize: 12.sp,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),

            /// 🔹 Unblock Button
            GestureDetector(
              onTap: () {
                AllDialogs().showConfirmationDialog(
                  'Unblock User',
                  'Are you sure you want to unblock this user?',
                  onConfirm: () async {
                    Navigator.pop(context);

                    await unblockController
                        .blockProfile(blockUser['id'].toString())
                        .then((_) => controller.getBlockList(isRefresh: true));
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Unblock",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, size: 50, color: Colors.grey.shade400),
          SizedBox(height: 10.h),
          AppText(
            text: 'No blocked users',
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
