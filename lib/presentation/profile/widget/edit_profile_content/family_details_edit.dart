import 'package:madhya/core/exporters/app_export.dart';

class FamilyDetailsEdit extends GetView<ProfileController> {
  const FamilyDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Family Details Edit',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.familyDetailsFormKey,
            child: Column(
              spacing: 12.h,
              children: [
                _buildFatherName(theme),
                _buildFatherJob(theme),
                _buildMotherName(theme),
                _buildMotherJob(theme),
                _buildSiblingsDetails(theme),
                const SizedBox(height: 12),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFatherName(ThemeData theme) {
    return _buildTextField(
      'Father\'s Name',
      controller.fatherNameController,
      theme,
    );
  }

  Widget _buildFatherJob(ThemeData theme) {
    return _buildTextField(
      'Father\'s Job',
      controller.fatherJobController,
      theme,
    );
  }

  Widget _buildMotherName(ThemeData theme) {
    return _buildTextField(
      'Mother\'s Name',
      controller.motherNameController,
      theme,
    );
  }

  Widget _buildMotherJob(ThemeData theme) {
    return _buildTextField(
      'Mother\'s Job',
      controller.motherJobController,
      theme,
    );
  }

  Widget _buildSiblingsDetails(ThemeData theme) {
    return _buildTextField(
      'Siblings Details',
      controller.siblingController,
      theme,
    );
  }

  // 🔤 COMMON TEXT FIELD
  Widget _buildTextField(
    String title,
    TextEditingController controller,
    ThemeData theme,
  ) {
    return AppTextField(
      filled: true,
      label: title,
      showLabel: true,
      isRequired: true,
      minLines: 1,
      maxLines: 10,
      hint: title,
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
      validator: AppValidators.required,
      labelStyle: theme.textTheme.labelMedium,
      controller: controller,
      fillColor: theme.cardColor,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => controller.isUpdateLoading.isTrue
          ? AppLoader.circular(
              color: AppColors.lightPrimary,
              strokeWidth: 2.5,
              size: 22.r,
            )
          : AppButton(
              text: 'Save Changes',
              onTap: () async {
                if (controller.familyDetailsFormKey.currentState!.validate()) {
                  await controller.updateFamilyDetails();
                }
              },
              backgroundColor: AppColors.lightPrimary,
            ),
    );
  }
}
