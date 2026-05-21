import 'dart:ui';
import 'package:madhya/core/component/app_share.dart';
import 'package:madhya/core/exporters/app_export.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({super.key});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  final controller = Get.find<OtherProfileController>();
  final interestController = Get.find<InterestController>();
  final shortListController = Get.find<ShortlistController>();

  String get userId => Get.arguments?['id']?.toString() ?? '';

  String get source => Get.arguments?['source']?.toString() ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.otherProfileDetails(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        await _handleBack();
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Obx(
          () => controller.isLoading.isTrue
              ? AppLoader.circular(color: AppColors.lightPrimary)
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          /// 🔥 TOP IMAGE SECTION
                          _buildTopImageList(theme),
                          SizedBox(height: 50.h),

                          /// 🔹 DATA CHIPS
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              spacing: 12.h,
                              children: [
                                _buildDataChips(theme),
                                _buildDivider(),
                                _buildAboutMe(theme),
                                _buildBasicDetails(),
                                _buildProfessionalDetails(),
                                _buildReligionDetails(),
                                _buildLocationDetails(),
                                _buildFamilyDetails(),
                                _buildHoroscopeDetails(),
                                _buildLookingForDetails(),
                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildAppbar(theme),
                  ],
                ),
        ),
      ),
    );
  }

  Future<bool> _handleBack() async {
    switch (source) {
      case "deeplink":
        Get.offAllNamed(Routes.mainScreen);
        return false;

      case "matches":
        Get.back();
        return false;

      default:
        Get.back();
        return false;
    }
  }

  Widget _buildAppbar(ThemeData theme) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 10,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 50.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 🔹 LEFT BACK BUTTON
            Positioned(
              left: 16.w,
              child: AppIconButton(
                onPressed: _handleBack,
                icon: HugeIcons.strokeRoundedArrowLeft01,
                iconColor: theme.scaffoldBackgroundColor,
                backgroundColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.5,
                ),
              ),
            ),

            /// 🔹 RIGHT MENU BUTTON
            Positioned(
              right: 0.w,
              child: PopupMenuButton<String>(
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                onSelected: (value) {
                  if (value == 'block') {
                    AllDialogs().showConfirmationDialog(
                      'Are you sure?',
                      'Are you sure you want to block this profile?',
                      onConfirm: () async {
                        await controller.blockProfile(
                          controller.profileDetails['id']?.toString() ?? '',
                        );
                      },
                    );
                  } else if (value == 'report') {
                    if (controller.profileDetails['is_reported'] == false) {
                      controller.selectedReason.value = null;
                      AppBottomSheet.show(
                        context: context,
                        showCloseButton: false,
                        height: Get.height * 0.7.h,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        child: Obx(
                          () => ReportProfileList(
                            onSubmit: () async {
                              final selectedItem = controller.reasonsOptions
                                  .firstWhere(
                                    (e) =>
                                        e.id == controller.selectedReason.value,
                                  );
                              final msg = selectedItem.text;
                              await controller
                                  .reportProfile(
                                    controller.profileDetails['id'].toString(),
                                    msg,
                                  )
                                  .then((v) async {
                                    await controller.otherProfileDetails(
                                      controller.profileDetails['id']
                                          .toString(),
                                    );
                                  });
                            },
                            controller: controller,
                            items: controller.reasonsOptions,
                            selectedValue: controller.selectedReason.value,
                            onChanged: (val) {
                              controller.selectedReason.value = val;
                            },
                          ),
                        ),
                      );
                    }
                  } else if (value == 'share') {
                    _handleShare();
                  }
                },
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedMoreVerticalSquare01,
                    size: 16.r,
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
                itemBuilder: (context) => [
                  _buildPopupMenu(
                    'Share Profile',
                    HugeIcons.strokeRoundedShare01,
                    'share',
                  ),
                  _buildPopupMenu(
                    'Block/Ignore Profile',
                    HugeIcons.strokeRoundedUnavailable,
                    'block',
                  ),
                  _buildPopupMenu(
                    controller.profileDetails['is_reported'] == false
                        ? 'Report Profile'
                        : 'Already Reported',
                    HugeIcons.strokeRoundedInformationCircle,
                    'report',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenu(
    String name,
    dynamic icon,
    String value,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.w,
        children: [
          HugeIcon(icon: icon, size: 16.r),
          Text(name),
        ],
      ),
    );
  }

  Widget _buildTopImageList(ThemeData theme) {
    final profileImage =
        controller.profileDetails['profile_image']?.toString() ?? '';

    final images = List<String>.from(controller.profileDetails['photos'] ?? []);

    /// Add profile image at first
    if (profileImage.isNotEmpty && !images.contains(profileImage)) {
      images.insert(0, profileImage);
    }
    final isHide = controller.profileDetails['hide_photos'] != '0'
        ? true
        : false;
    final topInset = MediaQuery.of(context).padding.top;
    // // 👉 EMPTY CASE
    if (images.isEmpty || isHide) {
      return SizedBox(
        height: Get.height * 0.55.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: theme.brightness == Brightness.light
                    ? Colors.grey.shade100
                    : Colors.grey.shade900,
                child: Center(
                  child: Image.asset(
                    AppAssets.defaultImage,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            buildGradientOverlay(),
            buildContentOverlay(controller.profileDetails, true),
            _buildBottomMenu(theme),
          ],
        ),
      );
    }
    return SizedBox(
      height: Get.height * 0.55.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              controller.currentIndex.value = index;
            },
            itemBuilder: (_, index) {
              final imageUrl = images[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),

                  /// Optional dark overlay for blur background
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.15),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: topInset),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: FadeInImage(
                        placeholderFit: BoxFit.cover,
                        placeholder: AssetImage(AppAssets.defaultImage),
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade100,
                            child: Center(
                              child: Image.asset(AppAssets.defaultImage),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  buildGradientOverlay(),
                ],
              );
            },
          ),
          _buildIndicators(images, theme),
          buildContentOverlay(controller.profileDetails, true),

          /// 🔥 APP BAR
          // _buildAppbar(),
          _buildBottomMenu(theme),
        ],
      ),
    );
  }

  void _handleShare() {
    AppShare.share(username: controller.profileDetails['username']);
  }

  /// 🔹 INDICATORS
  Widget _buildIndicators(List images, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(
        8.0,
      ).copyWith(top: MediaQuery.of(context).padding.top + 30),
      child: ValueListenableBuilder<int>(
        valueListenable: controller.currentIndex,
        builder: (_, index, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final isActive = index == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 30 : 10,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: isActive ? theme.scaffoldBackgroundColor : Colors.grey,
                ),
              );
            }),
          );
        },
      ),
    );
  }

  /// 🔥 BOTTOM MENU
  Widget _buildBottomMenu(ThemeData theme) {
    return Positioned(
      bottom: -35,
      left: 8,
      right: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          spacing: 4.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildMenuCard(
                controller.profileDetails['is_interest_sent'] == true
                    ? 'Interest\nSent ✔'
                    : 'Send\nInterest',
                HugeIcons.strokeRoundedFavouriteCircle,
                () {
                  if (controller.profileDetails['is_interest_sent'] == true) {
                    return;
                  }
                  controller.selectedId.value = null;
                  interestController.isPremium.value =
                      controller.profileDetails['is_subscribed'] == true;
                  AppBottomSheet.show(
                    context: context,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    showCloseButton: false,
                    height: interestController.isPremium.value
                        ? Get.height * 0.6.h
                        : Get.height * 0.35.h,
                    child: Obx(() {
                      return InterestOptionsList(
                        isUnlocked:
                            controller.profileDetails['is_subscribed'] == true,
                        onSubmit: () async {
                          final selectedItem = controller.interestOptions
                              .firstWhere(
                                (e) => e.id == controller.selectedId.value,
                              );

                          final msg = selectedItem.text;
                          await interestController
                              .sendInterest(
                                controller.profileDetails['id'].toString(),
                                msg,
                              )
                              .then((v) async {
                                Get.back();
                                await controller.otherProfileDetails(
                                  controller.profileDetails['id'].toString(),
                                );
                              });
                        },
                        controller: interestController,
                        items: controller.interestOptions,
                        selectedValue: controller.selectedId.value,
                        onChanged: (val) {
                          controller.selectedId.value = val;
                        },
                      );
                    }),
                  );
                  // if (controller.profileDetails['is_subscribed'] == true) {
                  //   controller.selectedId.value = null;
                  //   interestController.isSuccess.value =
                  //       controller.profileDetails['is_subscribed'] == true;
                  //   AppBottomSheet.show(
                  //     context: context,
                  //     backgroundColor: theme.scaffoldBackgroundColor,
                  //     showCloseButton: false,
                  //     height: Get.height * 0.6.h,
                  //     child: Obx(() {
                  //       return InterestOptionsList(
                  //         onSubmit: () async {
                  //           final selectedItem = controller.interestOptions
                  //               .firstWhere(
                  //                 (e) => e.id == controller.selectedId.value,
                  //               );
                  //
                  //           final msg = selectedItem.text;
                  //           await interestController
                  //               .sendInterest(
                  //                 controller.profileDetails['id'].toString(),
                  //                 msg,
                  //               )
                  //               .then((v) async {
                  //                 await controller.otherProfileDetails(
                  //                   controller.profileDetails['id'].toString(),
                  //                 );
                  //               });
                  //         },
                  //         controller: interestController,
                  //         items: controller.interestOptions,
                  //         selectedValue: controller.selectedId.value,
                  //         onChanged: (val) {
                  //           controller.selectedId.value = val;
                  //         },
                  //       );
                  //     }),
                  //   );
                  // } else {
                  //   CustomSnackbar.show(
                  //     context: context,
                  //     message: 'Please upgrade your plan to send interest',
                  //     type: SnackbarType.warning,
                  //   );
                  // }
                },
                theme,
              ),
            ),
            Expanded(
              child: Obx(
                () => _buildMenuCard(
                  isLoading: shortListController.isShortListing.value,
                  controller.profileDetails['is_shortlisted'] == true
                      ? 'Shortlisted'
                      : 'Shortlist',
                  controller.profileDetails['is_shortlisted'] == true
                      ? Icons.star_rounded
                      : HugeIcons.strokeRoundedStar,
                  () async {
                    await shortListController
                        .shortListPeople(
                          controller.profileDetails['id'].toString(),
                        )
                        .then((v) async {
                          await controller.otherProfileDetails(
                            controller.profileDetails['id'].toString(),
                            showLoading: false,
                          );
                        });
                  },
                  theme,
                ),
              ),
            ),
            Expanded(
              child: _buildMenuCard(
                'Contact',
                HugeIcons.strokeRoundedCall02,
                () async {
                  await controller.viewContact(theme);
                },
                theme,
                isLoading: controller.isViewLoading.value,
              ),
            ),
            if (controller.profileDetails['wp_no'].toString().isNotEmpty)
              Expanded(
                child: _buildMenuCard(
                  'WhatsApp',
                  HugeIcons.strokeRoundedWhatsapp,
                  () async {
                    await controller.whatsappConnect(theme);
                  },
                  theme,
                  isLoading: controller.isWhatsappLoading.value,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 🔹 MENU CARD
  Widget _buildMenuCard(
    String title,
    dynamic icon,
    dynamic onTap,
    ThemeData theme, {
    bool isLoading = false,
  }) {
    final isLight = theme.brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.1.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border.all(
            color: !isLight ? theme.dividerTheme.color! : Colors.transparent,
            width: 0.5.w,
          ),
          boxShadow: [
            isLight
                ? BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                : BoxShadow(
                    color: Colors.white.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
          ],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: isLoading
            ? AppLoader.circular(size: 20.r, color: AppColors.lightPrimary)
            : Column(
                spacing: 6.h,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon == Icons.star_rounded
                      ? Icon(icon, color: AppColors.lightPrimary, size: 30.r)
                      : HugeIcon(
                          icon: icon,
                          color: AppColors.lightPrimary,
                          size: 24.r,
                        ),
                  SizedBox(
                    height: 30.h,
                    child: Center(
                      child: AppText(
                        text: title,
                        fontSize: 13.sp,
                        maxLines: 2,
                        style: theme.textTheme.labelMedium,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// 🔹 DATA CHIPS
  Widget _buildDataChips(ThemeData theme) {
    final isLight = theme.brightness == Brightness.light;
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: controller.chipsData.map<Widget>((i) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isLight ? AppColors.catBgColor : theme.cardColor,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: AppColors.lightTextLowColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 FIXED ICON SIZE
                HugeIcon(
                  icon: i['icon'] as List<List<dynamic>>,
                  size: 18.r,
                  color: isLight
                      ? AppColors.lightTextLowColor
                      : AppColors.grey400,
                ),

                SizedBox(width: 6.w),

                /// 🔹 TEXT
                Flexible(
                  child: AppText(
                    text: i['title']?.toString() ?? '',
                    fontSize: 14.sp,
                    maxLines: 2,
                    style: theme.textTheme.labelLarge!.copyWith(
                      overflow: TextOverflow.ellipsis,
                      color: isLight
                          ? AppColors.lightTextMidColor
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 🔹 DIVIDER
  Widget _buildDivider() {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      color: theme.brightness == Brightness.light
          ? AppColors.lightPink
          : theme.dividerTheme.color!,
    );
  }

  /// 🔹 ABOUT ME
  Widget _buildAboutMe(ThemeData theme) {
    String aboutData = controller.profileDetails['about'] ?? '';
    if (aboutData.isEmpty) return SizedBox();
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader('About Me', HugeIcons.strokeRoundedUser03),

        AppText(
          text: aboutData,
          fontSize: 14.sp,
          maxLines: 100,
          textAlign: TextAlign.start,
          style: theme.textTheme.bodyMedium,
          color: AppColors.lightTextLowColor,
        ),
        _buildDivider(),
      ],
    );
  }

  /// 🔹 BASIC DETAILS
  Widget _buildBasicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader('Basic Details', HugeIcons.strokeRoundedProfile),

        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Gender',
              value: controller.profileDetails['gender'] == '0'
                  ? 'Male'
                  : 'Female',
            ),
            buildDetailItem(
              label: 'Marital Status',
              value: controller.profileDetails['marital_status'] ?? '',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Height',
              value: '${controller.profileDetails['height_in_ft'] ?? '-'}',
            ),
            buildDetailItem(
              label: 'Profile Created For',
              value: controller.profileDetails['profile_created_for'] ?? '-',
            ),
          ],
        ),
        _buildDivider(),
      ],
    );
  }

  /// 🔹 PROFESSIONAL DETAILS
  Widget _buildProfessionalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader(
          'Professional Info',
          HugeIcons.strokeRoundedAssignments,
        ),

        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Education Category',
              value: controller.profileDetails['education_category'] ?? '-',
            ),
            buildDetailItem(
              label: 'Education Detail',
              value: controller.profileDetails['education_details'] ?? '-',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Job Category',
              value: controller.profileDetails['job_category'] ?? '-',
            ),
            buildDetailItem(
              label: 'Job Detail',
              value: controller.profileDetails['job_details'] ?? '-',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Annual Income',
              value: controller.profileDetails['annual_income'] ?? '-',
            ),
          ],
        ),
        _buildDivider(),
      ],
    );
  }

  /// 🔹 RELIGION DETAILS
  Widget _buildReligionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader(
          'Religion Info',
          HugeIcons.strokeRoundedWavingHand01,
        ),

        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Religion',
              value: controller.profileDetails['religion'] ?? '-',
            ),
            buildDetailItem(
              label: 'Caste / Community',
              value: controller.profileDetails['caste'] ?? '-',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Sub Caste',
              value: controller.profileDetails['subCaste'] ?? '-',
            ),
          ],
        ),
        _buildDivider(),
      ],
    );
  }

  /// 🔹 LOCATION DETAILS
  Widget _buildLocationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader('Location', HugeIcons.strokeRoundedLocation05),

        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'Country',
              value: controller.profileDetails['country'] ?? '-',
            ),
            buildDetailItem(
              label: 'State',
              value: controller.profileDetails['state'] ?? '-',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: 'City',
              value: controller.profileDetails['city'] ?? '-',
            ),
            buildDetailItem(
              label: 'Address',
              value: controller.profileDetails['address'] ?? '-',
            ),
          ],
        ),
        _buildDivider(),
      ],
    );
  }

  /// 🔹 FAMILY DETAILS
  Widget _buildFamilyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader(
          'Family Details',
          HugeIcons.strokeRoundedUserGroup02,
        ),

        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: "Father's Name",
              value: controller.profileDetails['father_name'] ?? '-',
            ),
            buildDetailItem(
              label: "Father's Job",
              value: controller.profileDetails['father_job'] ?? '-',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: "Mother's Name",
              value: controller.profileDetails['mothers_name'] ?? '-',
            ),
            buildDetailItem(
              label: "Mother's Job",
              value: controller.profileDetails['mothers_job'] ?? '-',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: "Siblings Details",
              value: controller.profileDetails['siblling_details'] ?? '-',
            ),
          ],
        ),
        _buildDivider(),
      ],
    );
  }

  /// 🔹 HOROSCOPE DETAILS
  Widget _buildHoroscopeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader(
          'Horoscope Details',
          HugeIcons.strokeRoundedUserGroup02,
        ),

        Row(
          spacing: 16.w,
          children: [
            buildDetailItem(
              label: "Rashi",
              value: controller.profileDetails['rasi'] ?? '-',
            ),
            buildDetailItem(
              label: "Birthday Date",
              value: controller.profileDetails['birth_date'] ?? '-',
            ),
          ],
        ),
        Row(
          spacing: 16.w,
          children: [
            if (controller.profileDetails['birthtime'].toString().isNotEmpty &&
                controller.profileDetails['birthtime'] != null)
              buildDetailItem(
                label: "Birth Time",
                value: convertToLocalTime(
                  controller.profileDetails['birthtime'] ?? '',
                ),
              ),
          ],
        ),
        if (controller.profileDetails['horoscope_photo'].toString().isNotEmpty)
          TextButton(
            onPressed: () =>
                downloadFile(controller.profileDetails['horoscope_photo']),
            child: AppText(
              text: 'Download Horoscope',
              fontSize: 14.sp,
              color: AppColors.lightPrimary,
            ),
          ),

        _buildDivider(),
      ],
    );
  }

  /// 🔹 LOCATION DETAILS
  Widget _buildLookingForDetails() {
    if (controller.preferenceDetails.isEmpty) return SizedBox();
    final heShe = controller.profileDetails['gender'] == '0' ? 'He' : 'She';
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildSectionHeader(
              'What $heShe is looking for',
              HugeIcons.strokeRoundedSearch02,
              isPrimary: true,
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Age',
                  value: getAgeRange(controller.preferenceDetails),
                  // '${controller.preferenceDetails['patner_age_from'] ?? ''} to ${controller.preferenceDetails['patner_age_to'] ?? ''} yrs',
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Height',
                  value: getHeightRange(controller.preferenceDetails),
                  // '${controller.preferenceDetails['patner_height_from'] ?? ''} to ${controller.preferenceDetails['patner_height_to '] ?? ''} cm',
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Education',
                  value: controller.preferenceDetails['education'].join(' , '),
                ),
              ],
            ),

            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Occupation',
                  value: controller.preferenceDetails['job'].join(' , '),
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Religion',
                  value: controller.preferenceDetails['religions'].join(' , '),
                ),
              ],
            ),

            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Caste',
                  value: controller.preferenceDetails['casts'].join(' , '),
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Sub Caste',
                  value: controller.preferenceDetails['sub_casts'].join(' , '),
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Diet Preference',
                  value: getDisplayValue(
                    key: controller.preferenceDetails['dietary_habits'],
                    options: Get.find<PreferenceController>().dietOptionsList,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Smoking',
                  value: getDisplayValue(
                    key: controller.preferenceDetails['smoking_habits'],
                    options:
                        Get.find<PreferenceController>().smokingOptionsList,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Drinking',
                  value: getDisplayValue(
                    key: controller.preferenceDetails['drinking_habits'],
                    options:
                        Get.find<PreferenceController>().drinkingOptionsList,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                buildDetailItem(
                  isFill: false,
                  label: 'Special Case',
                  value: getDisplayValue(
                    key: controller.preferenceDetails['special_case'],
                    options: Get.find<PreferenceController>().specialCasesList,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 MATCH PERCENT DETAILS
  Widget _buildMatchPercentage(ThemeData theme) {
    final matchPercent = controller.profileDetails['match_percentage'] ?? 50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader(
          'Match Compatibility',
          HugeIcons.strokeRoundedFavourite,
        ),

        SizedBox(height: 12.h),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              /// 🔹 PERCENT TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Your Match Score',
                    fontSize: 14.sp,
                    style: theme.textTheme.labelLarge,
                  ),
                  AppText(
                    text: '$matchPercent%',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightPrimary,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              /// 🔹 PROGRESS BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: (matchPercent / 100).clamp(0.0, 1.0),
                  minHeight: 8.h,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.lightPrimary,
                ),
              ),

              SizedBox(height: 12.h),

              /// 🔹 MESSAGE
              AppText(
                text: _getMatchMessage(matchPercent),
                fontSize: 13.sp,
                maxLines: 5,
                style: theme.textTheme.bodySmall,
                color: AppColors.lightTextLowColor,
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),
      ],
    );
  }

  String _getMatchMessage(int percent) {
    if (percent >= 80) {
      return "Excellent match! You both share strong compatibility.";
    } else if (percent >= 60) {
      return "Good match. There’s a decent level of compatibility.";
    } else if (percent >= 40) {
      return "Average match. You may need to understand each other better.";
    } else {
      return "Low match. Compatibility might be challenging.";
    }
  }
}
