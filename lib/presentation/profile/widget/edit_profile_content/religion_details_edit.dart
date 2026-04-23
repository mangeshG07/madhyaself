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
                  buildDetailItem(
                    label: 'Religion',
                    value:
                        controller.profileDetails['religion']?.toString() ?? '',
                  ),
                  Expanded(child: _buildCasteDropdown()),
                ],
              ),
              _buildSubCasteDropdown(),
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

    //   AppDropdownSearch<String>(
    //   title: "Caste / Community",
    //   isRequired: true,
    //   value: controller.selectedAge.value,
    //   items: controller.ageList,
    //   hintText: "Select",
    //   showSearchBox: false,
    //   searchHintText: "Search Caste / Community",
    //   onChanged: (val) => controller.selectedAge.value = val,
    //   validator: AppValidators.required,
    // );
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

    //   AppDropdownSearch<String>(
    //   title: "Sub Caste",
    //   isRequired: true,
    //   value: controller.selectedAge.value,
    //   items: controller.ageList,
    //   hintText: "Select",
    //   showSearchBox: false,
    //   searchHintText: "Search Sub Caste",
    //   onChanged: (val) => controller.selectedAge.value = val,
    //   validator: AppValidators.required,
    // );
  }
}
