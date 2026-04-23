import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class HomeController extends GetxController {
  final HomeUsecase homeUsecase;
  HomeController(this.homeUsecase);
  final isLoading = false.obs;

  final sliderList = [].obs;
  final statsData = [].obs;
  final discStatData = [].obs;
  final todayMatchList = [].obs;
  final topMatchList = [].obs;
  final homeData = {}.obs;
  final profileCompletion = 0.obs;
  final chatController = Get.find<ChatController>();

  @override
  void onInit() {
    super.onInit();
    connectSocket();
    _getHome();
  }

  Future<void> connectSocket() async {
    final userid = await SecureStorageService.read('user_id') ?? '';
    chatController.connectSocket(userid, isGlobal: true);
  }

  Future<void> _getHome() async {
    try {
      final userid = await SecureStorageService.read('user_id') ?? '';
      isLoading(true);
      final res = await homeUsecase.call(UserRequest(userid));

      if (res['common']['status'] == true) {
        final data = res['data'];
        topMatchList.value = data['top_matches'] ?? [];
        todayMatchList.value = data['today_matches'] ?? [];
        profileCompletion.value = data['profile_completion'] ?? 0;
        setStatsData(data);
        sliderList.assignAll(
          data['slider']
              .map((e) => e['image'] ?? '')
              .where((url) => url.toString().isNotEmpty)
              .map((e) => e.toString())
              .toList(),
        );
      }
    } finally {
      isLoading(false);
    }
  }

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
      },
      {
        "title":
            '${data['user_education_matches']?.toString() ?? '0'}\nMatches',
        "value": "Education",
        "icon": HugeIcons.strokeRoundedMortarboard02,
      },
      {
        "title": '${data['user_caste_matches']?.toString() ?? '0'}\nMatches',
        "value": "Caste",
        "icon": HugeIcons.strokeRoundedStar,
      },
      {
        "title":
            '${data['user_sub_caste_matches']?.toString() ?? '0'}\nMatches',
        "value": "Subcaste",
        "icon": HugeIcons.strokeRoundedStar,
      },
      {
        "title": '${data['user_city_matches']?.toString() ?? '0'}\nMatches',
        "value": "City",
        "icon": HugeIcons.strokeRoundedLocation04,
      },
      {
        "title": '${data['user_religion_matches']?.toString() ?? '0'}\nMatches',
        "value": "Religion",
        "icon": HugeIcons.strokeRoundedRotateLeft04,
      },
    ].obs;
  }
}
