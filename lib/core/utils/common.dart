import '../exporters/app_export.dart' hide DateFormat;
import 'package:intl/intl.dart';

Widget buildBackgroundImage(ThemeData theme) {
  final isDark = theme.brightness == Brightness.dark;
  return IgnorePointer(
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.1),
        child: Image.asset(
          isDark ? AppAssets.bgImageDark : AppAssets.bgImage,
          height: Get.height * 0.35,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget buildTitle(String title) {
  return AppText(
    text: title,
    fontSize: 32.sp,
    textAlign: TextAlign.start,
    maxLines: 2,
    style: TextStyle(
      fontFamily: GoogleFonts.ebGaramond().fontFamily,
      fontSize: 32.sp,
      fontWeight: FontWeight.w400,
      height: 1,
    ),
  );
}

Widget buildSubTitle(String subTitle, ThemeData theme) {
  return AppText(
    text: subTitle,
    fontSize: 14.sp,
    maxLines: 4,
    textAlign: TextAlign.start,
    style: theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.lightTextLowColor,
    ),
  );
}

Widget buildGenderCard(
  bool isSelected,
  String gender,
  dynamic icon,
  ThemeData theme,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: theme.cardColor,
      border: Border.all(
        color: isSelected ? AppColors.lightPrimary : theme.cardColor,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      spacing: 8.w,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(
          icon: icon,
          color: isSelected ? AppColors.lightPrimary : Colors.grey,
        ),
        Text(
          gender,
          style: TextStyle(
            color: isSelected ? AppColors.lightPrimary : Colors.grey,
          ),
        ),
      ],
    ),
  );
}

void showError(String message) {
  Get.snackbar(
    "Error",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade50,
    colorText: Colors.red,
    margin: EdgeInsets.all(12),
    borderRadius: 8,
  );
}

Widget buildHeadingWithButton({
  required String title,
  required String rightText,
  required var onTap,
  bool showRight = true,
  required ThemeData theme,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        style: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      if (showRight)
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: GestureDetector(
            onTap: onTap,
            child: AppText(
              text: rightText,
              fontSize: 12.sp,
              color: AppColors.lightTextLowColor,
            ),
          ),
        ),
    ],
  );
}

Widget badge(
  String text,
  Color color,
  dynamic icon, {
  bool isBgWhite = false,
  Color bgColor = Colors.transparent,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: isBgWhite == true ? bgColor : color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HugeIcon(icon: icon, size: 12.sp, color: color),
        SizedBox(width: 4.w),
        AppText(
          text: text,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ],
    ),
  );
}

Widget buildSectionHeader(String title, dynamic icon) {
  final theme = Theme.of(Get.context!);
  final isLight = theme.brightness == Brightness.light;
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isLight
              ? AppColors.lightPrimary.withValues(alpha: 0.1)
              : AppColors.lightPink.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: HugeIcon(
          icon: icon,
          size: 18.r,
          color: isLight ? AppColors.lightPrimary : Colors.white,
        ),
      ),
      SizedBox(width: 10.w),
      AppText(
        text: title,
        fontSize: 16.sp,
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget buildDetailItem({
  required String label,
  required String value,
  bool isFill = true,
}) {
  final theme = Theme.of(Get.context!);
  return Expanded(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          margin: EdgeInsets.symmetric(vertical: 8.h).copyWith(top: 20),
          decoration: BoxDecoration(
            color: isFill
                ? Get.isDarkMode
                      ? AppColors.grey700
                      : AppColors.grey100
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: !isFill
                  ? Get.isDarkMode
                        ? AppColors.grey700
                        : AppColors.grey300
                  : Colors.transparent,
              width: 0.5.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: label,
                textAlign: TextAlign.start,
                fontSize: 12.sp,
                maxLines: 2,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.brightness == Brightness.light
                      ? AppColors.grey600
                      : AppColors.grey500,
                ),
              ),
              SizedBox(height: 2.h),
              AppText(
                text: value.isEmpty ? "-" : value,
                fontSize: 14.sp,
                style: theme.textTheme.labelLarge,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildSection(
  dynamic child,
  String title,
  dynamic icon,
  dynamic onTap,
  ThemeData theme, {
  bool showEdit = true,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        theme.brightness == Brightness.light
            ? BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            : BoxShadow(
                color: Colors.white.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? AppColors.lightPrimary.withValues(alpha: 0.05)
                    : AppColors.lightPink.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: HugeIcon(
                icon: icon,
                color: theme.brightness == Brightness.light
                    ? AppColors.lightPrimary
                    : Colors.white,
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText(
                text: title,
                fontSize: 14.sp,
                style: theme.textTheme.bodyLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showEdit)
              GestureDetector(
                onTap: onTap,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedEdit02,
                  size: 20.r,
                  color: theme.brightness == Brightness.light
                      ? AppColors.lightTextMidColor
                      : Colors.white,
                ),
              ),
          ],
        ),
        child,
      ],
    ),
  );
}

