import 'package:madhya/core/exporters/app_export.dart';
import 'package:madhya/domain/usecase/get_page_details_usecase.dart';
import 'package:madhya/domain/usecase/get_page_usecase.dart';

@lazySingleton
class ProfileController extends GetxController {
  final ProfileUsecase usecase;
  final CommonDataUsecase commonDataUsecase;
  final LocationDataUsecase _locationDataUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final GetPageDetailsUsecase _getPageDetailsUsecase;
  final GetPageUsecase _getPageUsecase;

  ProfileController(
    this.usecase,
    this.commonDataUsecase,
    this._updateProfileUsecase,
    this._locationDataUsecase,
    this._getPageDetailsUsecase,
    this._getPageUsecase,
  );

  @override
  void onInit() {
    super.onInit();
    getProfile();
    fetchCommonData();
    _fetchLocationData();
  }

  /// UI State
  final isLoading = false.obs;
  final isUpdateLoading = false.obs;
  final isPageLoading = false.obs;
  final isPageDetailsLoading = false.obs;
  final isHide = false.obs;

  /// Form Controllers
  final whatsappNoController = TextEditingController();
  final alternateNoController = TextEditingController();
  final aboutMeController = TextEditingController();
  final educationDetailsController = TextEditingController();
  final jobDetailsController = TextEditingController();
  final fatherNameController = TextEditingController();
  final fatherJobController = TextEditingController();
  final motherNameController = TextEditingController();
  final motherJobController = TextEditingController();
  final siblingController = TextEditingController();
  final birthTimeController = TextEditingController();
  final birthDateController = TextEditingController();

  final selectedAge = Rxn<String>();
  final selectedMStatus = Rxn<String>();
  final selectedHeight = Rxn<String>();
  final selectedCreatedFor = Rxn<String>();
  final selectedEducationCategory = Rxn<String>();
  final selectedJobCategory = Rxn<String>();
  final selectedAnnualIncome = Rxn<String>();
  final selectedCaste = Rxn<String>();
  final selectedSubCaste = Rxn<String>();
  final selectedCountry = Rxn<String>();
  final selectedState = Rxn<String>();
  final selectedCity = Rxn<String>();
  final selectedRashi = Rxn<String>();
  final selectedDeleteReason = Rxn<String>();

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
  final rashiList = [].obs;
  final removedFiles = [].obs;
  final pagesList = [].obs;
  final pagesDetails = {}.obs;
  final mStatusList = [
    'Never Married',
    'Married',
    'Widowed',
    'Awaiting Divorce',
    'Divorced',
  ].obs;
  final createdForList = [
    'Self',
    'Son',
    'Daughter',
    'Brother',
    'Sister',
    'Relative/Friend',
  ].obs;

  final deleteReasons = [
    'Marriage fixed',
    'Not getting enough matches',
    'Prepare to search later',
    'Marriage fixed outside',
    'Marriage fixed by Madhyasthi Matrimony',
    'Not interested in looking for proposals through Madhyasthi Matrimony',
    'Service not satisfactory',
    'Fake profile',
    'Customer deceased',
  ].obs;

  final profileDetails = {}.obs;

  final basicDetailsFormKey = GlobalKey<FormState>();
  final aboutMeDetailsFormKey = GlobalKey<FormState>();
  final professionalDetailsFormKey = GlobalKey<FormState>();
  final religionDetailsFormKey = GlobalKey<FormState>();
  final locationDetailsFormKey = GlobalKey<FormState>();
  final familyDetailsFormKey = GlobalKey<FormState>();
  final horoscopeDetailsFormKey = GlobalKey<FormState>();

  final profileImage = Rx<File?>(null);
  final horoscopeFile = Rx<File?>(null);

