import '../../../core/exporters/app_export.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final _controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _controller.getPages();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: 'Help & Support'),
      body: Obx(
        () => _controller.isPageLoading.isTrue
            ? SingleChildScrollView(
                child: CustomShimmerWidget.list(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: 10,
                  width: double.infinity,
                  height: Get.height * 0.08.h,
                ),
              )
            : _controller.pagesList.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: _controller.pagesList.length,
                separatorBuilder: (_, __) => Divider(
                  color: theme.dividerTheme.color,
                  indent: Get.width * 0.04,
                  endIndent: Get.width * 0.04,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final page = _controller.pagesList[index];
                  return ListTile(
                    onTap: () =>
                        Get.to(() => PolicyData(slug: page['slug'] ?? '')),
                    title: AppText(
                      text: page['name'] ?? '',
                      fontSize: 16.sp,
                      maxLines: 2,
                      style: theme.textTheme.titleMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.r,
                      color: AppColors.grey500,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.04,
                      vertical: 4.h,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.help_outline, size: 64.r, color: AppColors.grey500),
          SizedBox(height: 16.h),
          AppText(
            text: 'No help articles available',
            fontSize: 16.sp,
            color: AppColors.grey600,
          ),
        ],
      ),
    );
  }
}
