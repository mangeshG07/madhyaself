import 'package:madhya/core/exporters/app_export.dart';

class PartnerBasicDetailsEdit extends StatelessWidget {
  PartnerBasicDetailsEdit({super.key});

  final controller = getIt<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Basic Details Edit'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          spacing: 12.h,
          children: [
            Row(
              spacing: 16.w,
              children: [Expanded(child: _buildStatusDropdown())],
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
            AppButton(
              text: 'Submit',
              onTap: () {},
              backgroundColor: AppColors.lightPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return AppDropdownSearch<String>(
      title: "Marital Status",
      isRequired: true,
      value: controller.selectedMStatus.value,
      items: controller.mStatusList,
      hintText: "Marital Status",
      showSearchBox: false,
      searchHintText: "",
      onChanged: (val) => controller.selectedMStatus.value = val,
      validator: AppValidators.required,
    );
  }

  Widget _buildAgeFromDropdown() {
    return AppDropdownSearch<String>(
      title: "Partner Age From",
      isRequired: true,
      value: controller.selectedAge.value,
      items: controller.mStatusList,
      hintText: "Select",
      showSearchBox: false,
      searchHintText: "Search Age from",
      onChanged: (val) => controller.selectedAge.value = val,
      validator: AppValidators.required,
    );
  }

  Widget _buildAgeToDropdown() {
    return AppDropdownSearch<String>(
      title: "Partner Age To",
      isRequired: true,
      value: controller.selectedAge.value,
      items: controller.mStatusList,
      hintText: "Select",
      showSearchBox: false,
      searchHintText: "Search Age To",
      onChanged: (val) => controller.selectedAge.value = val,
      validator: AppValidators.required,
    );
  }

  Widget _buildHeightFromDropdown() {
    return AppDropdownSearch<String>(
      title: "Partner Height From",
      isRequired: true,
      value: controller.selectedAge.value,
      items: controller.mStatusList,
      hintText: "Select",
      showSearchBox: false,
      searchHintText: "Search Height from",
      onChanged: (val) => controller.selectedAge.value = val,
      validator: AppValidators.required,
    );
  }

  Widget _buildHeightToDropdown() {
    return AppDropdownSearch<String>(
      title: "Partner Height To",
      isRequired: true,
      value: controller.selectedAge.value,
      items: controller.mStatusList,
      hintText: "Select",
      showSearchBox: false,
      searchHintText: "Search Height To",
      onChanged: (val) => controller.selectedAge.value = val,
      validator: AppValidators.required,
    );
  }
}
