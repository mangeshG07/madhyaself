import 'package:madhya/core/exporters/app_export.dart';

class PartnerReligionDetailsEdit extends GetView<PreferenceController> {
  const PartnerReligionDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Religious Preferences'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.religionDetailsFormKey,
          child: Column(
            spacing: 12.h,
            children: [
              Row(
                spacing: 16.w,
                children: [
                  Expanded(child: _buildReligionDropdown()),
                  Expanded(child: _buildCasteDropdown()),
                ],
              ),
              _buildSubCasteDropdown(),
              Obx(
                () => controller.isUpdating.isTrue
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReligionDropdown() {
    return AppDropdownField(
      isRequired: true,
      isDynamic: true,
      title: "Religion",
      value: controller.selectedReligion.value,
      items: controller.religionList,
      hintText: 'Select',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedReligion.value = val,
    );
  }

  Widget _buildCasteDropdown() {
    return AppDropdownField(
      isRequired: true,
      isDynamic: true,
      title: "Caste / Community",
      value: controller.selectedCaste.value,
      items: controller.casteList,
      hintText: 'Select',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedCaste.value = val,
    );
  }

  Widget _buildSubCasteDropdown() {
    return AppDropdownField(
      isRequired: true,
      isDynamic: true,
      title: "Sub Caste",
      value: controller.selectedSubCaste.value,
      items: controller.subCasteList,
      hintText: 'Sub Caste',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedSubCaste.value = val,
    );
  }
}
