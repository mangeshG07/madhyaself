import 'package:madhya/core/exporters/app_export.dart';

class PartnerPreference extends StatefulWidget {
  const PartnerPreference({super.key});

  @override
  State<PartnerPreference> createState() => _PartnerPreferenceState();
}

class _PartnerPreferenceState extends State<PartnerPreference> {
  final PreferenceController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getPreference();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: Obx(
        () => controller.isLoading.isTrue
            ? AppLoader.circular(color: AppColors.lightPrimary)
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  spacing: 12.h,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AppText(
                        text:
                            'At times, we may recommend matches that go slightly beyond your preferences based on Acceptable matches criteria.',
                        fontSize: 14.sp,
                        maxLines: 5,
                        color: AppColors.lightTextLowColor,
                      ),
                    ),
                    _buildBasicDetails(theme),
                    _buildProfessionalDetails(theme),
                    _buildReligionDetails(theme),
                    _buildLocationDetails(theme),
                  ],
                ),
              ),
      ),
    );
  }

  CustomAppbar _buildAppBar(ThemeData theme) {
    return CustomAppbar(
      title: 'Partner Preference',
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
    );
  }

  Widget _buildBasicDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Marital Status',
                value: controller.preferenceDetails['marital_status'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Partner Age From',
                value: controller.preferenceDetails['patner_age_from'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Partner Age To',
                value: controller.preferenceDetails['patner_age_to'] ?? '-',
                isFill: false,
              ),
            ],
          ),

          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Partner Height From',
                value:
                    controller.preferenceDetails['patner_height_from'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Partner Height To',
                value: controller.preferenceDetails['patner_height_to'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Basic Details',
      HugeIcons.strokeRoundedUserAccount,
      () => Get.toNamed(Routes.partnerBasicDetailsEdit),
      theme,
    );
  }

  Widget _buildProfessionalDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Education Category',
                value:
                    controller.preferenceDetails['education_category_name'] ??
                    '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Education Detail',
                value: controller.preferenceDetails['education_detail'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Job Category',
                value: controller.preferenceDetails['job_category_name'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Job Detail',
                value: controller.preferenceDetails['job_detail'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Professional Info',
      HugeIcons.strokeRoundedProfile02,
      () => Get.toNamed(Routes.partnerProfessionalDetailsEdit),
      theme,
    );
  }

  Widget _buildReligionDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Religion',
                value: controller.preferenceDetails['religion'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'Caste / Community',
                value: controller.preferenceDetails['caste'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Sub Caste',
                value: controller.preferenceDetails['sub_caste'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Religion Info',
      HugeIcons.strokeRoundedWavingHand01,
      () => Get.toNamed(Routes.partnerReligionDetailsEdit),
      theme,
    );
  }

  Widget _buildLocationDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Country',
                value: controller.preferenceDetails['country'] ?? '-',
                isFill: false,
              ),
              buildDetailItem(
                label: 'State',
                value: controller.preferenceDetails['state'] ?? '-',
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'City',
                value: controller.preferenceDetails['city'] ?? '-',
                isFill: false,
              ),
            ],
          ),
        ],
      ),
      'Location',
      HugeIcons.strokeRoundedLocation05,
      () => Get.toNamed(Routes.partnerLocationDetailsEdit),
      theme,
    );
  }
}
