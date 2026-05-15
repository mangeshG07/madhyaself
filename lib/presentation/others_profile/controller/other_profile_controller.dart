import 'package:madhya/core/exporters/app_export.dart';

class OtherProfileController extends GetxController {
  final OtherProfileUsecase usecase;
  final BlockUserUsecase _blockUserUsecase;
  final ReportProfileUsecase _reportProfileUsecase;
  final ViewContactUsecase _viewContactUsecase;
  final WhatsappConnectUsecase _whatsappConnectUsecase;
  OtherProfileController(
    this.usecase,
    this._blockUserUsecase,
    this._reportProfileUsecase,
    this._viewContactUsecase,
    this._whatsappConnectUsecase,
  );

  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  final interestOptions = <InterestOptionModel>[].obs;

  final reasonsOptions = <InterestOptionModel>[
    InterestOptionModel(id: 1, text: "User is stalking me with messages/calls"),
    InterestOptionModel(id: 2, text: "User is already engaged/married"),
    InterestOptionModel(id: 3, text: "User has no intention to marry"),
    InterestOptionModel(id: 4, text: "User is asking for money"),
    InterestOptionModel(
      id: 5,
      text: "Profile is fake or publishes incorrect information",
    ),
    InterestOptionModel(id: 6, text: "User is using abusive/indecent language"),
    InterestOptionModel(
      id: 7,
      text: "Photo on profile does not belong to the person",
    ),
  ].obs;

  RxnInt selectedId = RxnInt();
  RxnInt selectedReason = RxnInt();

  ///==============================Other Profile Details======================
  final isLoading = false.obs;
  final isReportLoading = false.obs;
  final isWhatsappLoading = false.obs;
  final isViewLoading = false.obs;
  final profileDetails = {}.obs;
  final chipsData = [].obs;

  Future<void> otherProfileDetails(
    String profileId, {
    bool showLoading = true,
  }) async {
    try {
      final userid = await SecureStorageService.read('user_id') ?? '';

      if (showLoading) isLoading(true);

      final res = await usecase.call(OtherUserRequest(userid, profileId));

      if (res['common']['status'] == true) {
        final data = res['data'] ?? {};
        profileDetails.value = data['user_data'][0] ?? {};
        final interestList = data['interest_messages'] ?? [];

        interestOptions.value = interestList
            .map<InterestOptionModel>((e) => InterestOptionModel.fromJson(e))
            .toList();

        setChipsData(profileDetails);
      }
    } finally {
      if (showLoading) isLoading(false);
    }
  }

  void setChipsData(dynamic data) {
    final heightText = [
      if ((data['height_in_ft'] ?? '').toString().trim().isNotEmpty)
        data['height_in_ft'],

      if ((data['height'] ?? '').toString().trim().isNotEmpty)
        '${data['height']} cm',
    ].join(' ');
    chipsData.value = [
      {
        'title': data['age'] != null ? '${data['age']} yrs' : '',
        'icon': HugeIcons.strokeRoundedParty,
      },
      {
        'title': data['religion'] ?? '',
        'icon': HugeIcons.strokeRoundedHandPrayer,
      },
      {'title': data['caste'] ?? '', 'icon': HugeIcons.strokeRoundedStar},

      /// Height chip
      if (heightText.isNotEmpty)
        {'title': heightText, 'icon': HugeIcons.strokeRoundedRuler},
      {
        'title': data['job_details'] ?? '',
        'icon': HugeIcons.strokeRoundedBook01,
      },
    ].where((e) => e['title'].toString().trim().isNotEmpty).toList();
  }

  /// ================= REPORT PROFILE =================
  Future<void> reportProfile(String otherUserId, String msg) async {
    try {
      isReportLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _reportProfileUsecase.call(
        OtherUserRequest(userid, otherUserId, reason: msg),
      );

      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        Get.offAllNamed(Routes.mainScreen);
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isReportLoading(false);
    }
  }

  /// ================= BLOCK PROFILE =================
  Future<void> blockProfile(String otherUserId) async {
    try {
      isReportLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _blockUserUsecase.call(
        OtherUserRequest(userid, otherUserId),
      );

      if (res['common']['status'] == true) {
        Get.back();
        Get.snackbar('Success', res['common']['message']);

        Get.offAllNamed(Routes.mainScreen);
      } else {
        Get.snackbar('error', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isReportLoading(false);
    }
  }

  /// ================= WHATSAPP CONNECT =================
  Future<void> whatsappConnect(ThemeData theme) async {
    try {
      isWhatsappLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _whatsappConnectUsecase.call(UserRequest(userid));

      if (res['common']['status'] == true) {
        await openWhatsApp(profileDetails['wp_no']?.toString() ?? '', '');
      } else {
        AppBottomSheet.show(
          context: Get.context!,
          showCloseButton: false,
          height: Get.height * 0.35.h,
          backgroundColor: theme.scaffoldBackgroundColor,
          child: ContactBottomsheet(
            isUnlocked: false,
            contactNumber: profileDetails['mobile_no']?.toString() ?? '',
            whatsappNumber: profileDetails['alternate_no']?.toString() ?? '',
          ),
        );
        // CustomSnackbar.show(
        //   context: Get.context!,
        //   message: res['common']['message'],
        //   type: SnackbarType.warning,
        // );
      }
    } catch (_) {
    } finally {
      isWhatsappLoading(false);
    }
  }

  /// ================= VIEW CONTACT =================
  Future<void> viewContact(ThemeData theme) async {
    try {
      isViewLoading(true);
      final userid = await SecureStorageService.read('user_id') ?? '';
      final res = await _viewContactUsecase.call(
        OtherUserRequest(userid, profileDetails['id']?.toString() ?? ''),
      );

      if (res['common']['status'] == true) {
        AppBottomSheet.show(
          context: Get.context!,
          showCloseButton: false,
          height: Get.height * 0.4.h,
          backgroundColor: theme.scaffoldBackgroundColor,
          child: ContactBottomsheet(
            isUnlocked: true,
            contactNumber: profileDetails['mobile_no']?.toString() ?? '',
            whatsappNumber: profileDetails['alternate_no']?.toString() ?? '',
          ),
        );
      } else {
        AppBottomSheet.show(
          context: Get.context!,
          showCloseButton: false,
          height: Get.height * 0.35.h,
          backgroundColor: theme.scaffoldBackgroundColor,
          child: ContactBottomsheet(
            isUnlocked: false,
            contactNumber: profileDetails['mobile_no']?.toString() ?? '',
            whatsappNumber: profileDetails['alternate_no']?.toString() ?? '',
          ),
        );
      }
    } catch (_) {
    } finally {
      isViewLoading(false);
    }
  }
}

class InterestOptionModel {
  final int id;
  final String text;

  InterestOptionModel({required this.id, required this.text});

  factory InterestOptionModel.fromJson(Map<String, dynamic> json) {
    return InterestOptionModel(
      id: json['id'],
      text: (json['message'] ?? '').replaceAll(
        '\r\n',
        ' ',
      ), // clean line breaks
    );
  }
}