  final menuList = [
    {
      'title': 'Profile',
      'icon': HugeIcons.strokeRoundedUserCircle,
      'onTap': () => Get.toNamed(Routes.editProfile),
    },
    {
      'title': 'Partner Preference',
      'icon': HugeIcons.strokeRoundedUserLove02,
      'onTap': () => Get.toNamed(Routes.partnerPreference),
    },
    {
      'title': 'Manage Photos',
      'icon': HugeIcons.strokeRoundedAlbum02,
      'onTap': () => Get.toNamed(Routes.managePhotos),
    },
    {
      'title': 'Interests',
      'icon': HugeIcons.strokeRoundedHeartCheck,
      'onTap': () => Get.toNamed(Routes.interest),
    },
    {
      'title': 'Viewed',
      'icon': HugeIcons.strokeRoundedEye,
      'onTap': () => Get.toNamed(Routes.viewed),
    },
    {
      'title': 'Shortlist',
      'icon': HugeIcons.strokeRoundedStar,
      'onTap': () => Get.toNamed(Routes.shortList),
    },
    {
      'title': 'Packages',
      'icon': HugeIcons.strokeRoundedCrown,
      'onTap': () => Get.toNamed(Routes.packageScreen),
    },
    {
      'title': 'Blocked User',
      'icon': HugeIcons.strokeRoundedUserBlock02,
      'onTap': () => Get.toNamed(Routes.blockedUserList),
    },
    {
      'title': 'Reported Profile',
      'icon': HugeIcons.strokeRoundedComplaint,
      'onTap': () => Get.toNamed(Routes.reportedUserList),
    },
    {
      'title': 'Help and support',
      'icon': HugeIcons.strokeRoundedMailOpen,
      'onTap': () => Get.toNamed(Routes.helpAndSupport),
    },
    {
      'title': 'Logout',
      'icon': HugeIcons.strokeRoundedLogout01,
      'onTap': () async {
        await SecureStorageService.clear();
        Get.offAllNamed(Routes.login);
      },
    },
  ].obs;

  final selectedType = 0.obs;

  final profileImages = <dynamic>[].obs;
  final documentList = <dynamic>[].obs;

  /// ================= SET INITIAL DETAILS=================
  void _setInitialValues() {
    whatsappNoController.text = profileDetails['wp_no'] ?? '';
    alternateNoController.text = profileDetails['alternate_no'] ?? '';
    aboutMeController.text = profileDetails['about'] ?? '';
    educationDetailsController.text = profileDetails['education_details'] ?? '';
    jobDetailsController.text = profileDetails['job_details'] ?? '';
    fatherNameController.text = profileDetails['father_name'] ?? '';
    fatherJobController.text = profileDetails['father_job'] ?? '';
    motherNameController.text = profileDetails['mothers_name'] ?? '';
    motherJobController.text = profileDetails['mothers_job'] ?? '';
    siblingController.text = profileDetails['siblling_details'] ?? '';
    birthTimeController.text = profileDetails['birthtime'] ?? '';
    birthDateController.text = profileDetails['birth_date'] ?? '';
    selectedAge.value = profileDetails['age'] ?? '';
    profileImages.assignAll(profileDetails['photos']);
    documentList.assignAll(profileDetails['docs']);
    final rashi = profileDetails['rasi'] ?? '';
    final age = profileDetails['age'] ?? '';
    final height = profileDetails['height'] ?? '';
    final mStatus = profileDetails['marital_status'] ?? '';
    final createdFor = profileDetails['profile_created_for'] ?? '';
    final eduCategory =
        profileDetails['education_category_id']?.toString() ?? '';
    final jobCategory = profileDetails['job_category_id']?.toString() ?? '';
    final annualIncome = profileDetails['annual_income'] ?? '';
    final caste = profileDetails['caste_id']?.toString() ?? '';
    final subCaste = profileDetails['sub_caste_id']?.toString() ?? '';
    final country = profileDetails['country']?.toString() ?? '';
    final state = profileDetails['state']?.toString() ?? '';
    final city = profileDetails['city']?.toString() ?? '';

    selectedRashi.value = (rashi != null && rashi.isNotEmpty) ? rashi : null;
    selectedAge.value = (age != null && age.isNotEmpty) ? age : null;
    selectedCountry.value = (country.isNotEmpty) ? country : null;
    selectedState.value = (state.isNotEmpty) ? state : null;
    selectedCity.value = (city.isNotEmpty) ? city : null;

    selectedMStatus.value = (mStatus != null && mStatus.isNotEmpty)
        ? mStatus
        : null;

    selectedCreatedFor.value = (createdFor != null && createdFor.isNotEmpty)
        ? createdFor
        : null;

    selectedHeight.value = (height != null && height.isNotEmpty)
        ? height
        : null;

    selectedEducationCategory.value = (eduCategory.isNotEmpty)
        ? eduCategory
        : null;

    selectedJobCategory.value = (jobCategory.isNotEmpty) ? jobCategory : null;

    selectedAnnualIncome.value =
        (annualIncome != null && annualIncome.isNotEmpty) ? annualIncome : null;

    selectedCaste.value = (caste.isNotEmpty) ? caste : null;

    selectedSubCaste.value = (subCaste.isNotEmpty) ? subCaste : null;
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
    rashiList.assignAll(data['rasi'] ?? []);
  }