Widget toggleItem({
  required String title,
  required bool isSelected,
  required bool isLight,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(Get.context!).scaffoldBackgroundColor
              : isLight
              ? AppColors.grey100
              : AppColors.grey900,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? Theme.of(Get.context!).dividerTheme.color!
                : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.lightPrimary : Colors.grey,
            ),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    ),
  );
}

Widget buildGradientOverlay() {
  return Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            AppColors.lightMidPrimary,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
    ),
  );
}

Widget buildContentOverlay(dynamic details, bool isDetails) {
  final isVerified = details['is_verified'] == true;
  return Positioned(
    left: 12.w,
    right: 12.w,
    bottom: isDetails ? 50.h : 12.h,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isVerified)
          SizedBox(
            width: Get.width * 0.2,
            child: badge(
              bgColor: Colors.white,
              isBgWhite: true,
              "Verified",
              AppColors.lightPrimary,
              HugeIcons.strokeRoundedCheckmarkBadge01,
            ),
          ),

        AppText(
          text: details['name'] ?? '',
          fontSize: 16.sp,
          maxLines: 2,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        if (details['id'].toString().isNotEmpty)
          AppText(
            text: "ID: ${details['id'] ?? ''}",
            fontSize: 12.sp,
            maxLines: 2,
            textAlign: TextAlign.start,
            color: Colors.white,
          ),
        AppText(
          text: getAgeJob(details),
          fontSize: 12.sp,
          maxLines: 2,
          textAlign: TextAlign.start,
          color: Colors.white,
        ),
        AppText(
          text: getAddress(details),
          fontSize: 12.sp,
          maxLines: 2,
          textAlign: TextAlign.start,
          color: Colors.white,
        ),
      ],
    ),
  );
}

String getAddress(dynamic match) {
  final city = (match['city'] ?? '').toString().trim();
  final state = (match['state'] ?? '').toString().trim();

  if (city.isEmpty && state.isEmpty) {
    return '';
  } else if (city.isNotEmpty && state.isNotEmpty) {
    return '$city, $state';
  } else {
    return city.isNotEmpty ? city : state;
  }
}

String getAgeJob(dynamic match) {
  final age = (match['age'] ?? '').toString().trim();
  final job = (match['job_details'] ?? '').toString().trim();

  if (age.isEmpty && job.isEmpty) {
    return '';
  } else if (age.isNotEmpty && job.isNotEmpty) {
    return '$age yrs, $job';
  } else if (age.isNotEmpty) {
    return '$age yrs';
  } else {
    return job;
  }
}

String capitalizeFirst(String text) {
  if (text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1);
}

IconData getStatusIcon(String? status) {
  switch (status) {
    case '0':
      return Icons.check; // ✔
    case '1':
      return Icons.done_all; // ✔✔
    case '2':
      return Icons.done_all; // blue ✔✔
    default:
      return Icons.access_time;
  }
}

String formatDate(String inputDate) {
  DateTime parsedDate = DateTime.parse(inputDate);
  String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
  return formattedDate;
}
