import '../../../../core/exporters/app_export.dart';

class LocationDetailsEdit extends GetView<ProfileController> {
  const LocationDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Location Details Edit',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.locationDetailsFormKey,
            child: Column(
              spacing: 12.h,
              children: [
                Row(
                  spacing: 16.w,
                  children: [
                    Expanded(child: _buildCountryDropdown()),
                    Expanded(child: _buildStateDropdown()),
                  ],
                ),
                Row(
                  spacing: 16.w,
                  children: [Expanded(child: _buildCityDropdown())],
                ),
                AppTextField(
                  filled: true,
                  label: 'Address',
                  showLabel: true,
                  isRequired: true,
                  minLines: 1,
                  maxLines: 10,
                  hint: 'Address',
                  showCharacterCount: true,
                  maxLength: 100,
                  contentPadding: const EdgeInsets.all(15),
                  focusedBorder: theme.inputDecorationTheme.focusedBorder,
                  enabledBorder: theme.inputDecorationTheme.enabledBorder,
                  textStyle: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14.sp,
                  ),
                  validator: AppValidators.required,
                  labelStyle: theme.textTheme.labelMedium,
                  controller: controller.addressController,
                  fillColor: theme.cardColor,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16.h),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🌍 COUNTRY
  Widget _buildCountryDropdown() {
    return AppDropdownField(
      isRequired: true,
      title: "Country",
      value: controller.selectedCountry.value,
      items: controller.countryList,
      hintText: 'Select Country',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedCountry.value = val,
    );
  }

  // 🏙️ STATE
  Widget _buildStateDropdown() {
    return AppDropdownSearch<String>(
      title: "State",
      isRequired: true,
      value: controller.selectedState.value,
      items: controller.stateList.map<String>((e) => e['name']).toList(),
      hintText: "Select State",
      showSearchBox: true,
      searchHintText: "Search State",
      onChanged: (val) => controller.selectedState.value = val,
      validator: AppValidators.required,
    );
  }

  // 🏡 CITY
  Widget _buildCityDropdown() {
    return AppDropdownSearch<String>(
      title: "City",
      isRequired: true,
      value: controller.selectedCity.value,
      items: controller.cityList.map<String>((e) => e['name']).toList(),
      hintText: "Select City",
      showSearchBox: true,
      searchHintText: "Search City",
      onChanged: (val) => controller.selectedCity.value = val,
      validator: AppValidators.required,
    );
  }

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
                if (controller.locationDetailsFormKey.currentState!
                    .validate()) {
                  await controller.updateLocationDetails();
                }
              },
              backgroundColor: AppColors.lightPrimary,
            ),
    );
  }
}