  /// ================= COMMON DATA =================
  Future<void> _fetchLocationData() async {
    final res = await _locationDataUsecase();
    final data = res['data'];
    stateList.assignAll(data['states'] ?? []);
    cityList.assignAll(data['cities'] ?? []);
  }

  /// ================= PROFILE =================
  Future<void> getProfile() async {
    try {
      final userid = await SecureStorageService.read('user_id') ?? '';
      isLoading(true);

      final res = await usecase.call(UserRequest(userid));

      if (res['common']['status'] == true) {
        final data = res['data'] ?? {};
        profileDetails.value = data['user_data'][0] ?? {};
        _setInitialValues();
      }
    } finally {
      isLoading(false);
    }
  }

  /// ================= UPDATE BASIC DETAILS=================
  Future<void> updateBasicDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          wpNumber: whatsappNoController.text,
          alternateNumber: alternateNoController.text,
          age: selectedAge.value,
          maritalStatus: selectedMStatus.value,
          height: selectedHeight.value,
          profileCreatedFor: selectedCreatedFor.value,
        ),
      );

      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE ABOUT ME DETAILS=================
  Future<void> updateAboutMeDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          aboutMe: aboutMeController.text.trim(),
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE PROFESSIONAL DETAILS=================
  Future<void> updateProfessionalDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          educationCategoryId: selectedEducationCategory.value,
          educationDetail: educationDetailsController.text.trim(),
          jobCategoryId: selectedJobCategory.value,
          jobDetail: jobDetailsController.text.trim(),
          annualIncome: selectedAnnualIncome.value,
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE RELIGION DETAILS=================
  Future<void> updateReligionDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          casteId: selectedCaste.value,
          subCasteId: selectedSubCaste.value,
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE LOCATION DETAILS=================
  Future<void> updateLocationDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          country: selectedCountry.value,
          state: selectedState.value,
          city: selectedCity.value,
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE FAMILY DETAILS=================
  Future<void> updateFamilyDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          fatherName: fatherNameController.text.trim(),
          fatherJob: fatherJobController.text.trim(),
          motherName: motherNameController.text.trim(),
          motherJob: motherJobController.text.trim(),
          sibllingDetails: siblingController.text.trim(),
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE HOROSCOPE DETAILS=================
  Future<void> updateHoroscopeDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      print('selectedRashi.value===>${selectedRashi.value}');
      print('birthDateController.value===>${birthDateController.text.trim()}');
      print(
        'birthTimeController.text.trim()===>${birthTimeController.text.trim()}',
      );

      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          birthtime: birthTimeController.text.trim(),
          birthdate: birthDateController.text.trim(),
          rasi: selectedRashi.value,
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE PHOTOS DETAILS=================
  Future<void> updatePhotosDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final fileImages = profileImages.whereType<File>().toList();
      final photos = await prepareDocuments(fileImages);
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          profilePicture: profileImage.value,
          photos: photos,
          removeFile: removedFiles,
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);
        profileImage.value = null;
        profileImages.clear();
        removedFiles.clear();
        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= UPDATE DOCUMENTS DETAILS=================
  Future<void> updateDocumentsDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final fileDocs = documentList.whereType<File>().toList();
      final documents = await prepareDocuments(fileDocs);

      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(userId: userid, documents: documents),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        getProfile();
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= GET PAGES =================
  Future<void> getPages() async {
    try {
      isPageLoading(true);

      final res = await _getPageUsecase();
      if (res['common']['status'] == true) {
        pagesList.value = res['data']['pages'] ?? [];
      }
    } finally {
      isPageLoading(false);
    }
  }

  /// ================= GET PAGES DETAILS =================
  Future<void> getPagesDetails(String slug) async {
    try {
      isPageDetailsLoading(true);

      final res = await _getPageDetailsUsecase.call(UserRequest(slug));
      if (res['common']['status'] == true) {
        pagesDetails.value = res['data'] ?? {};
      }
    } finally {
      isPageDetailsLoading(false);
    }
  }
}
