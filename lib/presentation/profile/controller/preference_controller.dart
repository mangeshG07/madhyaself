import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class PreferenceController extends GetxController {
  final GetPartPrefUsecase getPartPrefUsecase;
  final CommonDataUsecase commonDataUsecase;
  final LocationDataUsecase _locationDataUsecase;
  final UpdatePrefsUsecase _updateUsecase;

  PreferenceController(
    this.getPartPrefUsecase,
    this.commonDataUsecase,
    this._locationDataUsecase,
    this._updateUsecase,
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

  final preferenceDetails = {}.obs;

  /// ================= CONTROLLERS =================
  final educationCtrl = TextEditingController();
  final jobCtrl = TextEditingController();

  /// ================= SELECTED VALUES =================
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

  /// ================= FORM KEYS =================
  final basicDetailsFormKey = GlobalKey<FormState>();
  final professionalDetailsFormKey = GlobalKey<FormState>();
  final religionDetailsFormKey = GlobalKey<FormState>();
  final locationDetailsFormKey = GlobalKey<FormState>();

  /// ================= SET INITIAL VALUES =================
  ///
  void _setInitialValues(Map data) {
    educationCtrl.text = data['education_details'] ?? '';
    jobCtrl.text = data['job_details'] ?? '';

    selectedAgeFrom.value = _val(data['patner_age_from']);
    selectedAgeTo.value = _val(data['patner_age_to']);
    selectedHeightFrom.value = _val(data['patner_height_from']);
    selectedHeightTo.value = _val(data['patner_height_to']);
    selectedMaritalStatus.value = _val(data['marital_status']);

    selectedEducation.value = _val(data['education_category_id']);
    selectedJob.value = _val(data['job_category_id']);
    selectedIncome.value = _val(data['annual_income']);

    selectedCaste.value = _val(data['caste_id']);
    selectedSubCaste.value = _val(data['sub_caste_id']);
    selectedReligion.value = _val(data['religion_id']);

    selectedCountry.value = _val(data['country']);
    selectedState.value = _val(data['state']);
    selectedCity.value = _val(data['city']);
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
    casteList.assignAll(data['caste'] ?? []);
    subCasteList.assignAll(data['sub_caste'] ?? []);
  }

  /// ================= COMMON DATA =================
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

      if (res['common']['status'] == true) {
        final data = res['data'] ?? {};
        preferenceDetails.value = data['preferance'][0] ?? {};
        _setInitialValues(preferenceDetails);
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
        Get.snackbar('Success', res['common']['message']);
        await getPreference();
      } else {
        Get.snackbar('Error', res['common']['message']);
      }
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
        educationCategoryId: selectedEducation.value,
        educationDetail: educationCtrl.text.trim(),
        jobCategoryId: selectedJob.value,
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
        casteId: selectedCaste.value,
        subCasteId: selectedSubCaste.value,
        religionId: selectedReligion.value,
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
}
