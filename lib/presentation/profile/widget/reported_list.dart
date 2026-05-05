import '../../../core/exporters/app_export.dart';

class ReportedList extends StatefulWidget {
  const ReportedList({super.key});

  @override
  State<ReportedList> createState() => _ReportedListState();
}

class _ReportedListState extends State<ReportedList> {
  final controller = Get.find<ReportedController>();

  @override
  void initState() {
    super.initState();
    controller.getReportList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: 'Reported User'),
      body: Obx(() {
        /// 🔹 Initial Loading (Shimmer)
        if (controller.isLoading.isTrue) {
          return SingleChildScrollView(
            child: CustomShimmerWidget.list(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: 10,
              width: double.infinity,
              height: Get.height * 0.08.h, baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
              highlightColor: theme.brightness == Brightness.light
                  ? Colors.grey.shade100
                  : Colors.grey.shade700,
            ),
          );
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
              controller.getReportList(showLoading: false);
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
                    final reportedUser = controller.items[index];
                    return _buildReportTile(theme, reportedUser, context);
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

  Widget _buildReportTile(ThemeData theme, reportedUser, BuildContext context) {
    final imageUrl = reportedUser['profile_image']?.toString() ?? '';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColors.grey300),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: FadeInImage(
                  placeholder: const AssetImage(AppAssets.defaultImage),
                  image: (imageUrl.toString().isNotEmpty)
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
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: reportedUser['name']?.toString() ?? '',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (reportedUser['username']!.toString().isNotEmpty)
                    AppText(
                      text: "@${reportedUser['username'] ?? ''}",
                      fontSize: 12.sp,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  if (reportedUser['reason']!.toString().isNotEmpty) ...[
                    AppText(
                      text: reportedUser['reason']?.toString() ?? '',
                      fontSize: 12.sp,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 6.h),
                  ],
                ],
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
          Icon(Icons.report, size: 50, color: Colors.grey.shade400),
          SizedBox(height: 10.h),
          AppText(
            text: 'No Reported users',
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
