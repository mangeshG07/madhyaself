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
          border: Border.all(color: !isLight ? theme.dividerTheme.color! : Colors.transparent,width:  0.5),
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
            _buildContent(),
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
              placeholder: const AssetImage(AppAssets.appLogo),
              image: NetworkImage(details['image'] ?? ''),
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade100,
                  child: Center(child: Icon(Icons.person, size: 40.sp)),
                );
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
        ],
      ),
    );
  }

  ///===================Content=======================

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// NAME SECTION
          AppText(
            text: details['name'] ?? '',
            fontSize: 14.sp,
            maxLines: 2,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextMidColor,
          ),
          SizedBox(height: 4.h),

          /// ID SECTION
          AppText(
            text: "ID: ${details['id'] ?? ''}",
            fontSize: 11.sp,
            maxLines: 2,
            textAlign: TextAlign.start,
            color: AppColors.lightTextLowColor,
          ),
          if (details['age'].toString().isNotEmpty)
            AppText(
              text: details['age'] ?? '',
              fontSize: 11.sp,
              textAlign: TextAlign.start,
              color: AppColors.lightTextLowColor,
            ),

          /// ADDRESS
          AppText(
            text: details['address'] ?? '',
            fontSize: 12.sp,
            maxLines: 2,
            color: AppColors.lightTextMidColor,
          ),
        ],
      ),
    );
  }
}
