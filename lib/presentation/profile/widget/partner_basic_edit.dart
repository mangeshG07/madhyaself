import 'package:madhya/core/exporters/app_export.dart';

class PartnerBasicDetailsEdit2 extends GetView<PreferenceController> {
  const PartnerBasicDetailsEdit2({super.key});

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
              Row(
                spacing: 16.w,
                children: [
                  Expanded(child: _buildAgeFromDropdown()),
                  Expanded(child: _buildAgeToDropdown()),
                ],
              ),
              Row(
                spacing: 16.w,
                children: [
                  Expanded(child: _buildHeightFromDropdown()),
                  Expanded(child: _buildHeightToDropdown()),
                ],
              ),
              SizedBox(height: 12.h),
              Obx(
                () => controller.isUpdating.isTrue
                    ? AppLoader.circular(
                        color: AppColors.lightPrimary,
                        strokeWidth: 2.5,
                        size: 22.r,
                      )
                    : AppButton(
                        text: 'Submit',
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

  /// ================= COMMON DROPDOWN =================
  Widget _dropdownField({
    required String title,
    required dynamic value,
    required List items,
    bool isHeight = false,
    bool isDynamic = false,
  }) {
    return Obx(
      () => AppDropdownField(
        isRequired: true,
        title: title,
        value: value.value,
        items: items,
        hintText: "Select $title",
        validator: AppValidators.required,
        isHeight: isHeight,
        isDynamic: isDynamic,
        onChanged: (val) => value.value = val,
      ),
    );
  }

  /// ================= SUBMIT =================
  Future<void> _onSubmit() async {
    if (controller.basicDetailsFormKey.currentState!.validate()) {
      await controller.updateBasicDetails();
    }
  }

  Widget _buildAgeFromDropdown() {
    return _dropdownField(
      title: "From",
      value: controller.selectedAgeFrom,
      items: controller.ageList
          .map<String>((e) => e['name'].toString())
          .toList(),
    );
  }

  Widget _buildAgeToDropdown() {
    return _dropdownField(
      title: "To",
      value: controller.selectedAgeTo,
      items: controller.ageList
          .map<String>((e) => e['name'].toString())
          .toList(),
    );
  }

  Widget _buildHeightFromDropdown() {
    return _dropdownField(
      title: "From",
      value: controller.selectedHeightFrom,
      items: controller.heightList,
      isHeight: true,
      isDynamic: true,
    );
  }

  Widget _buildHeightToDropdown() {
    return _dropdownField(
      title: "To",
      value: controller.selectedHeightTo,
      items: controller.heightList,
      isHeight: true,
      isDynamic: true,
    );
  }
}
