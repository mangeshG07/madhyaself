import 'package:madhya/core/exporters/app_export.dart';

class HomeController extends GetxController {
  final HomeUsecase homeUsecase;
  final ChatController chatController;
  final GlobalSearchController searchController;
  HomeController(this.homeUsecase, this.chatController, this.searchController);

  final isLoading = false.obs;
  final hasAdvancedFilter = false.obs;
  final hasBasicFilter = false.obs;

  final sliderList = [].obs;
  final statsData = [].obs;
  final discStatData = [].obs;
  final todayMatchList = [].obs;
  final topMatchList = [].obs;
  final homeData = {}.obs;
  final profileCompletion = 0.obs;

  @override
  void onInit() {
    super.onInit();
    connectSocket();
    // getHome();
  }

  Future<void> connectSocket() async {
    final userid = await SecureStorageService.read('user_id') ?? '';
    chatController.connectSocket(userid, isGlobal: true);
  }

  Future<void> getHome() async {
    try {
      final userid = await SecureStorageService.read('user_id') ?? '';

      isLoading(true);

      final res = await homeUsecase.call(UserRequest(userid));

      if (res['common']['status'] != true) return;

      final data = res['data'];
      hasBasicFilter.value = data['hasBasicFilter'] ?? false;
      hasAdvancedFilter.value = data['hasAdvancedFilter'] ?? false;
      _setHomeData(data);

      final platformData = Platform.isAndroid ? res['android'] : res['ios'];

      /// Maintenance first
      if (platformData['is_maintenance'] == true) {
        isLoading(false);

        Get.offAll(
          () => MaintenanceScreen(
            message: platformData['maintenance_msg'] ?? '',
            imageAsset: AppAssets.appMaintainance,
            buttonTextColor: AppColors.lightPrimary,
            buttonBorderColor: AppColors.lightPrimary,
          ),
        );

        return;
      }

      /// Update after maintenance check
      await handleUpdate(platformData);
    } catch (e) {
      debugPrint('Home API error: $e');
    } finally {
      isLoading(false);
    }
  }

  void _setHomeData(dynamic data) {
    topMatchList.value = data['top_matches'] ?? [];
    todayMatchList.value = data['today_matches'] ?? [];
    profileCompletion.value = data['profile_completion'] ?? 0;

    setStatsData(data);

    sliderList.assignAll(
      (data['slider'] ?? [])
          .map((e) => e['image'] ?? '')
          .where((e) => e.toString().isNotEmpty)
          .map((e) => e.toString())
          .toList(),
    );
  }

