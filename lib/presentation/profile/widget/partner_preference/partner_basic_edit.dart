import 'package:madhya/core/exporters/app_export.dart';

class PartnerBasicDetailsEdit extends GetView<PreferenceController> {
  const PartnerBasicDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Basic Details Edit'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.basicDetailsFormKey,
          child: Column(
            spacing: 12.h,
            children: [
              /// Marital Status
              _dropdownField(
                title: "Marital Status",
                value: controller.selectedMaritalStatus,
                items: controller.mStatusList,
              ),

              /// Age
              Row(
                children: [
                  Expanded(
                    child: _dropdownField(
                      title: "Age From",
                      value: controller.selectedAgeFrom,
                      items: controller.ageList
                          .map<String>((e) => e['name'].toString())
                          .toList(),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _dropdownField(
                      title: "Age To",
                      value: controller.selectedAgeTo,
                      items: controller.ageList
                          .map<String>((e) => e['name'].toString())
                          .toList(),
                    ),
                  ),
                ],
              ),

              /// Height
              Row(
                children: [
                  Expanded(
                    child: _dynamicDropdownField(
                      title: "Height From",
                      value: controller.selectedHeightFrom,
                      items: controller.heightList,
                      keyName: 'height_in_cm',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _dynamicDropdownField(
                      title: "Height To",
                      value: controller.selectedHeightTo,
                      items: controller.heightList,
                      keyName: 'height_in_cm',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              /// Button
              Obx(
                () => controller.isUpdating.isTrue
                    ? AppLoader.circular(
                        color: AppColors.lightPrimary,
                        strokeWidth: 2.5,
                        size: 22.r,
                      )
                    : AppButton(
                        text: 'Save Changes',
                        onTap: _onSubmit,
                        backgroundColor: AppColors.lightPrimary,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= COMMON STRING DROPDOWN =================
  Widget _dropdownField({
    required String title,
    required dynamic value,
    required List<String> items,
  }) {
    return Obx(() {
      final isValid = items.contains(value.value);

      return AppDropdownField(
        isRequired: true,
        title: title,
        value: isValid && value.value!.isNotEmpty ? value.value : null,
        items: items,
        hintText: "Select $title",
        validator: AppValidators.required,
        onChanged: (val) => value.value = val ?? '',
      );
    });
  }

  /// ================= DYNAMIC DROPDOWN (API DATA) =================
  Widget _dynamicDropdownField({
    required String title,
    required dynamic value,
    required List items,
    required String keyName,
  }) {
    return Obx(() {
      final isMatched = items.any((e) => e[keyName].toString() == value.value);

      return AppDropdownField(
        isRequired: true,
        title: title,
        value: isMatched && value.value.isNotEmpty ? value.value : null,
        items: items,
        hintText: "Select $title",
        validator: AppValidators.required,
        isHeight: true,
        isDynamic: true,
        onChanged: (val) => value.value = val ?? '',
      );
    });
  }

  /// ================= SUBMIT =================
  Future<void> _onSubmit() async {
    if (controller.basicDetailsFormKey.currentState!.validate()) {
      await controller.updateBasicDetails();
    }
  }
}

// import 'package:madhya/core/exporters/app_export.dart';
//
// class PartnerBasicDetailsEdit extends GetView<PreferenceController> {
//   const PartnerBasicDetailsEdit({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppbar(title: 'Basic Details Edit'),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.w),
//         child: Form(
//           key: controller.basicDetailsFormKey,
//           child: Column(
//             spacing: 12.h,
//             children: [
//               /// Marital Status
//               _dropdownField(
//                 title: "Marital Status",
//                 value: controller.selectedMaritalStatus,
//                 items: controller.mStatusList,
//               ),
//
//               /// Age
//               Row(
//                 spacing: 16.w,
//                 children: [
//                   Expanded(child: _buildAgeFromDropdown()),
//                   Expanded(child: _buildAgeToDropdown()),
//                 ],
//               ),
//               Row(
//                 spacing: 16.w,
//                 children: [
//                   Expanded(child: _buildHeightFromDropdown()),
//                   Expanded(child: _buildHeightToDropdown()),
//                 ],
//               ),
//               SizedBox(height: 12.h),
//               Obx(
//                 () => controller.isUpdating.isTrue
//                     ? AppLoader.circular(
//                         color: AppColors.lightPrimary,
//                         strokeWidth: 2.5,
//                         size: 22.r,
//                       )
//                     : AppButton(
//                         text: 'Save Changes',
//                         onTap: _onSubmit,
//                         backgroundColor: AppColors.lightPrimary,
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// ================= COMMON DROPDOWN =================
//   Widget _dropdownField({
//     required String title,
//     required dynamic value,
//     required List items,
//     bool isHeight = false,
//     bool isDynamic = false,
//   }) {
//     return AppDropdownField(
//       isRequired: true,
//       title: title,
//       value: value.value,
//       items: items,
//       hintText: "Select $title",
//       validator: AppValidators.required,
//       isHeight: isHeight,
//       isDynamic: isDynamic,
//       onChanged: (val) => value.value = val,
//     );
//   }
//
//   /// ================= SUBMIT =================
//   Future<void> _onSubmit() async {
//     if (controller.basicDetailsFormKey.currentState!.validate()) {
//       await controller.updateBasicDetails();
//     }
//   }
//
//   Widget _buildAgeFromDropdown() {
//     final selectedAge = controller.selectedAgeFrom;
//
//     final isMatched =
//         selectedAge.value != null &&
//         controller.ageList.any(
//           (v) => v['name'].toString() == selectedAge.value.toString(),
//         );
//
//     return AppDropdownField(
//       isRequired: true,
//       title: 'Age From',
//       value: !isMatched ? null : controller.selectedAgeFrom.value,
//       items: controller.ageList
//           .map<String>((e) => e['name'].toString())
//           .toList(),
//       hintText: "Select Age",
//       validator: AppValidators.required,
//       onChanged: (val) => controller.selectedAgeFrom.value = val,
//     );
//   }
//
//   Widget _buildAgeToDropdown() {
//     final selectedAge = controller.selectedAgeTo;
//
//     final isMatched =
//         selectedAge.value != null &&
//         controller.ageList.any(
//           (v) => v['name'].toString() == selectedAge.value.toString(),
//         );
//
//     return AppDropdownField(
//       isRequired: true,
//       title: 'Age To',
//       value: !isMatched ? null : controller.selectedAgeTo.value,
//       items: controller.ageList
//           .map<String>((e) => e['name'].toString())
//           .toList(),
//       hintText: "Select Age",
//       validator: AppValidators.required,
//       onChanged: (val) => controller.selectedAgeTo.value = val,
//     );
//   }
//
//   Widget _buildHeightFromDropdown() {
//     final selectedHeight = controller.selectedHeightFrom;
//
//     final isMatched =
//         selectedHeight.value != null &&
//         controller.heightList.any(
//           (v) =>
//               v['height_in_cm'].toString() == selectedHeight.value.toString(),
//         );
//     return AppDropdownField(
//       isRequired: true,
//       title: 'Height From',
//       value: !isMatched ? null : controller.selectedHeightFrom.value,
//       items: controller.heightList,
//       hintText: "Select Height",
//       validator: AppValidators.required,
//       isHeight: true,
//       isDynamic: true,
//       onChanged: (val) => controller.selectedHeightFrom.value = val,
//     );
//   }
//
//   Widget _buildHeightToDropdown() {
//     final selectedHeight = controller.selectedHeightTo;
//
//     final isMatched =
//         selectedHeight.value != null &&
//         controller.heightList.any(
//           (v) => v['height_in_cm'].toString() == selectedHeight.value,
//         );
//
//     return AppDropdownField(
//       isRequired: true,
//       title: 'Height To',
//       value: !isMatched ? null : controller.selectedHeightTo.value,
//       items: controller.heightList,
//       hintText: "Select height",
//       validator: AppValidators.required,
//       isHeight: true,
//       isDynamic: true,
//       onChanged: (val) => controller.selectedHeightTo.value = val,
//     );
//   }
// }
