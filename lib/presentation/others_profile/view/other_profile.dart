import 'package:madhya/core/exporters/app_export.dart';
import 'package:madhya/presentation/others_profile/widget/report_profile_btmsheet.dart';

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

  @override
  void initState() {
    super.initState();
    controller.otherProfileDetails(userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
    );
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
                onPressed: () => Get.back(),
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
                    AppBottomSheet.show(
                      context: context,
                      showCloseButton: false,
                      // height: Get.height * 0.4.h,
                      backgroundColor: theme.scaffoldBackgroundColor,
                      child: ReportProfileList(
                        onSubmit: () async {
                          final selectedItem = controller.interestOptions
                              .firstWhere(
                                (e) => e.id == controller.selectedId.value,
                              );

                          final msg = selectedItem.text;
                          await controller
                              .reportProfile(
                                controller.profileDetails['id'].toString(),
                                msg,
                              )
                              .then((v) async {
                                await controller.otherProfileDetails(
                                  controller.profileDetails['id'].toString(),
                                );
                              });
                        },
                        controller: controller,
                        items: controller.reasonsOptions,
                        selectedValue: controller.selectedReason.value,
                        onChanged: (val) {
                          controller.selectedId.value = val;
                        },
                      ),
                    );
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
                    'Report Profile',
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
    final images = controller.profileDetails['photos'] ?? [];
    return SizedBox(
      height: Get.height * 0.55.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              controller.currentIndex.value = index;
            },
            itemBuilder: (_, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: FadeInImage(
                      placeholderFit: BoxFit.contain,
                      placeholder: AssetImage(AppAssets.appLogo),
                      image: NetworkImage(images[index] ?? ''),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Image.asset(AppAssets.appLogo, height: 40.h),
                          ),
                        );
                      },
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
      left: 16,
      right: 16,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          spacing: 16.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuCard(
              controller.profileDetails['is_interest_sent'] == true
                  ? 'Interest\nSent ✔'
                  : 'Send\nInterest',
              HugeIcons.strokeRoundedFavouriteCircle,

              () {
                controller.selectedId.value = null;
                interestController.isSuccess.value = false;
                AppBottomSheet.show(
                  context: context,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  showCloseButton: false,
                  height: Get.height * 0.6.h,
                  child: Obx(() {
                    return InterestOptionsList(
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
              },
              theme,
            ),
            Obx(
              () => _buildMenuCard(
                isLoading: shortListController.isShortListing.value,
                controller.profileDetails['is_shortlisted'] == true
                    ? 'Shortlisted'
                    : 'Shortlist',
                HugeIcons.strokeRoundedStar,
                () async {
                  if (controller.profileDetails['is_shortlisted'] == true) {
                    return;
                  }
                  await shortListController
                      .shortListPeople(
                        controller.profileDetails['id'].toString(),
                      )
                      .then((v) async {
                        await controller.otherProfileDetails(
                          controller.profileDetails['id'].toString(),
                        );
                      });
                  // AppBottomSheet.show(
                  //   context: context,
                  //   showCloseButton: false,
                  //   height: Get.height * 0.4.h,
                  //   child: ShortlistBottomsheet(
                  //     isUnlocked: shortListController.isSuccess.value,
                  //   ),
                  // );
                },
                theme,
              ),
            ),
            _buildMenuCard('Contact', HugeIcons.strokeRoundedCall02, () {
              AppBottomSheet.show(
                context: context,
                showCloseButton: false,
                height: Get.height * 0.4.h,
                backgroundColor: theme.scaffoldBackgroundColor,
                child: ContactBottomsheet(
                  isUnlocked: true,
                  contactNumber:
                      controller.profileDetails['mobile_no']?.toString() ?? '',
                  whatsappNumber:
                      controller.profileDetails['wp_no']?.toString() ?? '',
                ),
              );
            }, theme),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                  HugeIcon(
                    icon: icon,
                    color: AppColors.lightPrimary,
                    size: 24.r,
                  ),
                  SizedBox(
                    height: 30.h, // same for all cards
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
              color: isLight ? AppColors.catBgColor : AppColors.grey700,
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
                AppText(
                  text: i['title']?.toString() ?? '',
                  fontSize: 14.sp,
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: isLight ? AppColors.lightTextMidColor : Colors.white,
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
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildSectionHeader('About Me', HugeIcons.strokeRoundedUser03),

        AppText(
          text: controller.profileDetails['about'] ?? '-',
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
        const SizedBox(height: 16),
      ],
    );
  }
}
