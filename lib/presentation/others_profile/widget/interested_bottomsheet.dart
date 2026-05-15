import '../../../core/exporters/app_export.dart';

class InterestOptionsList extends StatelessWidget {
  final int? selectedValue;
  final ValueChanged<int?> onChanged;
  final List items;
  final InterestController controller;
  final dynamic onSubmit;
  final bool isUnlocked;

  const InterestOptionsList({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    required this.controller,
    required this.onSubmit,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(
      () => RadioGroup<int>(
        groupValue: selectedValue,
        onChanged: onChanged,

        child: controller.isPremium.value ? _buildBefore(theme) : _locked(),

        // controller.isSuccess.value
        //     ? _buildSuccess() // ✅ after success
        //     : _buildBefore(theme),
      ),
    );
  }

  ///=======================OPTIONS===========================///
  Widget _buildBefore(ThemeData theme) {
    return Column(
      children: [
        _buildTitle(theme),
        _buildOptions(theme),
        Obx(
          () => controller.isSending.isTrue
              ? AppLoader.circular(
                  color: AppColors.lightPrimary,
                  strokeWidth: 2.5,
                  size: 22.r,
                )
              : AppButton(
                  text: 'Submit',
                  onTap: selectedValue == null ? null : onSubmit,
                  backgroundColor: selectedValue == null
                      ? AppColors.grey300
                      : AppColors.lightPrimary,
                ),
        ),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Send Interest',
                  fontSize: 16.sp,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppText(
                  text: 'Choose a message',
                  fontSize: 14.sp,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: AppColors.lightTextLowColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 20.sp,
              color: theme.dividerTheme.color,
            ),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(ThemeData theme) {
    return Column(
      children: items.map((item) {
        final isSelected = item.id == selectedValue;

        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: GestureDetector(
            onTap: () => onChanged(item.id),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.lightPrimary
                      : AppColors.grey200,
                  width: isSelected ? 1.5 : 1,
                ),
                color: isSelected
                    ? AppColors.lightPrimary.withValues(alpha: 0.05)
                    : theme.colorScheme.surface,
              ),
              child: Row(
                children: [
                  /// 🔘 NEW RADIO (NO groupValue / onChanged here)
                  Radio<int>(
                    value: item.id,
                    side: BorderSide(color: AppColors.grey400),
                    activeColor: AppColors.lightPrimary,
                  ),

                  SizedBox(width: 8.w),

                  /// 📝 TEXT
                  Expanded(
                    child: AppText(
                      text: item.text,
                      fontSize: 14.sp,
                      maxLines: 5,
                      textAlign: TextAlign.start,
                      color: AppColors.lightTextMidColor,
                      style: theme.textTheme.titleSmall,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  ///==========================SUCCESS==========================///
  Widget _buildSuccess() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 16.h,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedCheckmarkBadge01,
            size: Get.width * 0.25.r,
            color: AppColors.lightPrimary,
          ),
          AppText(
            text: 'Interest Sent Successfully ❤️',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
          AppText(
            text:
                'Your request has been delivered.\nOnce accepted, you can start chatting.️',
            fontSize: 14.sp,
            maxLines: 10,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            color: AppColors.lightTextMidColor,
          ),
          AppButton(
            text: 'Got It',
            onTap: () => Get.back(),
            backgroundColor: AppColors.lightPrimary,
          ),
        ],
      ),
    );
  }

  ///==========================LOCKED==========================///
  Widget _locked() {
    return Column(
      children: [
        BottomSheetHeader(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedSquareUnlock02,
            size: 60.r,
            color: AppColors.lightPrimary,
          ),
          title: 'Unlock Send Interest',
          subtitle: 'Upgrade your membership to send interest this profile.',
        ),
        SizedBox(height: 20.h),
        AppButton(
          text: 'Upgrade',
          onTap: () {
            Get.back();
            Get.toNamed(Routes.packageScreen);
          },
          backgroundColor: AppColors.lightPrimary,
        ),
      ],
    );
  }
}
