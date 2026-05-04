import '../exporters/app_export.dart';

class CompactCard extends StatelessWidget {
  final dynamic details;
  final VoidCallback? onTap;
  const CompactCard({super.key, this.onTap, required this.details});

  @override
  Widget build(BuildContext context) {
    final isVerified = details['isVerified'] == true;
    final isPremium = details['isPremium'] == true;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 0.5.sw - 16.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: !isLight ? theme.dividerTheme.color! : Colors.transparent,
            width: 0.5,
          ),
          boxShadow: [
            if (isLight)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4.r,
                offset: const Offset(0, 1),
              )
            else
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.06),
                blurRadius: 4.r,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImage(isVerified, isPremium),

            /// CONTENT SECTION
            _buildContent(isLight),
          ],
        ),
      ),
    );
  }

  ///===================Image=======================

  Widget _buildImage(bool isVerified, bool isPremium) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: FadeInImage(
              placeholder: const AssetImage(AppAssets.defaultImage),
              image: NetworkImage(
                details['isHide'] == true ? '' : details['image'] ?? '',
              ),
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(AppAssets.defaultImage);
              },
            ),
          ),

          /// BADGES (FIXED ✅)
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isVerified)
                  Padding(
                    padding: EdgeInsets.only(right: 4.h),
                    child: badge(
                      "Verified",
                      AppColors.lightPrimary,
                      HugeIcons.strokeRoundedCheckmarkBadge01,
                    ),
                  ),
                if (isPremium)
                  badge(
                    "Premium",
                    AppColors.lightSecondary,
                    HugeIcons.strokeRoundedCrown02,
                  ),
              ],
            ),
          ),

          if (details['matchPercent'].toString() != "0" &&
              details['matchPercent'] != null)
            Positioned(
              top: 8,
              left: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text:
                                '${details['matchPercent']?.toString() ?? '0'} % Match',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          // SizedBox(width: 4.w),
                          // HugeIcon(
                          //   icon: HugeIcons.strokeRoundedPercent,
                          //   size: 10.sp,
                          //   color: Colors.white,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _hasData(dynamic value) {
    return value != null && value.toString().trim().isNotEmpty;
  }

  ///===================Content=======================

  Widget _buildContent(bool isLight) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// NAME SECTION
          if (_hasData(details['name']))
            AppText(
              text: details['name'] ?? '',
              fontSize: 14.sp,
              maxLines: 2,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w600,
              color: isLight ? AppColors.lightTextMidColor : Colors.white,
            ),
          if (_hasData(details['username'])) ...[
            SizedBox(height: 4.h),
            AppText(
              text: details['username'],
              fontSize: 11.sp,
              maxLines: 1,
              color: AppColors.lightTextLowColor,
            ),
          ],
          if (_hasData(details['age'])) ...[
            SizedBox(height: 2.h),
            AppText(
              text: details['age'],
              fontSize: 11.sp,
              maxLines: 2,
              color: AppColors.lightTextLowColor,
            ),
          ],

          /// ADDRESS
          if (_hasData(details['address']))
            AppText(
              text: details['address'] ?? '',
              fontSize: 12.sp,
              maxLines: 2,
              color: isLight ? AppColors.lightTextMidColor : Colors.white,
            ),
        ],
      ),
    );
  }
}
