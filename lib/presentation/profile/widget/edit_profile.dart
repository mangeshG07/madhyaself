import 'package:madhya/core/exporters/app_export.dart';
import 'package:widget_zoom/widget_zoom.dart';

class EditProfile extends GetView<ProfileController> {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        title: 'Edit Profile',
        backgroundColor: theme.brightness == Brightness.light
            ? AppColors.bgColor
            : theme.scaffoldBackgroundColor,
      ),
      body: Obx(
        () => controller.isLoading.isTrue
            ? AppLoader.circular(color: AppColors.lightPrimary)
            : RefreshIndicator(
                onRefresh: () async => await controller.getProfile(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Obx(
                    () => Column(
                      spacing: 12.h,
                      children: [
                        _buildProfileImage(theme),
                        _buildBasicDetails(theme),
                        _buildAboutMe(theme),
                        _buildProfessionalDetails(theme),
                        _buildReligionDetails(theme),
                        _buildLocationDetails(theme),
                        _buildFamilyDetails(theme),
                        _buildHoroscopeDetails(theme),
                        _buildPhotosDetails(theme),
                        SafeArea(
                          child: AppButton(
                            text: 'Delete Account',
                            backgroundColor: AppColors.lightPrimary,
                            onTap: () => Get.toNamed(Routes.deleteScreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // 🖼️ PROFILE IMAGE
  Widget _buildProfileImage(ThemeData theme) {
    final image = controller.profileDetails['profile_image'] ?? '';
    return Center(
      child: CircleAvatar(
        radius: 52.r,
        backgroundColor: Colors.grey.shade400,
        child: CircleAvatar(
          radius: 50.r,
          backgroundColor: AppColors.grey100,
          child: ClipOval(
            child: FadeInImage(
              placeholder: const AssetImage(AppAssets.defaultImage),
              image: NetworkImage(image),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              fadeInDuration: const Duration(milliseconds: 300),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppAssets.defaultImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 BASIC DETAILS
  Widget _buildBasicDetails(ThemeData theme) {
    final details = controller.profileDetails;
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Name',
                value: details['name'] ?? '',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Gender',
                value: details['gender'].toString() == '0' ? "Male" : 'Female',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Age',
                value: details['age'] ?? '',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Marital Status',
                value: details['marital_status'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Height',
                value: details['height'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Profile Created For',
                value: details['profile_created_for'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Mobile Number',
                value: details['mobile_no'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Basic Details',
      HugeIcons.strokeRoundedUserAccount,
      () => Get.toNamed(Routes.basicDetailsEdit),
      theme,
    );
  }

  // 📝 ABOUT
  Widget _buildAboutMe(ThemeData theme) {
    return buildSection(
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.r),
        margin: EdgeInsets.symmetric(vertical: 8.r),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor, width: 0.2.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: AppText(
          maxLines: 20,
          text: controller.profileDetails['about'] ?? '-',
          fontSize: 13.sp,
          style: theme.textTheme.bodyMedium!.copyWith(fontSize: 13.sp),
        ),
      ),
      'About Me',
      HugeIcons.strokeRoundedProfile,
      () => Get.toNamed(Routes.aboutMeEdit),
      theme,
    );
  }

  // 💼 PROFESSIONAL
  Widget _buildProfessionalDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Education Category',
                value: controller.profileDetails['education_category'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Education Detail',
                value: controller.profileDetails['education_details'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Job Category',
                value: controller.profileDetails['job_category'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Job Details',
                value: controller.profileDetails['job_details'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Annual Income',
                value: controller.profileDetails['annual_income'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Professional Info',
      HugeIcons.strokeRoundedProfile02,
      () => Get.toNamed(Routes.professionalDetailsEdit),
      theme,
    );
  }

  // 💼 RELIGION
  Widget _buildReligionDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Religion',
                value: controller.profileDetails['religion'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Caste / Community',
                value: controller.profileDetails['caste'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Sub Caste',
                value: controller.profileDetails['subCaste'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Religion Info',
      HugeIcons.strokeRoundedWavingHand01,
      () => Get.toNamed(Routes.religionDetailsEdit),
      theme,
    );
  }

  // 🌍 LOCATION
  Widget _buildLocationDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Country',
                value: controller.profileDetails['country'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'State',
                value: controller.profileDetails['state'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'City',
                value: controller.profileDetails['city'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Location',
      HugeIcons.strokeRoundedLocation05,
      () => Get.toNamed(Routes.locationDetailsEdit),
      theme,
    );
  }

  // 👨‍👩‍👧 FAMILY
  Widget _buildFamilyDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: "Father's Name",
                value: controller.profileDetails['father_name'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: "Father's Job",
                value: controller.profileDetails['father_job'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: "Mother's Name",
                value: controller.profileDetails['mothers_name'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: "Mother's Job",
                value: controller.profileDetails['mothers_job'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Siblings Details',
                value: controller.profileDetails['siblling_details'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Family Details',
      HugeIcons.strokeRoundedUserMultiple02,
      () => Get.toNamed(Routes.familyDetailsEdit),
      theme,
    );
  }

  // ✋ HOROSCOPE
  Widget _buildHoroscopeDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Birth Time',
                value: controller.profileDetails['birthtime'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Birth Date',
                value: formatDate(
                  controller.profileDetails['birth_date'] ?? '-',
                ),
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Star/rasi',
                value: controller.profileDetails['rasi'] ?? '-',
                isFill: false,
              ),
              WidgetZoom(
                heroAnimationTag:
                    'tag ${controller.profileDetails['horoscope_photo']}',
                zoomWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.grey400, width: 0.2.w),
                  ),

                  child: FadeInImage(
                    placeholder: const AssetImage(AppAssets.defaultImage),
                    image: NetworkImage(
                      controller.profileDetails['horoscope_photo'] ?? '',
                    ),
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                    fadeInDuration: const Duration(milliseconds: 300),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppAssets.defaultImage,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      'Horoscope Details',
      HugeIcons.strokeRoundedStar,
      () => Get.toNamed(Routes.horoscopeDetailsEdit),
      theme,
    );
  }

  // 📸 PHOTOS
  Widget _buildPhotosDetails(ThemeData theme) {
    final photos = controller.profileDetails['photos'] ?? [];
    if (photos.isEmpty) return const SizedBox();

    return buildSection(
      showEdit: false,
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: AttachmentPreviewList(
          attachments: List<String>.from(photos),
          config: AttachmentPreviewConfig(showDownload: false),
          onDownload: (_) {},
        ),
      ),
      'Images',
      HugeIcons.strokeRoundedAlbum02,
      () {},
      theme,
    );
  }
}
