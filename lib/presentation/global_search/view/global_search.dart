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
                      _searchUsername(theme),

                      _buildMultiDropdown(
                        title: 'Religion',
                        selectedItems: controller.selectedReligionList,
                        selectedItemsIds: controller.selectedReligionIdsList,
                        items: controller.religionList,
                        isCaste: true,
                      ),

                      // _dropdownField(
                      //   isDynamic: true,
                      //   title: "Religion",
                      //   value: controller.selectedReligion,
                      //   items: controller.religionList,
                      //   isCaste: true,
                      // ),
                      _buildMultiDropdown(
                        title: 'Caste',
                        selectedItems: controller.selectedCasteList,
                        selectedItemsIds: controller.selectedCasteIdsList,
                        items: controller.casteList,
                      ),

                      // _dropdownField(
                      //   isDynamic: true,
                      //   title: "Caste",
                      //   value: controller.selectedCaste,
                      //   items: controller.casteList,
                      //   isSelectCaste: true,
                      // ),
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

                      _dropdownField(
                        isDynamic: true,
                        title: "Income",
                        value: controller.selectedIncome,
                        items: controller.annualIncomeList,
                      ),

                      _buildMultiDropdown(
                        title: 'Education',
                        selectedItems: controller.selectedEducationList,
                        selectedItemsIds: controller.selectedEducationIdsList,
                        items: controller.educationCategoryList,
                      ),

                      // _dropdownField(
                      //   isDynamic: true,
                      //   title: "Education",
                      //
                      //   value: controller.selectedEducation,
                      //   items: controller.educationCategoryList,
                      // ),
                      // _dropdownField(
                      //   isDynamic: true,
                      //   title: "Occupation",
                      //
                      //   value: controller.selectedJob,
                      //   items: controller.jobCategoryList,
                      // ),
                      _buildMultiDropdown(
                        title: 'Occupation',
                        selectedItems: controller.selectedJobList,
                        selectedItemsIds: controller.selectedJobIdsList,
                        items: controller.jobCategoryList,
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppButton(
              text: controller.isSearching.value ? 'Searching...' : 'Search',
              onTap: controller.isSearching.value
                  ? null
                  : () async => await controller.globalSearch(isRefresh: true),
              backgroundColor: AppColors.lightPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchUsername(ThemeData theme) {
    return AppTextField(
      filled: true,
      label: 'Search by Madhyasthi Id',
      showLabel: true,
      minLines: 1,
      hint: 'Madhyasthi Id',
      contentPadding: const EdgeInsets.all(8),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
      labelStyle: theme.textTheme.labelMedium,
      controller: controller.username,
      fillColor: theme.cardColor,
    );
  }

  Widget _buildToWord() {
    return Padding(
      padding: EdgeInsets.only(top: 16.w),
      child: Center(child: AppText(text: 'To', fontSize: 14)),
    );
  }

  /// ================= COMMON DROPDOWN =================
  Widget _buildMultiDropdown({
    required String title,
    required List selectedItems,
    required List selectedItemsIds,
    required List items,
    bool isCaste = false,
  }) {
    return Obx(() {
      final isLocked = controller.isFilterLocked(title);

      return GestureDetector(
        onTap: isLocked ? AllDialogs().showPremiumDialog : null,
        child: AbsorbPointer(
          absorbing: isLocked,
          child: Opacity(
            opacity: isLocked ? 0.6 : 1.0,
            child: Stack(
              children: [
                AppMultiDropdown(
                  title: title,
                  items: items.map((item) => item['name'].toString()).toList(),
                  selectedItems: List<String>.from(selectedItems),
                  hintText: title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select $title";
                    }
                    return null;
                  },
                  onChanged: (selected) async {
                    print('selected========>$selected');
                    selectedItems.assignAll(selected);

                    final selectedIds = items
                        .where(
                          (item) => selected.contains(item['name'].toString()),
                        )
                        .map((item) => item['id'].toString())
                        .toList();
                    print('selectedIds========>$selectedIds');
                    selectedItemsIds.assignAll(selectedIds);
                    if (isCaste) {
                      await controller.fetchCasteByReligionList(
                        selectedItemsIds,
                      );
                    }

                    print('selectedItemsIds========>$selectedItemsIds');
                  },
                ),
                if (isLocked)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: AllDialogs().showPremiumDialog,
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

  Widget _dropdownField({
    required String title,
    required Rxn<String> value,
    required List items,
    bool isHeight = false,
    bool isDynamic = false,
    bool isCaste = false,
    bool isSelectCaste = false,
  }) {
    return Obx(() {
      final isLocked = controller.isFilterLocked(title);

      return GestureDetector(
        onTap: isLocked ? AllDialogs().showPremiumDialog : null,
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
                  hintText: !isSelectCaste
                      ? "Select"
                      : controller.isCasteLoading.value
                      ? "Loading caste..."
                      : "Select",
                  validator: AppValidators.required,
                  isHeight: isHeight,
                  isDynamic: isDynamic,
                  suffixIcon: isLocked ? _buildPremiumIcon() : null,
                  onChanged: (val) {
                    if (isCaste) {
                      controller.fetchCaste(val.toString());
                    }
                    if (isLocked) {
                      AllDialogs().showPremiumDialog();
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
                        onTap: AllDialogs().showPremiumDialog,
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
      onTap: AllDialogs().showPremiumDialog,
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
        onTap: isLocked ? AllDialogs().showPremiumDialog : null,
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
                      AllDialogs().showPremiumDialog();
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
