import 'package:madhya/core/exporters/app_export.dart';

class GlobalSearch extends GetView<GlobalSearchController> {
  const GlobalSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(title: 'Global Search'),
      body: Obx(
        () => controller.isLoading.isTrue
            ? AppLoader.circular(color: AppColors.lightPrimary)
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  spacing: 12.h,
                  children: [
                    AppTextField(
                      filled: true,
                      label: 'Search By Username',
                      showLabel: true,
                      minLines: 1,
                      hint: 'Username',
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: theme.inputDecorationTheme.focusedBorder,
                      enabledBorder: theme.inputDecorationTheme.enabledBorder,
                      textStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14.sp,
                      ),
                      labelStyle: theme.textTheme.labelMedium,
                      controller: controller.username,
                      fillColor: theme.cardColor,
                    ),

                    _dropdownField(
                      isDynamic: true,
                      title: "Religion",
                      value: controller.selectedReligion,
                      items: controller.religionList,
                    ),

                    _dropdownField(
                      isDynamic: true,
                      title: "Caste",
                      value: controller.selectedCaste,
                      items: controller.casteList,
                    ),

                    _buildRangeRow(
                      isDynamic: true,
                      isHeight: true,
                      title: "Height",
                      fromValue: controller.selectedHeightFrom,
                      toValue: controller.selectedHeightTo,
                      items: controller.heightList,
                    ),

                    _buildRangeRow(
                      title: "Age",
                      fromValue: controller.selectedAgeFrom,
                      toValue: controller.selectedAgeTo,
                      items: controller.ageList
                          .map<String>((e) => e['name'].toString())
                          .toList(),
                    ),
                    _dropdownField(
                      isDynamic: true,
                      title: "Income",
                      value: controller.selectedIncome,
                      items: controller.annualIncomeList,
                    ),

                    _dropdownField(
                      isDynamic: true,
                      title: "Education",
                      value: controller.selectedEducation,
                      items: controller.educationCategoryList,
                    ),

                    _dropdownField(
                      isDynamic: true,
                      title: "Occupation",
                      value: controller.selectedJob,
                      items: controller.jobCategoryList,
                    ),

                    _dropdownField(
                      title: "Country",
                      value: controller.selectedCountry,
                      items: controller.countryList,
                    ),
                    AppDropdownSearch<String>(
                      title: "State",
                      isRequired: false,
                      value: controller.selectedState.value,
                      items: controller.stateList
                          .map<String>((e) => e['name'])
                          .toList(),
                      hintText: "State",
                      showSearchBox: true,
                      searchHintText: "",
                      onChanged: (val) => controller.selectedState.value = val,
                      validator: AppValidators.required,
                    ),
                    AppDropdownSearch<String>(
                      title: "City",
                      isRequired: false,
                      value: controller.selectedCity.value,
                      items: controller.cityList
                          .map<String>((e) => e['name'])
                          .toList(),
                      hintText: "City",
                      showSearchBox: true,
                      searchHintText: "",
                      onChanged: (val) => controller.selectedCity.value = val,
                      validator: AppValidators.required,
                    ),
                    //
                    // TextButton(
                    //   onPressed: () {},
                    //   child: AppText(
                    //     text: 'Less Filters',
                    //     fontSize: 14.sp,
                    //     color: AppColors.lightTextMidColor,
                    //   ),
                    // ),
                    Obx(
                      () => AppButton(
                        text: controller.isSearching.value
                            ? 'Searching...'
                            : 'Search',
                        onTap: controller.isSearching.value
                            ? null
                            : () async => await controller.globalSearch(),
                        backgroundColor: AppColors.lightPrimary,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildToWord() {
    return Padding(
      padding: EdgeInsets.only(top: 16.w),
      child: Center(child: AppText(text: 'To', fontSize: 14)),
    );
  }

  /// ================= COMMON DROPDOWN =================
  Widget _dropdownField({
    required String title,
    required Rxn<String> value,
    required List items,
    bool isHeight = false,
    bool isDynamic = false,
  }) {
    return Obx(
      () => AppDropdownField(
        isRequired: false,
        title: title,
        value: value.value,
        items: items,
        hintText: "Select",
        validator: AppValidators.required,
        isHeight: isHeight,
        isDynamic: isDynamic,
        onChanged: (val) => value.value = val, // ✅ correct update
      ),
    );
  }

  /// 🔹 Range Row (From - To)
  Widget _buildRangeRow({
    required String title,
    required Rxn<String> fromValue,
    required Rxn<String> toValue,
    required dynamic items,
    bool isHeight = false,
    bool isDynamic = false,
  }) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: _dropdownField(
            isHeight: isHeight,
            isDynamic: isDynamic,
            title: title,
            value: fromValue,
            items: items,
          ),
        ),

        _buildToWord(),

        Expanded(
          child: _dropdownField(
            isHeight: isHeight,
            isDynamic: isDynamic,
            title: title,
            value: toValue,
            items: items,
          ),
        ),
      ],
    );
  }
}
