import 'package:madhya/core/exporters/app_export.dart';

class DeleteScreen extends GetView<ProfileController> {
  const DeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Delete Profile',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            AppText(
              text:
                  'Before you go, help us understand why you have decided to delete your account permanently.',
              fontSize: 14.sp,
              maxLines: 3,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 20.h),
            Obx(() {
              return RadioGroup<String>(
                groupValue: controller.selectedDeleteReason.value,
                onChanged: (value) {
                  controller.selectedDeleteReason.value = value ?? '';
                },
                child: Column(
                  children: List.generate(controller.deleteReasons.length, (
                    index,
                  ) {
                    final reason = controller.deleteReasons[index];

                    return Column(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: reason,
                              activeColor: AppColors.lightPrimary,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: AppText(
                                text: reason,
                                fontSize: 14.sp,
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),

                        if (index != controller.deleteReasons.length - 1)
                          Divider(
                            height: 0,
                            thickness: 0.6,
                            indent: 50.w,
                            endIndent: 12.w,
                            color: theme.dividerTheme.color,
                          ),
                      ],
                    );
                  }),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.isDeleteLoading.isTrue
            ? AppLoader.circular(
                color: AppColors.lightPrimary,
                strokeWidth: 2.5,
                size: 22.r,
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppButton(
                    text: 'Submit & Delete Profile',
                    loading: controller.isDeleteLoading.value,
                    onTap: () async {
                      if (controller.selectedDeleteReason.value!
                          .trim()
                          .isNotEmpty) {
                        await controller.deleteAccount();
                      } else {
                        CustomSnackbar.show(
                          context: context,
                          message: 'Please select a reason',
                          type: SnackbarType.warning,
                        );
                      }
                    },
                    backgroundColor: AppColors.lightPrimary,
                  ),
                ),
              ),
      ),
    );
  }
}
