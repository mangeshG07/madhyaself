import '../exporters/app_export.dart';

class PolicyData extends StatefulWidget {
  final String slug;

  const PolicyData({super.key, required this.slug});

  @override
  State<PolicyData> createState() => _PolicyDataState();
}

class _PolicyDataState extends State<PolicyData> {
  final controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.getPagesDetails(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isPageDetailsLoading.isTrue
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: AppLoader.circular(color: AppColors.lightPrimary),
            )
          : Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: CustomAppbar(
                title: controller.pagesDetails['name'] ?? '',
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  controller.pagesDetails['description'] ?? '-',
                  textStyle: TextStyle(fontSize: 14.sp, height: 1.6),
                ),
              ),
            ),
    );
  }
}
