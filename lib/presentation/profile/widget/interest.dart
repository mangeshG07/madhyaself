import 'package:madhya/core/exporters/app_export.dart';

class Interest extends StatefulWidget {
  const Interest({super.key});

  @override
  State<Interest> createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  final controller = Get.find<InterestController>();

  @override
  void initState() {
    super.initState();
    controller.getInterestList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(title: 'Interests'),
      body: Column(
        children: [
          CustomToggle(controller: controller),
          Expanded(child: _buildInterestList(theme)),
        ],
      ),
    );
  }

  Widget _buildInterestList(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return SingleChildScrollView(
          child: CustomShimmerWidget.list(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: 4,
            baseColor: theme.brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade800,
            highlightColor: theme.brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade700,
            width: double.infinity,
            height: Get.height * 0.2.h,
          ),
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
            controller.getInterestList(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final interest = controller.items[index];

                  return InterestCard(
                    interest: interest,
                    controller: controller,
                  );
                },
              ),

              Obx(() {
                if (controller.isLoadMore.value) {
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
            text: 'No Interest yet',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: 'Start exploring and interest profiles',
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
