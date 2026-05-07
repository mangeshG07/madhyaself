import 'package:madhya/core/exporters/app_export.dart';

class GlobalSearch extends GetView<GlobalSearchController> {
  const GlobalSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    controller.resetFilters();
    return Scaffold(
      appBar: CustomAppbar(title: 'Global Search'),
      body: Obx(
        () => controller.isLoading.isTrue
            ? AppLoader.circular(color: AppColors.lightPrimary)
            : SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    spacing: 12.h,
                    children: [
                      AppTextField(
                        filled: true,
                        label: 'Search by Madhyasthi Id',
                        showLabel: true,
                        minLines: 1,
                        hint: 'Madhyasthi Id',
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
                        title: "Country",
                        value: controller.selectedCountry,
                        items: controller.countryList,
                      ),

                      _searchDropdownField(
                        title: "State",
                        value: controller.selectedState,
                        items: controller.stateList
                            .map<String>((e) => e['name'])
                            .toList(),
                      ),

                      _searchDropdownField(
                        title: "City",
                        value: controller.selectedCity,
                        items: controller.cityList
                            .map<String>((e) => e['name'])
                            .toList(),
                      ),

                      // AppDropdownSearch<String>(
                      //   title: "State",
                      //   isRequired: false,
                      //   value: controller.selectedState.value,
                      //   items: controller.stateList
                      //       .map<String>((e) => e['name'])
                      //       .toList(),
                      //   hintText: "State",
                      //   showSearchBox: true,
                      //   searchHintText: "",
                      //   onChanged: (val) => controller.selectedState.value = val,
                      //   validator: AppValidators.required,
                      // ),
                      // AppDropdownSearch<String>(
                      //   title: "City",
                      //   isRequired: false,
                      //   value: controller.selectedCity.value,
                      //   items: controller.cityList
                      //       .map<String>((e) => e['name'])
                      //       .toList(),
                      //   hintText: "City",
                      //   showSearchBox: true,
                      //   searchHintText: "",
                      //   onChanged: (val) => controller.selectedCity.value = val,
                      //   validator: AppValidators.required,
                      // ),
                      _dropdownField(
                        isDynamic: true,
                        title: "Income",
                        isPremium: true,
                        value: controller.selectedIncome,
                        items: controller.annualIncomeList,
                      ),

                      _dropdownField(
                        isDynamic: true,
                        title: "Education",
                        isPremium: true,
                        value: controller.selectedEducation,
                        items: controller.educationCategoryList,
                      ),

                      _dropdownField(
                        isDynamic: true,
                        title: "Occupation",
                        isPremium: true,
                        value: controller.selectedJob,
                        items: controller.jobCategoryList,
                      ),

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
    bool isPremium = false,
  }) {
    return Obx(() {
      final isLocked = controller.isFilterLocked(title);

      return GestureDetector(
        onTap: isLocked ? _showPremiumDialog : null,
        child: AbsorbPointer(
          absorbing: isLocked, // Disable if premium locked
          child: Opacity(
            opacity: isLocked ? 0.6 : 1.0,
            child: Stack(
              children: [
                AppDropdownField(
                  isRequired: false,
                  title: title,
                  value: value.value,
                  items: items,
                  hintText: "Select",
                  validator: AppValidators.required,
                  isHeight: isHeight,
                  isDynamic: isDynamic,
                  suffixIcon: isLocked ? _buildPremiumIcon() : null,
                  onChanged: (val) {
                    if (isLocked) {
                      _showPremiumDialog();
                      return;
                    }
                    value.value = val;
                  },
                ),
                if (isLocked)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showPremiumDialog,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPremiumIcon() {
    return GestureDetector(
      onTap: _showPremiumDialog,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: const Icon(Icons.lock, color: AppColors.lightPrimary, size: 22),
      ),
    );
  }

  Widget _searchDropdownField({
    required String title,
    required Rxn<String> value,
    required List<String> items,
  }) {
    return Obx(() {
      final isLocked = controller.isFilterLocked(title);

      return GestureDetector(
        onTap: isLocked ? _showPremiumDialog : null,
        child: AbsorbPointer(
          absorbing: isLocked,
          child: Opacity(
            opacity: isLocked ? 0.6 : 1.0,
            child: Stack(
              children: [
                AppDropdownSearch<String>(
                  title: title,
                  isRequired: false,
                  value: value.value,
                  items: items,
                  hintText: title,
                  showSearchBox: true,
                  searchHintText: "",
                  validator: AppValidators.required,
                  suffixIcon: isLocked ? _buildPremiumIcon() : null,
                  onChanged: (val) {
                    if (isLocked) {
                      _showPremiumDialog();
                      return;
                    }

                    value.value = val;
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showPremiumDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.stars, color: Colors.amber),
            SizedBox(width: 8),
            Text("Premium Feature"),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Upgrade to Premium to unlock this feature and more!"),
            SizedBox(height: 16),
            // Add premium benefits list
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Maybe Later"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to premium subscription page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text("UPGRADE NOW"),
          ),
        ],
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
