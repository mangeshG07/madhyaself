import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../exporters/app_export.dart' hide DateFormat;
import 'package:intl/intl.dart';

launchURL(String url) async {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

String formatTime(String date) {
  DateTime dateTime = DateTime.parse(date).toLocal();
  return DateFormat('hh:mm a').format(dateTime);
}

String convertToLocalTime(String time) {
  final parsedTime = DateFormat("HH:mm:ss").parse(time);
  return DateFormat("hh:mm a").format(parsedTime);
}

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

Widget buildSectionHeader(
  String title,
  dynamic icon, {
  bool isPrimary = false,
}) {
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
          color: isPrimary ? AppColors.lightPrimary : null,
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
                      ? theme.cardColor
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
                maxLines: 4,
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

// 📦 COMMON SECTION WRAPPER
Widget buildSection(
  dynamic child,
  String title,
  dynamic icon,
  VoidCallback onTap,
  ThemeData theme, {
  bool showEdit = true,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(18.r),
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
                maxLines: 2,
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
  final isVerified = details['is_verified'].toString() == '0' ? false : true;
  return Positioned(
    left: 12.w,
    right: 12.w,
    bottom: isDetails ? Get.height * 0.09 : 12.h,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isVerified)
          SizedBox(
            width: Get.width * 0.2.w,
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
        if (details['username'].toString().isNotEmpty)
          AppText(
            text: details['username'] ?? '',
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

Future<void> openWhatsApp(String number, String msg) async {
  final formattedPhone = number.replaceAll('+', '');
  final uri = Uri.parse(
    'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(msg)}',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    Get.snackbar(
      'Error',
      'WhatsApp not installed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.orange;
    case 'Approved':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Future<void> downloadFile(String url) async {
  final fileName = Uri.parse(url).pathSegments.last;

  final task = DownloadTask(
    url: url,
    filename: fileName,
    directory: 'downloads',
  );

  final result = await FileDownloader().download(
    task,
    onProgress: (progress) {
      // print('Progress: ${(progress * 100).toStringAsFixed(0)}%');
    },
  );

  if (result.status == TaskStatus.complete) {
    final path = await task.filePath();
    await OpenFilex.open(path);
  } else {
    Get.snackbar(
      "Download Failed",
      fileName,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

String getDisplayValue({
  required String? key,
  required RxList<Map<String, String>> options,
}) {
  if (key == null || key.isEmpty) return '-';

  final map = options.first;
  return map[key] ?? key;
}

String getListValue(dynamic value) {
  if (value == null) return '-';

  if (value is List) {
    if (value.isEmpty) return '-';
    return value.join(' , ');
  }

  if (value.toString().trim().isEmpty) return '-';

  return value.toString();
}

String getValue(dynamic v) =>
    (v == null || v.toString().isEmpty) ? '-' : v.toString();

String getHeightRange(dynamic preference) {
  final from = preference['patner_height_from'];
  final to = preference['patner_height_to'];

  final isFromEmpty = from == null || from.toString().trim().isEmpty;
  final isToEmpty = to == null || to.toString().trim().isEmpty;

  if (isFromEmpty && isToEmpty) {
    return '-';
  }

  return '${from ?? '-'} to ${to ?? '-'} cm';
}

String getAgeRange(dynamic preference) {
  final from = preference['patner_age_from'];
  final to = preference['patner_age_to'];

  final isFromEmpty = from == null || from.toString().trim().isEmpty;
  final isToEmpty = to == null || to.toString().trim().isEmpty;

  if (isFromEmpty && isToEmpty) {
    return '-';
  }

  return '${from ?? '-'} to ${to ?? '-'} yrs';
}

Future<File> createFileOfPdfUrl({required var url2}) async {
  Completer<File> completer = Completer();
  try {
    final url = url2;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }
  return completer.future;
}

Future<void> downloadPDFFile(String url) async {
  // final file = await createFileOfPdfUrl(url2: url);

  showDialog(
    context: Get.context!,
    barrierDismissible: true,
    fullscreenDialog: true,
    builder: (_) {
      final content = Container(
        width: Get.width * 0.8.w,
        height: Get.height * 0.5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusGeometry.circular(12.r),
          color: Colors.white,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12.r),
              child: SfPdfViewer.network(url),
            ),
            Row(
              children: [
                AppButton(
                  text: 'Download',
                  onTap: () {},
                  backgroundColor: AppColors.lightPrimary,
                ),

                TextButton(onPressed: () => Get.back(), child: const Text('Close')),
              ],
            )
          ],
        ),
      );

      if (Platform.isIOS) {
        /// 🍎 iOS STYLE
        return CupertinoAlertDialog(
          content: content,
          actions: [
            CupertinoDialogAction(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        );
      }

      /// 🤖 ANDROID STYLE
      return AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(5),
        content: content,
        // actions: [
        //
        // ],
      );
    },
  );
}
