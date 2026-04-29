import '../../../../core/exporters/app_export.dart';

class PartnerProfessionalDetailsEdit extends GetView<PreferenceController> {
  const PartnerProfessionalDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(title: 'Professional Info Edit'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.professionalDetailsFormKey,
          child: Column(
            spacing: 12.h,
            children: [
              _buildEduCategoryDropdown(),
              _buildEducationDetail(theme),
              _buildJobCatDropdown(),
              _buildJobDetail(theme),
              _buildAnnualIncomeDropdown(),
              SizedBox(height: 12.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEduCategoryDropdown() {
    return AppDropdownField(
      isRequired: true,
      isDynamic: true,
      title: "Education Category",
      value: controller.selectedEducation.value,
      items: controller.educationCategoryList,
      hintText: 'Choose category',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedEducation.value = val,
    );
  }

  Widget _buildEducationDetail(ThemeData theme) {
    return AppTextField(
      filled: true,
      label: 'Education Detail',
      showLabel: true,
      isRequired: true,
      minLines: 1,
      maxLines: 10,
      hint: 'Education Detail',
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface),
      validator: AppValidators.required,
      labelStyle: theme.textTheme.labelMedium,
      controller: controller.educationCtrl,
      fillColor: theme.cardColor,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildJobCatDropdown() {
    return AppDropdownField(
      isRequired: true,
      isDynamic: true,
      title: "Job Category",
      value: controller.selectedJob.value,
      items: controller.jobCategoryList,
      hintText: 'Select Category',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedJob.value = val,
    );
  }

  Widget _buildJobDetail(ThemeData theme) {
    return AppTextField(
      filled: true,
      label: 'Job Detail',
      showLabel: true,
      isRequired: true,
      minLines: 1,
      maxLines: 10,
      hint: 'Job Detail',
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface),
      validator: AppValidators.required,
      labelStyle: theme.textTheme.labelMedium,
      controller: controller.jobCtrl,
      fillColor: theme.cardColor,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildAnnualIncomeDropdown() {
    final isMatched = controller.annualIncomeList.any(
      (e) => e['name'].toString() == controller.selectedIncome.value,
    );
    return AppDropdownField(
      isRequired: true,
      title: "Annual Income",
      value: isMatched && controller.selectedIncome.value!.isNotEmpty
          ? controller.selectedIncome.value
          : null,
      items: controller.annualIncomeList.map((e) => e['name']).toList(),
      hintText: 'Annual Income',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedIncome.value = val,
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => controller.isUpdating.isTrue
          ? AppLoader.circular(
              color: AppColors.lightPrimary,
              strokeWidth: 2.5,
              size: 22.r,
            )
          : AppButton(
              text: 'Save Changes',
              onTap: () async {
                if (controller.professionalDetailsFormKey.currentState!
                    .validate()) {
                  await controller.updateProfessionalDetails();
                }
              },
              backgroundColor: AppColors.lightPrimary,
            ),
    );
  }
}
