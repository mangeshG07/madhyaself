import 'package:madhya/core/exporters/app_export.dart';

class AboutMeEdit extends GetView<ProfileController> {
  const AboutMeEdit({super.key});

  static const int maxLength = 100;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'About Me Edit',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.aboutMeDetailsFormKey,
            child: Column(
              spacing: 16.h,
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      AppText(
                        text: "Tell something about yourself",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),

                      AppTextField(
                        filled: true,
                        label: 'About me',
                        showLabel: false,
                        maxLines: 500,
                        showCharacterCount: true,
                        minLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(maxLength),
                        ],
                        maxLength: maxLength,
                        hint:
                            'Write about your personality, lifestyle, expectations...',
                        contentPadding: const EdgeInsets.all(8),
                        focusedBorder: theme.inputDecorationTheme.focusedBorder,
                        enabledBorder: theme.inputDecorationTheme.enabledBorder,
                        textStyle: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14.sp,
                        ),
                        validator: AppValidators.required,
                        labelStyle: theme.textTheme.labelMedium,
                        controller: controller.aboutMeController,
                        fillColor: theme.cardColor,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),

                Obx(
                  () => controller.isUpdateLoading.isTrue
                      ? AppLoader.circular(
                          color: AppColors.lightPrimary,
                          strokeWidth: 2.5,
                          size: 22.r,
                        )
                      : AppButton(
                          text: 'Save Changes',
                          onTap: () async {
                            if (controller.aboutMeDetailsFormKey.currentState!
                                .validate()) {
                              await controller.updateAboutMeDetails();
                            }
                          },
                          backgroundColor: AppColors.lightPrimary,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
