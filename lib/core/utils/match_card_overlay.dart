import '../exporters/app_export.dart';

class MatchCardOverlay extends StatelessWidget {
  final dynamic details;
  final bool isDetails;
  const MatchCardOverlay({
    super.key,
    required this.details,
    this.isDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.othersProfile,
        arguments: {'id': details['id']?.toString() ?? ''},
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: FadeInImage(
                placeholder: AssetImage(AppAssets.defaultImage),
                image: NetworkImage(details['profile_image'] ?? ''),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Image.asset(AppAssets.defaultImage, height: 40.h),
                    ),
                  );
                },
              ),
            ),
            buildGradientOverlay(),
            buildContentOverlay(details ?? {}, isDetails),
          ],
        ),
      ),
    );
  }
}
