import 'package:madhya/core/exporters/app_export.dart';

class PreferenceController extends GetxController {
  final GetPartPrefUsecase getPartPrefUsecase;
  final CommonDataUsecase commonDataUsecase;
  final LocationDataUsecase _locationDataUsecase;
  final UpdatePrefsUsecase _updateUsecase;
  final CasteByReligionListUsecase casteUsecase;
  final SubcasteByCasteListUsecase subCasteUsecase;

  PreferenceController(
    this.getPartPrefUsecase,
    this.commonDataUsecase,
    this._locationDataUsecase,
    this._updateUsecase,
    this.casteUsecase,
    this.subCasteUsecase,
  );

  @override
  void onInit() {
    super.onInit();
    fetchCommonData();
    _fetchLocationData();
  }

  /// ================= STATE =================
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isCasteLoading = false.obs;
  final isSubCasteLoading = false.obs;

  final preferenceDetails = {}.obs;

  /// ================= CONTROLLERS =================
  final educationCtrl = TextEditingController();
  final jobCtrl = TextEditingController();

  /// ================= SELECTED VALUES =================
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
  final selectedAgeFrom = Rxn<String>();
  final selectedAgeTo = Rxn<String>();
  final selectedMaritalStatus = Rxn<String>();
  final selectedHeightFrom = Rxn<String>();
  final selectedHeightTo = Rxn<String>();
  final selectedEducation = Rxn<String>();
  final selectedJob = Rxn<String>();
  final selectedIncome = Rxn<String>();
  final selectedCaste = Rxn<String>();
  final selectedReligion = Rxn<String>();
  final selectedSubCaste = Rxn<String>();
  final selectedCountry = Rxn<String>();
  final selectedState = Rxn<String>();
  final selectedCity = Rxn<String>();
  final selectedDiet = Rxn<String>();
  final selectedSmoking = Rxn<String>();
  final selectedDrinking = Rxn<String>();
  final selectedSpecialCase = Rxn<String>();

  /// ================= LISTS =================
  final ageList = [].obs;
  final heightList = [].obs;
  final religionList = [].obs;
  final educationCategoryList = [].obs;
  final jobCategoryList = [].obs;
  final annualIncomeList = [].obs;
  final casteList = [].obs;
  final subCasteList = [].obs;
  final countryList = ['India'].obs;
  final stateList = [].obs;
  final cityList = [].obs;

  final mStatusList = [
    'Never Married',
    'Married',
    'Widowed',
    'Awaiting Divorce',
    'Divorced',
  ].obs;

  final dietOptionsList = [
    {
      'doesnt_matter': "Doesn't Matter",
      'vegetarian': 'Vegetarian',
      'non_vegetarian': "Non Vegetarian",
      'jain': 'Jain',
      'eggetarian': 'Eggetarian',
    },
  ].obs;

  final smokingOptionsList = [
    {
      'doesnt_matter': "Doesn't Matter",
      'yes': 'Yes',
      'no': "No",
      'occasionally': 'Occasionally',
    },
  ].obs;

  final drinkingOptionsList = [
    {
      'doesnt_matter': "Doesn't Matter",
      'yes': 'Yes',
      'no': "No",
      'occasionally': 'Occasionally',
    },
  ].obs;

  final specialCasesList = [
    {
      'doesnt_matter': "Doesn't Matter",
      'none': 'None',
      'physical_birth': "Physically disabled from birth",
      'physical_accident': 'Physically disabled due to accident',
      'mental_birth': 'Mentally disabled from birth',
      'mental_accident': 'Mentally disabled due to accident',
    },
  ].obs;

  /// ================= FORM KEYS =================
  final basicDetailsFormKey = GlobalKey<FormState>();
  final professionalDetailsFormKey = GlobalKey<FormState>();
  final religionDetailsFormKey = GlobalKey<FormState>();
  final locationDetailsFormKey = GlobalKey<FormState>();

  /// ================= SET INITIAL VALUES =================

  void _setInitialValues(Map data) {
    educationCtrl.text = data['education_detail'] ?? '';
    jobCtrl.text = data['job_detail'] ?? '';

    selectedAgeFrom.value = _val(data['patner_age_from']);
    selectedAgeTo.value = _val(data['patner_age_to']);
    selectedHeightFrom.value = _val(data['patner_height_from']);
    selectedHeightTo.value = _val(data['patner_height_to']);
    selectedMaritalStatus.value = _val(data['marital_status']);

    // selectedEducation.value = _val(data['education_category_id']);
    selectedEducationList.value = data['education_category_name'] ?? [];
    selectedJobList.value = data['job_category_name'] ?? [];
    // selectedJob.value = _val(data['job_category_id']);
    selectedIncome.value = _val(data['annual_income']);

    // selectedCaste.value = _val(data['caste_id']);
    selectedCasteList.value = data['caste'] ?? [];
    selectedSubCasteList.value = data['sub_caste'] ?? [];
    selectedReligionList.value = data['religion'] ?? [];

    selectedCountry.value = _val(data['country']);
    selectedState.value = _val(data['state']);
    selectedCity.value = _val(data['city']);
    selectedDiet.value = _val(data['dietary_habits']);
    selectedSmoking.value = _val(data['smoking_habits']);
    selectedDrinking.value = _val(data['drinking_habits']);
    selectedSpecialCase.value = _val(data['special_case']);
    getInitialValues();
  }

  void getInitialValues() async {
    await fetchCaste();
    await fetchSubCaste();
  }

  String? _val(dynamic v) {
    if (v == null) return null;
    final str = v.toString();
    return str.isEmpty ? null : str;
  }

