import 'package:madhya/core/exporters/app_export.dart';

class GlobalSearchController extends GetxController
    with PaginationMixin<dynamic> {
  final CommonDataUsecase _commonDataUsecase;
  final LocationDataUsecase _locationDataUsecase;
  final GlobalSearchUsecase _globalSearchUsecase;
  final CasteByRelUsecase _casteUsecase;
  final CasteByReligionListUsecase _casteByReligionListUsecase;
  GlobalSearchController(
    this._commonDataUsecase,
    this._locationDataUsecase,
    this._globalSearchUsecase,
    this._casteUsecase,
    this._casteByReligionListUsecase,
  );

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading(true);

      await Future.wait([fetchCommonData(), fetchLocationData()]);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCommonData() async {
    try {
      final res = await _commonDataUsecase();
      final data = res['data'] ?? {};

      ageList.assignAll(data['age'] ?? []);
      religionList.assignAll(data['religion'] ?? []);
      heightList.assignAll(data['height'] ?? []);
      // casteList.assignAll(data['caste'] ?? []);
      educationCategoryList.assignAll(data['education_category'] ?? []);
      jobCategoryList.assignAll(data['job_category'] ?? []);
      annualIncomeList.assignAll(data['annual_income'] ?? []);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    }
  }

  Future<void> fetchLocationData() async {
    try {
      final res = await _locationDataUsecase();
      final data = res['data'];

      stateList.assignAll(data['states'] ?? []);
      cityList.assignAll(data['cities'] ?? []);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load location');
    }
  }

  /// ------------------ CASTE ------------------ ///
  Future<void> fetchCaste(String religionId) async {
    try {
      isCasteLoading(true);
      selectedCaste.value = null;
      selectedSubCaste.value = null;
      casteList.clear();

      final res = await _casteUsecase.call(CasteRequest(religionId));

      if (res['common']['status'] == true) {
        final data = res['data'];
        casteList.value = data['caste'] ?? [];
      }
    } finally {
      isCasteLoading(false);
    }
  }

  Future<void> fetchCasteByReligionList(List religionId) async {
    try {
      isCasteLoading(true);
      selectedCasteList.clear();
      selectedCasteIdsList.clear();
      casteList.clear();
      final userId = await SecureStorageService.read('user_id') ?? '';
      final res = await _casteByReligionListUsecase.call(
        CasteByReligionRequest(
          userId: userId,
          religionId: List<String>.from(religionId),
        ),
      );

      if (res['common']['status'] == true) {
        final data = res['data'];
        casteList.value = data['caste'] ?? [];
      }
    } finally {
      isCasteLoading(false);
    }
  }

  final isSearching = false.obs;
  final isCasteLoading = false.obs;
  final username = TextEditingController();

  final selectedEducationList = [].obs;
  final selectedEducationIdsList = [].obs;
  final selectedJobList = [].obs;
  final selectedJobIdsList = [].obs;
  final selectedReligionList = [].obs;
  final selectedReligionIdsList = [].obs;
  final selectedCasteList = [].obs;
  final selectedCasteIdsList = [].obs;
  final selectedSubCasteList = [].obs;
  final selectedSubCasteIdsList = [].obs;

  final selectedReligion = Rxn<String>();
  final selectedCaste = Rxn<String>();
  final selectedSubCaste = Rxn<String>();
  final selectedHeightFrom = Rxn<String>();
  final selectedHeightTo = Rxn<String>();
  final selectedAgeFrom = Rxn<String>();
  final selectedAgeTo = Rxn<String>();
  final selectedIncome = Rxn<String>();
  final selectedEducation = Rxn<String>();
  final selectedJob = Rxn<String>();
  final selectedCountry = Rxn<String>();
  final selectedState = Rxn<String>();
  final selectedCity = Rxn<String>();

  final religionList = [].obs;
  final casteList = [].obs;
  final heightList = [].obs;
  final ageList = [].obs;
  final educationCategoryList = [].obs;
  final jobCategoryList = [].obs;
  final annualIncomeList = [].obs;
  final countryList = ['India'].obs;
  final stateList = [].obs;
  final cityList = [].obs;
  // final searchList = [].obs;

  /// ================= COMMON UPDATE HANDLER =================

  Future<void> globalSearch({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userId = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _globalSearchUsecase.call(
        SearchRequest(
          userId: userId,
          partnerAgeFrom: selectedAgeFrom.value,
          partnerAgeTo: selectedAgeTo.value,
          partnerHeightFrom: selectedHeightFrom.value,
          partnerHeightTo: selectedHeightTo.value,
          casteId: List<String>.from(selectedCasteIdsList),
          jobCategoryId: List<String>.from(selectedJobIdsList),
          annualIncome: selectedIncome.value,
          city: selectedCity.value,
          country: selectedCountry.value,
          educationCategoryId: List<String>.from(selectedEducationIdsList),
          religionId: List<String>.from(selectedReligionIdsList),
          state: selectedState.value,
          userName: username.text.trim(),
          subcaste: selectedSubCaste.value,
          pageNo: currentPage.toString(),
        ),
      );
      if (response['common']['status'] == true) {
        final List list = response['data']['matches'] ?? [];

        handleSuccess(list);
        Get.toNamed(
          Routes.searchResult,
          arguments: {
            'hasBasicFilter': Get.find<HomeController>().hasBasicFilter,
            'hasAdvancedFilter': Get.find<HomeController>().hasAdvancedFilter,
          },
        );
      } else {
        handleSuccess([]);
        Get.toNamed(
          Routes.searchResult,
          arguments: {
            'hasBasicFilter': Get.find<HomeController>().hasBasicFilter,
            'hasAdvancedFilter': Get.find<HomeController>().hasAdvancedFilter,
          },
        );
      }
    } catch (_) {
      // debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }

  // Future<void> globalSearch() async {
  //   final userId = await SecureStorageService.read('user_id') ?? '';
  //   searchList.clear();
  //   try {
  //     isSearching(true);
  //
  //     final res = await _globalSearchUsecase.call(
  //       SearchRequest(
  //         userId: userId,
  //         partnerAgeFrom: selectedAgeFrom.value,
  //         partnerAgeTo: selectedAgeTo.value,
  //         partnerHeightFrom: selectedHeightFrom.value,
  //         partnerHeightTo: selectedHeightTo.value,
  //         casteId: selectedCaste.value,
  //         jobCategoryId: selectedJob.value,
  //         annualIncome: selectedIncome.value,
  //         city: selectedCity.value,
  //         country: selectedCountry.value,
  //         educationCategoryId: selectedEducation.value,
  //         religionId: selectedReligion.value,
  //         state: selectedState.value,
  //         userName: username.text.trim(),
  //         subcaste: selectedSubCaste.value,
  //       ),
  //     );
  //
  //     if (res['common']['status'] == true) {
  //       Get.back();
  //       searchList.value = res['data']['matches'] ?? [];
  //
  //       Get.toNamed(
  //         Routes.searchResult,
  //         arguments: {
  //           'hasBasicFilter': Get.find<HomeController>().hasBasicFilter,
  //           'hasAdvancedFilter': Get.find<HomeController>().hasAdvancedFilter,
  //         },
  //       );
  //     } else {
  //       Get.snackbar('Error', res['common']['message']);
  //     }
  //   } finally {
  //     isSearching(false);
  //   }
  // }

  void resetFilters() {
    username.clear();

    selectedReligion.value = null;
    selectedCaste.value = null;
    selectedSubCaste.value = null;

    selectedHeightFrom.value = null;
    selectedHeightTo.value = null;

    selectedAgeFrom.value = null;
    selectedAgeTo.value = null;

    selectedIncome.value = null;
    selectedEducation.value = null;
    selectedJob.value = null;

    selectedCountry.value = null;
    selectedState.value = null;
    selectedCity.value = null;
    selectedEducationList.clear();
    selectedEducationIdsList.clear();
    selectedJobList.clear();
    selectedJobIdsList.clear();
    selectedReligionList.clear();
    selectedReligionIdsList.clear();
    selectedCasteList.clear();
    selectedCasteIdsList.clear();
    selectedSubCasteList.clear();
    selectedSubCasteIdsList.clear();
    casteList.clear();
    // searchList.clear();
  }

  bool get hasAdvancedFilter =>
      Get.find<HomeController>().hasAdvancedFilter.value == true;

  bool get hasBasicFilter =>
      Get.find<HomeController>().hasBasicFilter.value == true;

  /// Decide if filter should be locked
  bool isFilterLocked(String fieldName) {
    // Advanced plan → unlock everything
    if (hasAdvancedFilter) {
      return false;
    }

    // No plan → lock everything
    if (!hasAdvancedFilter && !hasBasicFilter) {
      return true;
    }

    // Basic plan → lock only premium fields
    if (hasBasicFilter) {
      const premiumFields = ["Income", "Education", "Occupation"];

      return premiumFields.contains(fieldName);
    }

    return false;
  }
}
