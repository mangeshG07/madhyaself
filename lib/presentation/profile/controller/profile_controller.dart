import 'package:madhya/core/exporters/app_export.dart';

class ProfileController extends GetxController {
  final ProfileUsecase usecase;
  final CommonDataUsecase commonDataUsecase;
  final LocationDataUsecase _locationDataUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final GetPageDetailsUsecase _getPageDetailsUsecase;
  final GetPageUsecase _getPageUsecase;
  final SubCasteByCasteUsecase _subCasteUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;

  ProfileController(
    this.usecase,
    this.commonDataUsecase,
    this._updateProfileUsecase,
    this._locationDataUsecase,
    this._getPageDetailsUsecase,
    this._getPageUsecase,
    this._subCasteUsecase,
    this._deleteAccountUsecase,
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
  final isDeleteLoading = false.obs;
  final isPageLoading = false.obs;
  final isPageDetailsLoading = false.obs;
  final isHide = false.obs;
  final isSubCasteLoading = false.obs;

  /// Form Controllers
  final whatsappNoController = TextEditingController();
  final alternateNoController = TextEditingController();
  final addressController = TextEditingController();
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
  final removedDocuments = [].obs;
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
  final planDetails = {}.obs;

  final basicDetailsFormKey = GlobalKey<FormState>();
  final aboutMeDetailsFormKey = GlobalKey<FormState>();
  final professionalDetailsFormKey = GlobalKey<FormState>();
  final religionDetailsFormKey = GlobalKey<FormState>();
  final locationDetailsFormKey = GlobalKey<FormState>();
  final familyDetailsFormKey = GlobalKey<FormState>();
  final horoscopeDetailsFormKey = GlobalKey<FormState>();

  final profileImage = Rx<File?>(null);
  final horoscopeFile = Rx<File?>(null);

  // late final menuList = [
  //   {
  //     'title': 'Profile',
  //     'icon': HugeIcons.strokeRoundedUserCircle,
  //     'onTap': () => Get.toNamed(Routes.editProfile),
  //   },
  //   {
  //     'title': 'Partner Preference',
  //     'icon': HugeIcons.strokeRoundedUserLove02,
  //     'onTap': () => Get.toNamed(Routes.partnerPreference),
  //   },
  //   {
  //     'title': 'Manage Photos',
  //     'icon': HugeIcons.strokeRoundedAlbum02,
  //     'onTap': () => Get.toNamed(Routes.managePhotos),
  //   },
  //   {
  //     'title': 'Interests',
  //     'icon': HugeIcons.strokeRoundedHeartCheck,
  //     'onTap': () => Get.toNamed(Routes.interest),
  //   },
  //   {
  //     'title': 'Viewed',
  //     'icon': HugeIcons.strokeRoundedEye,
  //     'onTap': () => Get.toNamed(Routes.viewed),
  //   },
  //   {
  //     'title': 'Shortlist',
  //     'icon': HugeIcons.strokeRoundedStar,
  //     'onTap': () => Get.toNamed(Routes.shortList),
  //   },
  //
  //   if (profileDetails['hide_plans'] == false)
  //     {
  //       'title': 'Packages',
  //       'icon': HugeIcons.strokeRoundedCrown,
  //       'onTap': () => Get.toNamed(Routes.packageScreen),
  //     },
  //   {
  //     'title': 'Blocked User',
  //     'icon': HugeIcons.strokeRoundedUserBlock02,
  //     'onTap': () => Get.toNamed(Routes.blockedUserList),
  //   },
  //   {
  //     'title': 'Reported Profile',
  //     'icon': HugeIcons.strokeRoundedComplaint,
  //     'onTap': () => Get.toNamed(Routes.reportedUserList),
  //   },
  //   {
  //     'title': 'Help and support',
  //     'icon': HugeIcons.strokeRoundedMailOpen,
  //     'onTap': () => Get.toNamed(Routes.helpAndSupport),
  //   },
  //   {
  //     'title': 'Logout',
  //     'icon': HugeIcons.strokeRoundedLogout01,
  //     'onTap': () async {
  //       AllDialogs().showConfirmationDialog(
  //         'Logout',
  //         'Are you sure you want to logout?',
  //         onConfirm: () async {
  //           // perform logout
  //           Get.back();
  //           await LocalStorage.clear();
  //           Get.snackbar('Logout', 'You have logged out successfully');
  //           await SecureStorageService.clear();
  //           Get.offAllNamed(Routes.login);
  //         },
  //       );
  //     },
  //   },
  // ].obs;

  List<Map<String, dynamic>> get menuList => [
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

    // Dynamic condition
    if (profileDetails['hide_plans'] == false)
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
        AllDialogs().showConfirmationDialog(
          'Logout',
          'Are you sure you want to logout?',
          onConfirm: () async {
            Get.back();
            await LocalStorage.clear();
            await SecureStorageService.clear();

            Get.snackbar('Logout', 'You have logged out successfully');

            Get.offAllNamed(Routes.login);
          },
        );
      },
    },
  ];

  final selectedType = 0.obs;

  final profileImages = <dynamic>[].obs;
  final documentList = <dynamic>[].obs;

  /// ================= SET INITIAL DETAILS=================
  void _setInitialValues() async {
    isHide.value = profileDetails['hide_photos'] == '0' ? false : true;
    whatsappNoController.text = profileDetails['wp_no'] ?? '';
    addressController.text = profileDetails['address'] ?? '';
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
    await fetchSubCaste(selectedCaste.value.toString());
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
    // subCasteList.assignAll(data['sub_caste'] ?? []);
    rashiList.assignAll(data['rasi'] ?? []);
  }

  /// ------------------ SUB CASTE ------------------ ///
  Future<void> fetchSubCaste(String casteId) async {
    try {
      isSubCasteLoading(true);
      // selectedSubCaste.value = null;
      // subCasteList.clear();
      final res = await _subCasteUsecase.call(SubCasteRequest(casteId));

      if (res['common']['status'] == true) {
        final data = res['data'];

        subCasteList.value = data['sub_caste'] ?? [];
      }
    } catch (_) {
    } finally {
      isSubCasteLoading(false);
    }
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
        final planInfo = data['plan_info'];

        planDetails.value = (planInfo is List && planInfo.isNotEmpty)
            ? planInfo.first
            : {};
        _setInitialValues();
      }
    } finally {
      isLoading(false);
    }
  }

  /// ================= UPDATE BASIC DETAILS=================
  Future<void> updateBasicDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';

    await _performProfileUpdate(
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

    // try {
    //   isUpdateLoading(true);
    //   final userid = await SecureStorageService.read('user_id') ?? '';
    //   final res = await _updateProfileUsecase.call(
    //     UpdateUserProfileRequest(
    //       userId: userid,
    //       wpNumber: whatsappNoController.text,
    //       alternateNumber: alternateNoController.text,
    //       age: selectedAge.value,
    //       maritalStatus: selectedMStatus.value,
    //       height: selectedHeight.value,
    //       profileCreatedFor: selectedCreatedFor.value,
    //     ),
    //   );
    //
    //   if (res['common']['status'] == true) {
    //     Get.back();
    //     CustomSnackbar.show(
    //       context: Get.context!,
    //       message: res['common']['message'],
    //       type: SnackbarType.success,
    //     );
    //
    //     // Get.snackbar('Success', res['common']['message']);
    //
    //     getProfile();
    //   } else {
    //     CustomSnackbar.show(
    //       context: Get.context!,
    //       message: res['common']['message'],
    //       type: SnackbarType.error,
    //     );
    //     // Get.snackbar('error', res['common']['message']);
    //   }
    // } catch (_) {
    // } finally {
    //   isUpdateLoading(false);
    // }
  }

  /// ================= UPDATE ABOUT ME DETAILS=================
  Future<void> updateAboutMeDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';

    await _performProfileUpdate(
      UpdateUserProfileRequest(
        userId: userid,
        aboutMe: aboutMeController.text.trim(),
      ),
    );

    // try {
    //   isUpdateLoading(true);
    //   final userid = await SecureStorageService.read('user_id') ?? '';
    //   final res = await _updateProfileUsecase.call(
    //     UpdateUserProfileRequest(
    //       userId: userid,
    //       aboutMe: aboutMeController.text.trim(),
    //     ),
    //   );
    //   if (res['common']['status'] == true) {
    //     Get.back();
    //     Get.snackbar('Success', res['common']['message']);
    //
    //     getProfile();
    //   } else {
    //     Get.snackbar('error', res['common']['message']);
    //   }
    // } catch (_) {
    // } finally {
    //   isUpdateLoading(false);
    // }
  }

  /// ================= UPDATE PROFESSIONAL DETAILS=================
  Future<void> updateProfessionalDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';

    await _performProfileUpdate(
      UpdateUserProfileRequest(
        userId: userid,
        educationCategoryId: selectedEducationCategory.value,
        educationDetail: educationDetailsController.text.trim(),
        jobCategoryId: selectedJobCategory.value,
        jobDetail: jobDetailsController.text.trim(),
        annualIncome: selectedAnnualIncome.value,
      ),
    );

    // try {
    //   isUpdateLoading(true);
    //   final userid = await SecureStorageService.read('user_id') ?? '';
    //   final res = await _updateProfileUsecase.call(
    //     UpdateUserProfileRequest(
    //       userId: userid,
    //       educationCategoryId: selectedEducationCategory.value,
    //       educationDetail: educationDetailsController.text.trim(),
    //       jobCategoryId: selectedJobCategory.value,
    //       jobDetail: jobDetailsController.text.trim(),
    //       annualIncome: selectedAnnualIncome.value,
    //     ),
    //   );
    //   if (res['common']['status'] == true) {
    //     Get.back();
    //     Get.snackbar('Success', res['common']['message']);
    //
    //     getProfile();
    //   } else {
    //     Get.snackbar('error', res['common']['message']);
    //   }
    // } catch (_) {
    // } finally {
    //   isUpdateLoading(false);
    // }
  }

  /// ================= UPDATE RELIGION DETAILS=================
  Future<void> updateReligionDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';

    await _performProfileUpdate(
      UpdateUserProfileRequest(
        userId: userid,
        casteId: selectedCaste.value,
        subCasteId: selectedSubCaste.value,
      ),
    );

    //
    // try {
    //   isUpdateLoading(true);
    //   final userid = await SecureStorageService.read('user_id') ?? '';
    //   final res = await _updateProfileUsecase.call(
    //     UpdateUserProfileRequest(
    //       userId: userid,
    //       casteId: selectedCaste.value,
    //       subCasteId: selectedSubCaste.value,
    //     ),
    //   );
    //   if (res['common']['status'] == true) {
    //     Get.back();
    //     Get.snackbar('Success', res['common']['message']);
    //
    //     getProfile();
    //   } else {
    //     Get.snackbar('error', res['common']['message']);
    //   }
    // } catch (_) {
    // } finally {
    //   isUpdateLoading(false);
    // }
  }

  /// ================= UPDATE LOCATION DETAILS=================
  Future<void> updateLocationDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';

    await _performProfileUpdate(
      UpdateUserProfileRequest(
        userId: userid,
        country: selectedCountry.value,
        state: selectedState.value,
        city: selectedCity.value,
        address: addressController.text.trim(),
      ),
    );

    // try {
    //   isUpdateLoading(true);
    //   final userid = await SecureStorageService.read('user_id') ?? '';
    //   final res = await _updateProfileUsecase.call(
    //     UpdateUserProfileRequest(
    //       userId: userid,
    //       country: selectedCountry.value,
    //       state: selectedState.value,
    //       city: selectedCity.value,
    //     ),
    //   );
    //   if (res['common']['status'] == true) {
    //     Get.back();
    //     Get.snackbar('Success', res['common']['message']);
    //
    //     getProfile();
    //   } else {
    //     Get.snackbar('error', res['common']['message']);
    //   }
    // } catch (_) {
    // } finally {
    //   isUpdateLoading(false);
    // }
  }

  /// ================= UPDATE FAMILY DETAILS=================
  Future<void> updateFamilyDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';

    await _performProfileUpdate(
      UpdateUserProfileRequest(
        userId: userid,
        fatherName: fatherNameController.text.trim(),
        fatherJob: fatherJobController.text.trim(),
        motherName: motherNameController.text.trim(),
        motherJob: motherJobController.text.trim(),
        sibllingDetails: siblingController.text.trim(),
      ),
    );

    // try {
    //   isUpdateLoading(true);
    //   final userid = await SecureStorageService.read('user_id') ?? '';
    //   final res = await _updateProfileUsecase.call(
    //     UpdateUserProfileRequest(
    //       userId: userid,
    //       fatherName: fatherNameController.text.trim(),
    //       fatherJob: fatherJobController.text.trim(),
    //       motherName: motherNameController.text.trim(),
    //       motherJob: motherJobController.text.trim(),
    //       sibllingDetails: siblingController.text.trim(),
    //     ),
    //   );
    //   if (res['common']['status'] == true) {
    //     Get.back();
    //     Get.snackbar('Success', res['common']['message']);
    //
    //     getProfile();
    //   } else {
    //     Get.snackbar('error', res['common']['message']);
    //   }
    // } catch (_) {
    // } finally {
    //   isUpdateLoading(false);
    // }
  }

  /// ================= UPDATE HOROSCOPE DETAILS=================
  Future<void> updateHoroscopeDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';
    await _performProfileUpdate(
      UpdateUserProfileRequest(
        userId: userid,
        birthtime: birthTimeController.text.trim(),
        birthdate: birthDateController.text.trim(),
        rasi: selectedRashi.value,
        horoscopeDoc: horoscopeFile.value,
      ),
    );

    // try {
    //   isUpdateLoading(true);
    //   final userid = await SecureStorageService.read('user_id') ?? '';
    //   final res = await _updateProfileUsecase.call(
    //     UpdateUserProfileRequest(
    //       userId: userid,
    //       birthtime: birthTimeController.text.trim(),
    //       birthdate: birthDateController.text.trim(),
    //       rasi: selectedRashi.value,
    //       horoscopeDoc: horoscopeFile.value,
    //     ),
    //   );
    //   if (res['common']['status'] == true) {
    //     Get.back();
    //     Get.snackbar('Success', res['common']['message']);
    //
    //     getProfile();
    //   } else {
    //     Get.snackbar('error', res['common']['message']);
    //   }
    // } catch (_) {
    // } finally {
    //   isUpdateLoading(false);
    // }
  }

  /// ================= UPDATE PHOTOS DETAILS=================
  Future<void> updatePhotosDetails() async {
    final userid = await SecureStorageService.read('user_id') ?? '';
    final fileImages = profileImages.whereType<File>().toList();
    final photos = await prepareDocuments(fileImages);

    await _performProfileUpdate(
      UpdateUserProfileRequest(
        userId: userid,
        profilePicture: profileImage.value,
        photos: photos,
        removeFile: removedFiles,
        hidePhotos: isHide.value == true ? '1' : '0',
      ),
    );

    //   try {
    //     isUpdateLoading(true);
    //     final userid = await SecureStorageService.read('user_id') ?? '';
    //     final fileImages = profileImages.whereType<File>().toList();
    //     final photos = await prepareDocuments(fileImages);
    //
    //     final res = await _updateProfileUsecase.call(
    //       UpdateUserProfileRequest(
    //         userId: userid,
    //         profilePicture: profileImage.value,
    //         photos: photos,
    //         removeFile: removedFiles,
    //         hidePhotos: isHide.value == true ? '1' : '0',
    //       ),
    //     );
    //     if (res['common']['status'] == true) {
    //       Get.back();
    //       Get.snackbar('Success', res['common']['message']);
    //       profileImage.value = null;
    //       profileImages.clear();
    //       removedFiles.clear();
    //       getProfile();
    //     } else {
    //       Get.snackbar('error', res['common']['message']);
    //     }
    //   } catch (_) {
    //   } finally {
    //     isUpdateLoading(false);
    //   }
  }

  /// ================= UPDATE DOCUMENTS DETAILS=================
  Future<void> updateDocumentsDetails() async {
    try {
      isUpdateLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final fileDocs = documentList.whereType<File>().toList();
      final documents = await prepareDocuments(fileDocs);
      final res = await _updateProfileUsecase.call(
        UpdateUserProfileRequest(
          userId: userid,
          documents: documents,
          removeDocs: removedDocuments,
        ),
      );
      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);
        removedDocuments.clear();
        documentList.clear();
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

  /// ================= RESET ALL =================
  void resetAll() {
    /// Clear TextFields
    whatsappNoController.clear();
    alternateNoController.clear();
    aboutMeController.clear();
    educationDetailsController.clear();
    jobDetailsController.clear();
    fatherNameController.clear();
    fatherJobController.clear();
    motherNameController.clear();
    motherJobController.clear();
    siblingController.clear();
    birthTimeController.clear();
    birthDateController.clear();

    /// Reset dropdown selections
    selectedAge.value = null;
    selectedMStatus.value = null;
    selectedHeight.value = null;
    selectedCreatedFor.value = null;
    selectedEducationCategory.value = null;
    selectedJobCategory.value = null;
    selectedAnnualIncome.value = null;
    selectedCaste.value = null;
    selectedSubCaste.value = null;
    selectedCountry.value = null;
    selectedState.value = null;
    selectedCity.value = null;
    selectedRashi.value = null;
    selectedDeleteReason.value = null;

    /// Reset files & images
    profileImage.value = null;
    horoscopeFile.value = null;

    profileImages.clear();
    documentList.clear();
    removedFiles.clear();
    removedDocuments.clear();

    /// Reset flags
    isHide.value = false;

    /// Optional: clear API data (only if needed)
    // profileDetails.clear();

    update(); // if using GetBuilder anywhere
  }

  /// ================= PROFILE UPDATE COMPONENT =================
  Future<void> _performProfileUpdate(UpdateUserProfileRequest request) async {
    try {
      isUpdateLoading(true);

      final res = await _updateProfileUsecase.call(request);

      if (res['common']['status'] == true) {
        Get.back();

        CustomSnackbar.show(
          context: Get.context!,
          message: res['common']['message'],
          type: SnackbarType.success,
        );

        await getProfile();
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: res['common']['message'],
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      // AppLogger.error(e.toString());
    } finally {
      isUpdateLoading(false);
    }
  }

  /// ================= DELETE ACCOUNT =================
  Future<void> deleteAccount() async {
    try {
      final userid = await SecureStorageService.read('user_id') ?? '';
      // Validation
      if (selectedDeleteReason.value!.isEmpty) {
        CustomSnackbar.show(
          context: Get.context!,
          message: "Please select delete reason",
          type: SnackbarType.error,
        );
        return;
      }

      isDeleteLoading(true);

      final res = await _deleteAccountUsecase.call(
        UserRequest(userid, view: selectedDeleteReason.value.toString()),
      );

      if (res['common']['status'] == true) {
        CustomSnackbar.show(
          context: Get.context!,
          message: res['common']['message'],
          type: SnackbarType.success,
        );
        await SecureStorageService.clear();
        await LocalStorage.clear();
        Get.offAllNamed(Routes.login);
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: res['common']['message'],
          type: SnackbarType.error,
        );
      }
    } finally {
      isDeleteLoading(false);
    }
  }
}
