import 'package:madhya/core/exporters/app_export.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final controller = Get.find<GlobalSearchController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        title: 'Search Result',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppText(
              text: '${controller.searchList.length} search results found!',
              fontSize: 14.sp,
            ),
          ),
          Expanded(child: _buildTopMatchList()),
        ],
      ),
    );
  }

  Widget _buildTopMatchList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: AppLoader.circular(color: AppColors.lightPrimary));
      }

      if (controller.searchList.isEmpty) {
        return _emptyState();
      }

      return GridView.builder(
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: controller.searchList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 4,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, index) {
          final match = controller.searchList[index];

          return CompactCard(
            details: {
              'name': match['name'] ?? '',
              'id': match['id'] ?? '',
              'age': getAgeJob(match),
              'address': getAddress(match),
              'image': match['profile_image']?.toString() ?? '',
              'isVerified': match['verified'] ?? false,
              'isPremium': match['isPremium'] ?? false,
            },
            onTap: () => Get.toNamed(
              Routes.othersProfile,
              arguments: {'id': match['id']?.toString() ?? ''},
            ),
          );
        },
      );
    });
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 50.r, color: Colors.grey),
          SizedBox(height: 10.h),
          AppText(
            text: 'No Matches yet',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: 'Start exploring and Matches profiles',
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          height: Get.height * 0.85,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    _basicDetails(),
                    _religionDetails(),
                    _professionalDetails(),
                    _locationDetails(),
                  ],
                ),
              ),

              Obx(
                () => AppButton(
                  text: controller.isSearching.value
                      ? 'Searching...'
                      : 'Apply Filters',
                  backgroundColor: AppColors.lightPrimary,
                  onTap: controller.isSearching.value
                      ? null
                      : () async {
                          await controller.globalSearch();
                          Get.back();
                        },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _basicDetails() {
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      title: const Text("Basic Details"),
      childrenPadding: EdgeInsets.all(12),
      children: [
        AppTextField(label: 'Username', controller: controller.username),

        _dropdownField(
          title: "Age From",
          value: controller.selectedAgeFrom,
          items: controller.ageList.map<String>((e) => e['name']).toList(),
        ),

        _dropdownField(
          title: "Age To",
          value: controller.selectedAgeTo,
          items: controller.ageList.map<String>((e) => e['name']).toList(),
        ),

        _dropdownField(
          title: "Height From",
          value: controller.selectedHeightFrom,
          items: controller.heightList,
          isHeight: true,
          isDynamic: true,
        ),

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
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      childrenPadding: EdgeInsets.all(12),
      title: const Text("Religion Details"),
      children: [
        _dropdownField(
          title: "Religion",
          value: controller.selectedReligion,
          items: controller.religionList,
          isDynamic: true,
        ),

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
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      childrenPadding: EdgeInsets.all(12),
      title: const Text("Professional Details"),
      children: [
        _dropdownField(
          title: "Income",
          value: controller.selectedIncome,
          items: controller.annualIncomeList,
          isDynamic: true,
        ),

        _dropdownField(
          title: "Education",
          value: controller.selectedEducation,
          items: controller.educationCategoryList,
          isDynamic: true,
        ),

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
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      childrenPadding: EdgeInsets.all(12),
      title: const Text("Location Details"),
      children: [
        _dropdownField(
          title: "Country",
          value: controller.selectedCountry,
          items: controller.countryList,
        ),

        AppDropdownSearch<String>(
          title: "State",
          value: controller.selectedState.value,
          items: controller.stateList.map<String>((e) => e['name']).toList(),
          onChanged: (val) => controller.selectedState.value = val,
          hintText: '',
          searchHintText: '',
        ),

        AppDropdownSearch<String>(
          title: "City",
          value: controller.selectedCity.value,
          items: controller.cityList.map<String>((e) => e['name']).toList(),
          onChanged: (val) => controller.selectedCity.value = val,
          hintText: '',
          searchHintText: '',
        ),
      ],
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
}
