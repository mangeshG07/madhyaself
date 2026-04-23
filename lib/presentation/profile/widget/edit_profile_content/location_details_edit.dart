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
      body: SingleChildScrollView(
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
              SizedBox(height: 16.h),
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
                          if (controller.locationDetailsFormKey.currentState!
                              .validate()) {
                            await controller.updateLocationDetails();
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

  Widget _buildCountryDropdown() {
    return AppDropdownField(
      isRequired: true,
      title: "Select Your Country",
      value: controller.selectedCountry.value,
      items: controller.countryList,
      hintText: 'Country',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedCountry.value = val,
    );
  }

  Widget _buildStateDropdown() {
    return AppDropdownSearch<String>(
      title: "Select State",
      isRequired: true,
      value: controller.selectedState.value,
      items: controller.stateList.map<String>((e) => e['name']).toList(),
      hintText: "State",
      showSearchBox: true,
      searchHintText: "",
      onChanged: (val) => controller.selectedState.value = val,
      validator: AppValidators.required,
    );
  }

  Widget _buildCityDropdown() {
    return AppDropdownSearch<String>(
      title: "Select City",
      isRequired: true,
      value: controller.selectedCity.value,
      items: controller.cityList.map<String>((e) => e['name']).toList(),
      hintText: "City",
      showSearchBox: true,
      searchHintText: "",
      onChanged: (val) => controller.selectedCity.value = val,
      validator: AppValidators.required,
    );
  }
}
