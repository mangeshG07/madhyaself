import 'package:madhya/core/exporters/app_export.dart';

class ChatUserProfile extends StatelessWidget {
  const ChatUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Get.arguments['userData'] ?? {};
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(title: 'Details'),

      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 80.r,
              backgroundColor: AppColors.grey200,
              child: ClipOval(
                child: FadeInImage(
                  placeholder: const AssetImage(AppAssets.defaultImage),
                  image: NetworkImage(
                    userData['hide_photos'].toString() == '0'
                        ? userData['profile_image'] ?? ''
                        : '',
                  ),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  fadeInDuration: const Duration(milliseconds: 300),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.person_2_rounded, size: 100.r);
                  },
                ),
              ),
            ),
            AppText(
              text: capitalizeFirst(userData['name'] ?? ''),
              fontSize: 16.sp,
            ),
            Divider(),
            Row(
              children: [
                buildDetailItem(label: 'Phone', value: '+91 XXXXX XXXXX'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
