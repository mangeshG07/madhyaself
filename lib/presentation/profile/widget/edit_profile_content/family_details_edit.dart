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
      body: SingleChildScrollView(
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
              SizedBox(height: 12),
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
                          if (controller.familyDetailsFormKey.currentState!
                              .validate()) {
                            await controller.updateFamilyDetails();
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

  Widget _buildFatherName(ThemeData theme) {
    return _buildTextField(
      'Father\'s Name',
      'Father\'s Name',
      controller.fatherNameController,
      theme,
    );

    //   AppTextField(
    //   filled: true,
    //   label: "Father's Name",
    //   showLabel: true,
    //   isRequired: true,
    //   minLines: 1,
    //   maxLines: 10,
    //   hint: "Father's Name",
    //   contentPadding: const EdgeInsets.all(15),
    //   focusedBorder: theme.inputDecorationTheme.focusedBorder,
    //   enabledBorder: theme.inputDecorationTheme.enabledBorder,
    //   textStyle: TextStyle(color: theme.colorScheme.onSurface),
    //   validator: AppValidators.required,
    //   labelStyle: theme.textTheme.labelMedium,
    //   controller: TextEditingController(),
    //   fillColor: theme.cardColor,
    //   keyboardType: TextInputType.text,
    // );
  }

  Widget _buildFatherJob(ThemeData theme) {
    return _buildTextField(
      'Father\'s Job',
      'Father\'s Job',
      controller.fatherJobController,
      theme,
    );

    //   AppTextField(
    //   filled: true,
    //   label: "Father's Job",
    //   showLabel: true,
    //   isRequired: true,
    //   minLines: 1,
    //   maxLines: 10,
    //   hint: "Father's Job",
    //   contentPadding: const EdgeInsets.all(15),
    //   focusedBorder: theme.inputDecorationTheme.focusedBorder,
    //   enabledBorder: theme.inputDecorationTheme.enabledBorder,
    //   textStyle: TextStyle(color: theme.colorScheme.onSurface),
    //   validator: AppValidators.required,
    //   labelStyle: theme.textTheme.labelMedium,
    //   controller: TextEditingController(),
    //   fillColor: theme.cardColor,
    //   keyboardType: TextInputType.text,
    // );
  }

  Widget _buildMotherName(ThemeData theme) {
    return _buildTextField(
      'Mother\'s Name',
      'Mother\'s Name',
      controller.motherNameController,
      theme,
    );

    //   AppTextField(
    //   filled: true,
    //   label: "Mother's Name",
    //   showLabel: true,
    //   isRequired: true,
    //   minLines: 1,
    //   maxLines: 10,
    //   hint: "Mother's Name",
    //   contentPadding: const EdgeInsets.all(15),
    //   focusedBorder: theme.inputDecorationTheme.focusedBorder,
    //   enabledBorder: theme.inputDecorationTheme.enabledBorder,
    //   textStyle: TextStyle(color: theme.colorScheme.onSurface),
    //   validator: AppValidators.required,
    //   labelStyle: theme.textTheme.labelMedium,
    //   controller: TextEditingController(),
    //   fillColor: theme.cardColor,
    //   keyboardType: TextInputType.text,
    // );
  }

  Widget _buildMotherJob(ThemeData theme) {
    return _buildTextField(
      'Mother\'s Job',
      'Mother\'s Job',
      controller.motherJobController,
      theme,
    );

    //   AppTextField(
    //   filled: true,
    //   label: "Mother's Job",
    //   showLabel: true,
    //   isRequired: true,
    //   minLines: 1,
    //   maxLines: 10,
    //   hint: "Mother's Job",
    //   contentPadding: const EdgeInsets.all(15),
    //   focusedBorder: theme.inputDecorationTheme.focusedBorder,
    //   enabledBorder: theme.inputDecorationTheme.enabledBorder,
    //   textStyle: TextStyle(color: theme.colorScheme.onSurface),
    //   validator: AppValidators.required,
    //   labelStyle: theme.textTheme.labelMedium,
    //   controller: TextEditingController(),
    //   fillColor: theme.cardColor,
    //   keyboardType: TextInputType.text,
    // );
  }

  Widget _buildSiblingsDetails(ThemeData theme) {
    return _buildTextField(
      'Siblings Details',
      'Siblings Details',
      controller.siblingController,
      theme,
    );

    //   AppTextField(
    //   filled: true,
    //   label: "Siblings Details",
    //   showLabel: true,
    //   isRequired: true,
    //   minLines: 1,
    //   maxLines: 10,
    //   hint: "Siblings Details",
    //   contentPadding: const EdgeInsets.all(15),
    //   focusedBorder: theme.inputDecorationTheme.focusedBorder,
    //   enabledBorder: theme.inputDecorationTheme.enabledBorder,
    //   textStyle: TextStyle(color: theme.colorScheme.onSurface),
    //   validator: AppValidators.required,
    //   labelStyle: theme.textTheme.labelMedium,
    //   controller: TextEditingController(),
    //   fillColor: theme.cardColor,
    //   keyboardType: TextInputType.text,
    // );
  }

  Widget _buildTextField(
    String title,
    String hint,
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
      hint: hint,
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface),
      validator: AppValidators.required,
      labelStyle: theme.textTheme.labelMedium,
      controller: controller,
      fillColor: theme.cardColor,
      keyboardType: TextInputType.text,
    );
  }
}
