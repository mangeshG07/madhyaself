import '../../../core/exporters/app_export.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({super.key});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final controller = Get.find<GlobalSearchController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        height: Get.height * 0.88,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          children: [
            _buildHeader(theme),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                children: [
                  _basicDetails(theme),

                  SizedBox(height: 12.h),

                  _religionDetails(),

                  SizedBox(height: 12.h),

                  _professionalDetails(),

                  SizedBox(height: 12.h),

                  _locationDetails(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),

            _buildBottomButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w, bottom: 8.h),
      child: Column(
        children: [
          Container(
            width: 42.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Search Filters",
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: HugeIcon(icon: HugeIcons.strokeRoundedCancelCircle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: .05),
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: AppButton(
                type: AppButtonType.outline,
                text: "Reset Filters",
                textStyle: theme.textTheme.bodyMedium,
                borderColor: Colors.grey,
                onTap: () async {
                  controller.resetFilters();
                  Navigator.pop(context);
                  await controller.globalSearch(isRefresh: true);
                },
              ),
            ),

            Expanded(
              child: AppButton(
                text: controller.isSearching.value
                    ? "Searching..."
                    : "Apply Filters",
                backgroundColor: AppColors.lightPrimary,
                onTap: controller.isSearching.value
                    ? null
                    : () async {
                        await controller.globalSearch(isRefresh: true);
                        // Get.back();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 12.w),
        childrenPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ).copyWith(bottom: 12.h),
        title: Text(title, style: theme.textTheme.bodyMedium),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        children: children,
      ),
    );
  }

  Widget _basicDetails(ThemeData theme) {
    return _buildSection(
      title: "Basic Details",
      children: [
        AppTextField(
          filled: true,
          label: 'Username',
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

        SizedBox(height: 12.h),

        _dropdownField(
          title: "Age From",
          value: controller.selectedAgeFrom,
          items: controller.ageList.map<String>((e) => e['name']).toList(),
        ),

        SizedBox(height: 12.h),

        _dropdownField(
          title: "Age To",
          value: controller.selectedAgeTo,
          items: controller.ageList.map<String>((e) => e['name']).toList(),
        ),

        SizedBox(height: 12.h),

        _dropdownField(
          title: "Height From",
          value: controller.selectedHeightFrom,
          items: controller.heightList,
          isHeight: true,
          isDynamic: true,
        ),

        SizedBox(height: 12.h),

        _dropdownField(
          title: "Height To",
          value: controller.selectedHeightTo,
          items: controller.heightList,
          isHeight: true,
          isDynamic: true,
        ),
      ],
    );
  }

  Widget _religionDetails() {
    return _buildSection(
      title: "Religion Details",
      children: [
        _dropdownField(
          title: "Religion",
          value: controller.selectedReligion,
          items: controller.religionList,
          isDynamic: true,
        ),

        SizedBox(height: 12.h),

        _dropdownField(
          title: "Caste",
          value: controller.selectedCaste,
          items: controller.casteList,
          isDynamic: true,
        ),
      ],
    );
  }

  Widget _professionalDetails() {
    return _buildSection(
      title: "Professional Details",
      children: [
        _dropdownField(
          title: "Income",
          value: controller.selectedIncome,
          items: controller.annualIncomeList,
          isDynamic: true,
        ),

        SizedBox(height: 12.h),

        _dropdownField(
          title: "Education",
          value: controller.selectedEducation,
          items: controller.educationCategoryList,
          isDynamic: true,
        ),

        SizedBox(height: 12.h),

        _dropdownField(
          title: "Occupation",
          value: controller.selectedJob,
          items: controller.jobCategoryList,
          isDynamic: true,
        ),
      ],
    );
  }

  Widget _locationDetails() {
    return _buildSection(
      title: "Location Details",
      children: [
        _dropdownField(
          title: "Country",
          value: controller.selectedCountry,
          items: controller.countryList,
        ),

        SizedBox(height: 12.h),

        _searchDropdownField(
          title: "State",
          value: controller.selectedState,
          items: controller.stateList.map<String>((e) => e['name']).toList(),
        ),

        _searchDropdownField(
          title: "City",
          value: controller.selectedCity,
          items: controller.cityList.map<String>((e) => e['name']).toList(),
        ),

        // Obx(
        //   () => AppDropdownSearch<String>(
        //     title: "State",
        //     value: controller.selectedState.value,
        //     items: controller.stateList.map<String>((e) => e['name']).toList(),
        //     onChanged: (val) => controller.selectedState.value = val,
        //     hintText: "Select State",
        //     searchHintText: "Search State",
        //   ),
        // ),
        //
        // SizedBox(height: 12.h),
        //
        // Obx(
        //   () => AppDropdownSearch<String>(
        //     title: "City",
        //     value: controller.selectedCity.value,
        //     items: controller.cityList.map<String>((e) => e['name']).toList(),
        //     onChanged: (val) => controller.selectedCity.value = val,
        //     hintText: "Select City",
        //     searchHintText: "Search City",
        //   ),
        // ),
      ],
    );
  }

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
                  hintText: "Select",
                  validator: AppValidators.required,
                  isHeight: isHeight,
                  isDynamic: isDynamic,
                  suffixIcon: isLocked ? _buildPremiumIcon() : null,
                  onChanged: (val) {
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
}
