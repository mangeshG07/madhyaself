import 'package:madhya/core/exporters/app_export.dart';

class PartnerPreference extends StatefulWidget {
  const PartnerPreference({super.key});

  @override
  State<PartnerPreference> createState() => _PartnerPreferenceState();
}

class _PartnerPreferenceState extends State<PartnerPreference> {
  final controller = Get.find<PreferenceController>();

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
                    _buildInfoBanner(theme),
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

  // 🔹 INFO BANNER
  Widget _buildInfoBanner(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.lightPrimary),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              text:
                  'At times, we may recommend matches that go slightly beyond your preferences based on Acceptable matches criteria.',
              fontSize: 13.sp,
              maxLines: 5,
              color: AppColors.lightTextLowColor,
            ),
          ),
        ],
      ),
    );
  }

  String _val(dynamic v) =>
      (v == null || v.toString().isEmpty) ? '-' : v.toString();

  // 🔹 SAFE VALUE
  Widget _buildBasicDetails(ThemeData theme) {
    return buildSection(
      Column(
        children: [
          Row(
            children: [
              buildDetailItem(
                label: 'Marital Status',
                value: _val(controller.preferenceDetails['marital_status']),
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Partner Age From',
                value: _val(controller.preferenceDetails['patner_age_from']),
                isFill: false,
              ),
              buildDetailItem(
                label: 'Partner Age To',
                value: _val(controller.preferenceDetails['patner_age_to']),
                isFill: false,
              ),
            ],
          ),

          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Partner Height From',
                value: _val(controller.preferenceDetails['patner_height_from']),
                isFill: false,
              ),
              buildDetailItem(
                label: 'Partner Height To',
                value: _val(controller.preferenceDetails['patner_height_to']),
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
                value: _val(
                  controller.preferenceDetails['education_category_name'],
                ),
                isFill: false,
              ),
              buildDetailItem(
                label: 'Education Detail',
                value: _val(controller.preferenceDetails['education_detail']),
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Job Category',
                value: _val(controller.preferenceDetails['job_category_name']),
                isFill: false,
              ),
              buildDetailItem(
                label: 'Job Detail',
                value: _val(controller.preferenceDetails['job_detail']),
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
                value: _val(controller.preferenceDetails['religion']),
                isFill: false,
              ),
              buildDetailItem(
                label: 'Caste / Community',
                value: _val(controller.preferenceDetails['caste']),
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'Sub Caste',
                value: _val(controller.preferenceDetails['sub_caste']),
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
                value: _val(controller.preferenceDetails['country']),
                isFill: false,
              ),
              buildDetailItem(
                label: 'State',
                value: _val(controller.preferenceDetails['state']),
                isFill: false,
              ),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              buildDetailItem(
                label: 'City',
                value: _val(controller.preferenceDetails['city']),
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
