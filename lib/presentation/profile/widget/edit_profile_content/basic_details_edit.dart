import 'package:madhya/core/exporters/app_export.dart';

class BasicDetailsEdit extends GetView<ProfileController> {
  const BasicDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Basic Details Edit',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.basicDetailsFormKey,
          child: Column(
            spacing: 12.h,
            children: [
              _headerSection(),
              IgnorePointer(
                ignoring: true,
                child: _textField(
                  theme,
                  label: 'Mobile Number',
                  controller: TextEditingController(
                    text: controller.profileDetails['mobile_no'] ?? '',
                  ),
                ),
              ),
              _textField(
                theme,
                label: 'WhatsApp Number',
                controller: controller.whatsappNoController,
              ),

              _textField(
                theme,
                label: 'Alternative Number',
                controller: controller.alternateNoController,
              ),
              Row(
                spacing: 16.w,
                children: [
                  Expanded(child: _buildAgeDropdown()),
                  Expanded(child: _buildStatusDropdown()),
                ],
              ),
              Row(
                spacing: 16.w,
                children: [
                  Expanded(child: _buildHeightDropdown()),
                  Expanded(child: _buildCreatedForDropdown()),
                ],
              ),
              SizedBox(height: 12.h),
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
                          if (controller.basicDetailsFormKey.currentState!
                              .validate()) {
                            await controller.updateBasicDetails();
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

  Widget _headerSection() {
    return Row(
      spacing: 16.w,
      children: [
        buildDetailItem(
          label: 'Name',
          value: controller.profileDetails['name'] ?? '',
        ),
        buildDetailItem(
          label: 'Gender',
          value: controller.profileDetails['gender'].toString() == '0'
              ? "Male"
              : 'Female',
        ),
      ],
    );
  }

  Widget _buildAgeDropdown() {
    return Obx(
      () => AppDropdownField(
        isRequired: true,
        title: "Select Your Age",
        value: controller.selectedAge.value,
        items: controller.ageList.map((e) => e['name']).toList(),
        hintText: 'Select your Age',
        validator: AppValidators.required,
        onChanged: (val) => controller.selectedAge.value = val,
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Obx(
      () => AppDropdownField(
        isRequired: true,
        title: "Marital Status",
        value: controller.selectedMStatus.value,
        items: controller.mStatusList,
        hintText: 'Marital Status',
        validator: AppValidators.required,
        onChanged: (val) => controller.selectedMStatus.value = val,
      ),
    );
  }

  Widget _buildCreatedForDropdown() {
    return AppDropdownField(
      isRequired: true,
      title: "Profile Created For",
      value: controller.selectedCreatedFor.value,
      items: controller.createdForList,
      hintText: 'Select',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedCreatedFor.value = val,
    );
  }

  Widget _buildHeightDropdown() {
    return Obx(
      () => AppDropdownField(
        isRequired: true,
        isHeight: true,
        isDynamic: true,
        title: "Select Your Height",
        value: controller.selectedHeight.value,
        items: controller.heightList,
        hintText: 'Select',
        validator: AppValidators.required,
        onChanged: (val) => controller.selectedHeight.value = val,
      ),
    );
  }

  // ---------------- TEXTFIELD COMPONENT ----------------

  Widget _textField(
    ThemeData theme, {
    required String label,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return AppTextField(
      filled: true,
      label: label,
      showLabel: true,
      controller: controller,
      enabled: enabled,
      validator: AppValidators.phone,
      hint: label,
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface),
      labelStyle: theme.textTheme.labelMedium,
      prefixIcon: const _CountryPrefix(),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      fillColor: theme.cardColor,
    );
  }
}

// ---------------- COMMON PREFIX ----------------
class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppAssets.flag, width: 25, height: 25),
          SizedBox(width: 8.w),
          AppText(text: '+91', fontSize: 14.sp),
        ],
      ),
    );
  }
}
