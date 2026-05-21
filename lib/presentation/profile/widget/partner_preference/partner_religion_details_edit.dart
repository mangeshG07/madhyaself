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
    return AppMultiDropdown(
      title: "Religion",
      isRequired: true,
      items: controller.religionList
          .map((item) => item['name'].toString())
          .toList(),
      selectedItems: List<String>.from(controller.selectedReligionList),
      hintText: "Religion",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select Religion";
        }
        return null;
      },
      onChanged: (selected) async {
        controller.selectedReligionList.value = selected;

        // get selected ids
        final selectedIds = controller.religionList
            .where((item) => selected.contains(item['name'].toString()))
            .map((item) => item['id'].toString())
            .toList();

        controller.selectedReligionIdsList.value = selectedIds;
        controller.selectedCasteList.clear();
        controller.selectedCasteIdsList.clear();

        controller.selectedSubCasteList.clear();
        controller.selectedSubCasteIdsList.clear();
        await controller.fetchCaste();
      },
    );

    // AppDropdownField(
    //   isRequired: true,
    //   isDynamic: true,
    //   title: "Religion",
    //   value: controller.selectedReligion.value,
    //   items: controller.religionList,
    //   hintText: 'Select',
    //   validator: AppValidators.required,
    //   onChanged: (val) {
    //     controller.selectedReligion.value = val;
    //     controller.fetchCaste(val.toString());
    //   },
    // );
  }

  Widget _buildCasteDropdown() {
    return Obx(
      () => AppMultiDropdown(
        title: "Caste",
        isRequired: true,
        items: controller.casteList
            .map((item) => item['name'].toString())
            .toList(),
        selectedItems: List<String>.from(controller.selectedCasteList),
        hintText: controller.isCasteLoading.value
            ? "Loading caste..."
            : "Select your Caste",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select Caste";
          }
          return null;
        },
        onChanged: (selected) async {
          controller.selectedCasteList.value = selected;

          // get selected ids
          final selectedIds = controller.casteList
              .where((item) => selected.contains(item['name'].toString()))
              .map((item) => item['id'].toString())
              .toList();

          controller.selectedCasteIdsList.value = selectedIds;
          controller.selectedSubCasteList.clear();
          controller.selectedSubCasteIdsList.clear();
          await controller.fetchSubCaste();
        },
      ),
    );

    //   Obx(() {
    //   return AppDropdownField(
    //     isRequired: true,
    //     isDynamic: true,
    //     title: "Select Your Caste",
    //     value: controller.selectedCaste.value,
    //     items: controller.casteList,
    //     hintText: controller.isCasteLoading.value
    //         ? "Loading caste..."
    //         : "Select your Caste",
    //     validator: AppValidators.required,
    //     onChanged: controller.isCasteLoading.value
    //         ? null
    //         : (val) {
    //             controller.selectedCaste.value = val;
    //             controller.fetchSubCaste(val.toString());
    //           },
    //   );
    // });
  }

  Widget _buildSubCasteDropdown() {
    return Obx(
      () => AppMultiDropdown(
        title: "Subcaste",
        isRequired: true,
        items: controller.subCasteList
            .map((item) => item['name'].toString())
            .toList(),
        selectedItems: List<String>.from(controller.selectedSubCasteList),
        hintText: controller.isSubCasteLoading.value
            ? "Loading Subcaste..."
            : "Select your Subcaste",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select Subcaste";
          }
          return null;
        },
        onChanged: (selected) {
          controller.selectedSubCasteList.value = selected;

          // get selected ids
          final selectedIds = controller.subCasteList
              .where((item) => selected.contains(item['name'].toString()))
              .map((item) => item['id'].toString())
              .toList();

          controller.selectedSubCasteIdsList.value = selectedIds;
        },
      ),
    );

    // Obx(() {
    //   return AppDropdownField(
    //     isRequired: true,
    //     isDynamic: true,
    //     title: "Select Your Subcaste",
    //     value: controller.selectedSubCaste.value,
    //     items: controller.subCasteList,
    //     hintText: controller.isSubCasteLoading.value
    //         ? "Loading Subcaste..."
    //         : "Select your Subcaste",
    //     validator: AppValidators.required,
    //     onChanged: controller.isSubCasteLoading.value
    //         ? null
    //         : (val) => controller.selectedSubCaste.value = val,
    //   );
    // });
  }

  // Widget _buildCasteDropdown() {
  //   return AppDropdownField(
  //     isRequired: true,
  //     isDynamic: true,
  //     title: "Caste / Community",
  //     value: controller.selectedCaste.value,
  //     items: controller.casteList,
  //     hintText: 'Select',
  //     validator: AppValidators.required,
  //     onChanged: (val) => controller.selectedCaste.value = val,
  //   );
  // }
  //
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
}
