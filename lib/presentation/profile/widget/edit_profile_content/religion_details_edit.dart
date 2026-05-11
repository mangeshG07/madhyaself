import 'package:madhya/core/exporters/app_export.dart';

class ReligionDetailsEdit extends GetView<ProfileController> {
  const ReligionDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Religion Info Edit',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.religionDetailsFormKey,
            child: Column(
              spacing: 12.h,
              children: [
                Row(
                  spacing: 16.w,
                  children: [
                    Expanded(child: _buildReligionField(theme)),
                    Expanded(child: _buildCasteDropdown()),
                  ],
                ),
                _buildSubCasteDropdown(),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 READONLY RELIGION
  Widget _buildReligionField(ThemeData theme) {
    return IgnorePointer(
      ignoring: true,
      child: AppTextField(
        fillColor: theme.scaffoldBackgroundColor,
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(15),
        label: 'Religion',
        textStyle: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14.sp,
        ),
        labelStyle: theme.textTheme.labelMedium,
        showLabel: true,
        controller: TextEditingController(
          text: controller.profileDetails['religion']?.toString() ?? '',
        ),
      ),
    );
  }

  // 🔽 CASTE DROPDOWN
  Widget _buildCasteDropdown() {
    return AppDropdownField(
      isRequired: true,
      isDynamic: true,
      title: "Caste / Community",
      value: controller.selectedCaste.value,
      items: controller.casteList,
      hintText: 'Select',
      validator: AppValidators.required,
      onChanged: (val) {
        controller.selectedCaste.value = val;
        controller.fetchSubCaste(val.toString());
      },
    );
  }

  // 🔽 SUB CASTE DROPDOWN
  Widget _buildSubCasteDropdown() {
    return Obx(() {
      return AppDropdownField(
        isRequired: true,
        isDynamic: true,
        title: "Select Your Subcaste",
        value: controller.selectedSubCaste.value,
        items: controller.subCasteList,
        hintText: controller.isSubCasteLoading.value
            ? "Loading Subcaste..."
            : "Select your Subcaste",
        validator: AppValidators.required,
        onChanged: controller.isSubCasteLoading.value
            ? null
            : (val) => controller.selectedSubCaste.value = val,
      );
    });
  }

  // Widget _buildSubCasteDropdown() {
  //   return AppDropdownField(
  //     isRequired: true,
  //     isDynamic: true,
  //     title: "Sub Caste",
  //     value: controller.selectedSubCaste.value,
  //     items: controller.subCasteList,
  //     hintText: 'Sub Caste',
  //     validator: AppValidators.required,
  //     onChanged: (val) => controller.selectedSubCaste.value = val,
  //   );
  // }

  // 🔽 SUBMIT BUTTON
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
                if (controller.religionDetailsFormKey.currentState!
                    .validate()) {
                  await controller.updateReligionDetails();
                }
              },
              backgroundColor: AppColors.lightPrimary,
            ),
    );
  }
}
