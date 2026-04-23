import 'package:madhya/core/exporters/app_export.dart';

class AboutMeEdit extends GetView<ProfileController> {
  const AboutMeEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'About Me Edit',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.aboutMeDetailsFormKey,
          child: Column(
            spacing: 16.h,
            children: [
              AppTextField(
                filled: true,
                label: 'About me',
                showLabel: false,
                maxLines: 500,
                minLines: 1,
                hint: 'About me',
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

              Obx(
                () => controller.isUpdateLoading.isTrue
                    ? AppLoader.circular(
                        color: AppColors.lightPrimary,
                        strokeWidth: 2.5,
                        size: 22.r,
                      )
                    : AppButton(
                        text: 'Submit',
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
    );
  }
}