  // Future<void> _getHome() async {
  //   try {
  //     final userid = await SecureStorageService.read('user_id') ?? '';
  //     isLoading(true);
  //     final res = await homeUsecase.call(UserRequest(userid));
  //
  //     if (res['common']['status'] == true) {
  //       final data = res['data'];
  //       topMatchList.value = data['top_matches'] ?? [];
  //       todayMatchList.value = data['today_matches'] ?? [];
  //       profileCompletion.value = data['profile_completion'] ?? 0;
  //       setStatsData(data);
  //       sliderList.assignAll(
  //         data['slider']
  //             .map((e) => e['image'] ?? '')
  //             .where((url) => url.toString().isNotEmpty)
  //             .map((e) => e.toString())
  //             .toList(),
  //       );
  //       handleUpdate(Platform.isAndroid ? res['android'] : res['ios']);
  //       if (Platform.isAndroid) {
  //         if (res['android']['is_maintenance'] == true) {
  //           Get.offAll(
  //             () => MaintenanceScreen(
  //               message: res['android']['maintenance_msg'] ?? '',
  //               imageAsset: AppAssets.appMaintainance,
  //               buttonTextColor: AppColors.lightPrimary,
  //               buttonBorderColor: AppColors.lightPrimary,
  //             ),
  //             transition: Transition.rightToLeftWithFade,
  //           );
  //         }
  //       } else if (Platform.isIOS) {
  //         if (res['ios']['is_maintenance'] == true) {
  //           Get.offAll(
  //             () => MaintenanceScreen(
  //               buttonTextColor: AppColors.lightPrimary,
  //               buttonBorderColor: AppColors.lightPrimary,
  //               message: res['ios']['maintenance_msg'] ?? '',
  //               imageAsset: AppAssets.appMaintainance,
  //             ),
  //             transition: Transition.rightToLeftWithFade,
  //           );
  //         }
  //       }
  //     }
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  void setStatsData(dynamic data) {
    statsData.value = [
      {
        "title": "Viewed\nYou",
        "value": data['viewed_you']?.toString() ?? '0',
        "icon": HugeIcons.strokeRoundedEye,
        'onTap': () => Get.toNamed(Routes.viewed),
      },
      {
        "title": "Interest Received",
        "value": data['interests_received']?.toString() ?? '0',
        "icon": HugeIcons.strokeRoundedDownload05,
        'onTap': () {
          Get.find<InterestController>().selectedType.value = 1;
          Get.toNamed(Routes.interest);
        },
      },
      {
        "title": "Interest Accepted",
        "value": data['interests_accepted']?.toString() ?? '0',
        "icon": HugeIcons.strokeRoundedThumbsUp,
        'onTap': () {
          Get.find<InterestController>().selectedType.value = 3;
          Get.toNamed(Routes.interest);
        },
      },
      {
        "title": "Shortlist\nProfile",
        "value": data['shortlist_profile']?.toString() ?? '0',
        "icon": HugeIcons.strokeRoundedBookmark01,
        'onTap': () => Get.toNamed(Routes.shortList),
      },
    ];
    discStatData.value = [
      {
        "title":
            '${data['user_profession_matches']?.toString() ?? '0'}\nMatches',
        "value": "Profession",
        "icon": HugeIcons.strokeRoundedBriefcase01,
        'onTap': () async {
          searchController.resetFilters();
          searchController.selectedJob.value =
              data['user_profession']?.toString() ?? '';
          await searchController.globalSearch();
        },
      },
      {
        "title":
            '${data['user_education_matches']?.toString() ?? '0'}\nMatches',
        "value": "Education",
        "icon": HugeIcons.strokeRoundedMortarboard02,
        'onTap': () async {
          searchController.resetFilters();
          searchController.selectedEducation.value =
              data['user_education']?.toString() ?? '';
          await searchController.globalSearch();
        },
      },
      {
        "title": '${data['user_caste_matches']?.toString() ?? '0'}\nMatches',
        "value": "Caste",
        "icon": HugeIcons.strokeRoundedStar,
        'onTap': () async {
          searchController.resetFilters();
          searchController.selectedCaste.value =
              data['user_caste']?.toString() ?? '';
          await searchController.globalSearch();
        },
      },
      {
        "title":
            '${data['user_sub_caste_matches']?.toString() ?? '0'}\nMatches',
        "value": "Subcaste",
        "icon": HugeIcons.strokeRoundedStar,
        'onTap': () async {
          searchController.resetFilters();
          searchController.selectedSubCaste.value =
              data['user_sub_caste']?.toString() ?? '';
          await searchController.globalSearch();
        },
      },
      {
        "title": '${data['user_city_matches']?.toString() ?? '0'}\nMatches',
        "value": "City",
        "icon": HugeIcons.strokeRoundedLocation04,
        'onTap': () async {
          searchController.resetFilters();
          searchController.selectedCity.value =
              data['user_city']?.toString() ?? '';
          await searchController.globalSearch();
        },
      },
      {
        "title": '${data['user_religion_matches']?.toString() ?? '0'}\nMatches',
        "value": "Religion",
        "icon": HugeIcons.strokeRoundedRotateLeft04,
        'onTap': () async {
          searchController.resetFilters();
          searchController.selectedReligion.value =
              data['user_religion']?.toString() ?? '';
          await searchController.globalSearch();
        },
      },
    ].obs;
  }
}
