import '../../../core/exporters/app_export.dart';

class ContactBottomsheet extends StatelessWidget {
  final bool isUnlocked;
  final String contactNumber;
  final String whatsappNumber;

  const ContactBottomsheet({
    super.key,
    this.isUnlocked = false,
    required this.contactNumber,
    required this.whatsappNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: isUnlocked ? _details() : _locked(),
    );
  }

  Widget _locked() {
    return Column(
      children: [
        BottomSheetHeader(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedSquareUnlock02,
            size: 60.r,
            color: AppColors.lightPrimary,
          ),
          title: 'Unlock Contact Details',
          subtitle:
              'Upgrade your membership to view the mobile\nnumber and connect directly with this profile.',
        ),
        SizedBox(height: 20.h),
        AppButton(
          text: 'Upgrade',
          onTap: () {},
          backgroundColor: AppColors.lightPrimary,
        ),
      ],
    );
  }

  Widget _details() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        SizedBox(height: 12.h),
        if (contactNumber.isNotEmpty)
          _contactCard(
            'Mobile: +91 $contactNumber',
            HugeIcons.strokeRoundedSmartPhone01,
          ),
        SizedBox(height: 10.h),
        if (whatsappNumber.isNotEmpty)
          _contactCard(
            'Alternate: +91 $whatsappNumber',
            HugeIcons.strokeRoundedCall,
          ),
        SizedBox(height: 20.h),
        AppButton(
          text: 'Got It',
          onTap: Get.back,
          backgroundColor: AppColors.lightPrimary,
        ),
      ],
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Contact Details',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        AppText(
          text: 'Connect directly using the details below.',
          fontSize: 13.sp,
          color: AppColors.lightTextLowColor,
        ),
      ],
    );
  }

  Widget _contactCard(String title, dynamic icon) {
    final theme = Theme.of(Get.context!);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerTheme.color!),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, size: 18.r),
          SizedBox(width: 10.w),
          Expanded(
            child: AppText(
              text: title,
              fontSize: 14.sp,
              style: theme.textTheme.titleSmall!.copyWith(
                color: theme.brightness == Brightness.light
                    ? AppColors.lightTextMidColor
                    : AppColors.grey500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
