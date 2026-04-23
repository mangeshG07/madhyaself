import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class GlobalSearchController extends GetxController {
  final CommonDataUsecase _commonDataUsecase;
  final LocationDataUsecase _locationDataUsecase;
  GlobalSearchController(this._commonDataUsecase, this._locationDataUsecase);

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
      final data = res['data'];

      ageList.assignAll(data['age'] ?? []);
      religionList.assignAll(data['religion'] ?? []);
      heightList.assignAll(data['height'] ?? []);
      casteList.assignAll(data['caste'] ?? []);
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

  final isLoading = false.obs;
  final selectedLookingFor = Rxn<String>();
  final selectedReligion = Rxn<String>();
  final selectedCaste = Rxn<String>();
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

  final lookingList = [
    'Self',
    'Son',
    'Daughter',
    'Brother',
    'Sister',
    'Relative/Friend',
  ].obs;

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
}