  /// ================= COMMON DATA =================
  Future<void> fetchCommonData() async {
    final res = await commonDataUsecase();
    final data = res['data'];

    ageList.assignAll(data['age'] ?? []);
    religionList.assignAll(data['religion'] ?? []);
    heightList.assignAll(data['height'] ?? []);
    educationCategoryList.assignAll(data['education_category'] ?? []);
    jobCategoryList.assignAll(data['job_category'] ?? []);
    annualIncomeList.assignAll(data['annual_income'] ?? []);
    // casteList.assignAll(data['caste'] ?? []);
    // subCasteList.assignAll(data['sub_caste'] ?? []);
  }

  /// ------------------ CASTE ------------------ ///
  Future<void> fetchCaste() async {
    try {
      isCasteLoading(true);
      casteList.clear();
      subCasteList.clear();
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await casteUsecase.call(
        CasteByReligionRequest(
          userId: userid,
          religionId: List<String>.from(selectedReligionIdsList),
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

  /// ------------------ SUB CASTE ------------------ ///
  Future<void> fetchSubCaste() async {
    try {
      isSubCasteLoading(true);
      // selectedSubCaste.value = null;
      subCasteList.clear();
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await subCasteUsecase.call(
        SubcasteByCasteRequest(
          userId: userid,
          casteIds: List<String>.from(selectedCasteIdsList),
        ),
      );

      if (res['common']['status'] == true) {
        final data = res['data'];

        subCasteList.value = data['sub_caste'] ?? [];
      }
    } catch (_) {
    } finally {
      isSubCasteLoading(false);
    }
  }

  /// ================= Location DATA =================
  Future<void> _fetchLocationData() async {
    final res = await _locationDataUsecase();
    final data = res['data'];

    stateList.assignAll(data['states'] ?? []);
    cityList.assignAll(data['cities'] ?? []);
  }

  /// ================= GET PREFERENCE =================
  Future<void> getPreference() async {
    try {
      isLoading(true);

      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await getPartPrefUsecase.call(UserRequest(userid));

      final common = res['common'];
      final status = common?['status'] == true;

      if (status) {
        final data = res['data'];

        if (data is Map && data['preferance'] is List) {
          final preferences = data['preferance'] as List;

          if (preferences.isNotEmpty && preferences.first is Map) {
            preferenceDetails.value = Map<String, dynamic>.from(
              preferences.first,
            );

            _setInitialValues(preferenceDetails);
          } else {
            preferenceDetails.clear();
          }
        } else {
          preferenceDetails.clear();
        }
      } else {
        // API says preference does not exist
        preferenceDetails.clear();

        // debugPrint('Preference not found: ${common?['message']}');
      }
    } finally {
      isLoading(false);
    }
  }

  /// ================= COMMON UPDATE HANDLER =================
  Future<void> _handleUpdate(PartnerPreferenceRequest request) async {
    try {
      isUpdating(true);

      final res = await _updateUsecase.call(request);

      if (res['common']['status'] == true) {
        Get.back();
        CustomSnackbar.show(
          context: Get.context!,
          message: res['common']['message'],
          type: SnackbarType.success,
        );
        // Get.snackbar('Success', res['common']['message']);
        await getPreference();
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: res['common']['message'],
          type: SnackbarType.error,
        );
        // Get.snackbar('Error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdating(false);
    }
  }

  /// ================= UPDATE BASIC DETAILS=================
  Future<void> updateBasicDetails() async {
    final userId = await SecureStorageService.read('user_id') ?? '';

    await _handleUpdate(
      PartnerPreferenceRequest(
        userId: userId,
        maritalStatus: selectedMaritalStatus.value,
        partnerAgeFrom: selectedAgeFrom.value,
        partnerAgeTo: selectedAgeTo.value,
        partnerHeightFrom: selectedHeightFrom.value,
        partnerHeightTo: selectedHeightTo.value,
      ),
    );
  }

  /// ================= UPDATE PROFESSIONAL DETAILS=================
  Future<void> updateProfessionalDetails() async {
    final userId = await SecureStorageService.read('user_id') ?? '';

    await _handleUpdate(
      PartnerPreferenceRequest(
        userId: userId,
        educationCategoryId: List<String>.from(selectedEducationIdsList),
        educationDetail: educationCtrl.text.trim(),
        jobCategoryId: List<String>.from(selectedJobIdsList),
        jobDetail: jobCtrl.text.trim(),
        annualIncome: selectedIncome.value,
      ),
    );
  }

  /// ================= UPDATE RELIGION DETAILS=================
  Future<void> updateReligionDetails() async {
    final userId = await SecureStorageService.read('user_id') ?? '';

    await _handleUpdate(
      PartnerPreferenceRequest(
        userId: userId,
        casteId: List<String>.from(selectedCasteIdsList),
        subCasteId: List<String>.from(selectedSubCasteIdsList),
        religionId: List<String>.from(selectedReligionIdsList),
      ),
    );
  }

  /// ================= UPDATE LOCATION DETAILS=================
  Future<void> updateLocationDetails() async {
    final userId = await SecureStorageService.read('user_id') ?? '';

    await _handleUpdate(
      PartnerPreferenceRequest(
        userId: userId,
        country: selectedCountry.value,
        state: selectedState.value,
        city: selectedCity.value,
      ),
    );
  }

  /// ================= UPDATE LIFESTYLE DETAILS=================
  Future<void> updateLifestyleDetails() async {
    final userId = await SecureStorageService.read('user_id') ?? '';

    await _handleUpdate(
      PartnerPreferenceRequest(
        userId: userId,
        dietaryHabits: selectedDiet.value,
        drinkingHabits: selectedDrinking.value,
        smokingHabits: selectedSmoking.value,
        specialCase: selectedSpecialCase.value,
      ),
    );
  }
}
