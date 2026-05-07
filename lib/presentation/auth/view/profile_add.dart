import 'package:madhya/core/exporters/app_export.dart';

class ProfileAdd extends GetView<RegisterController> {
  const ProfileAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLight
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          spacing: 12.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.08),
            buildTitle("Add a profile image"),
            buildSubTitle("Increase partner matches by adding photos", theme),
            _buildProfileImage(theme, isLight),
            _buildAdditionalImages(theme),
            Obx(() => Text("(${controller.profileImages.length}/3 minimum)")),
            Row(
              spacing: 12.w,
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedLockPassword),
                Expanded(
                  child: buildSubTitle(
                    "We'll only show this image to people you connect with on Madhyasthi",
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildContinueButton(),
        ),
      ),
    );
  }

  Widget _buildProfileImage(ThemeData theme, bool isLight) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          AppFilePicker.open(
            onPicked: (v) {
              controller.profileImage.value = v;
            },
          );
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                image: AssetImage(
                  isLight ? AppAssets.bgImage : AppAssets.bgImageDark,
                ),
              ),
            ),
            child: controller.profileImage.value != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      controller.profileImage.value!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedImageAdd01,
                      color: AppColors.lightPrimary,
                      size: 30.r,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalImages(ThemeData theme) {
    return Obx(() {
      final images = controller.profileImages;
      final int minSlots = 3;

      final int totalItems = images.length < minSlots
          ? minSlots
          : images.length + 1;

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: totalItems,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          // ✅ Show Image if exists
          if (index < images.length) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      controller.profileImages.removeAt(index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // ✅ Show Add Button (for remaining slots)
          return GestureDetector(
            onTap: () {
              AppFilePicker.open(
                config: const AppFilePickerConfig(
                  allowMultiImage: true,
                  allowVideo: false,
                ),
                onMultiPicked: (files) {
                  if (files.isNotEmpty) {
                    controller.profileImages.addAll(files);
                  }
                },
                onPicked: (file) {
                  if (file.path.isNotEmpty) {
                    controller.profileImages.add(file);
                  }
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  width: 0.5,
                  color: AppColors.lightPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedImageAdd01,
                  color: AppColors.lightPrimary,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(()=>
        AppButton(
          text: controller.isLoading.value ? 'Please wait...' : 'Register Free',
          onTap: controller.isLoading.value
              ? null
              : () async {
                  if (controller.profileImages.length < 3) {
                    Get.snackbar(
                      "Minimum Required",
                      "Please upload at least 3 images",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  await controller.registerUser(
                    Get.find<LoginController>().numberController.text,
                  );
                },

          backgroundColor: AppColors.lightPrimary,
        ),
      ),
    );
  }
}
