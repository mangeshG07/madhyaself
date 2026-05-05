import '../../../core/exporters/app_export.dart';

class ChatTile extends StatelessWidget {
  final dynamic chat;
  final ChatController controller;

  const ChatTile({super.key, required this.chat, required this.controller});

  @override
  Widget build(BuildContext context) {
    final unread = chat['unread_count'] ?? 0;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.chatDetails,
        arguments: {'id': chat['conversation_id']?.toString() ?? ''},
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            _avatar(theme),

            SizedBox(width: 12.w),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME + TIME
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: chat['name'] ?? '',
                          fontWeight: unread > 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 14.sp,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        TimestampFormatter().format(chat['last_message_time']),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: unread > 0
                              ? AppColors.lightPrimary
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  /// MESSAGE + UNREAD
                  Obx(() {
                    final isTyping =
                        controller.typingUsers[chat['conversation_id']
                                ?.toString() ??
                            ''] ??
                        false;

                    return Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: isTyping
                                ? 'Typing...'
                                : (chat['last_message'] ?? 'No message'),
                            fontSize: 12.sp,
                            color: isTyping
                                ? Colors.green
                                : Colors.grey.shade700,
                            maxLines: 1,
                            fontWeight: isTyping
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),

                        if (!isTyping && unread > 0) ...[
                          SizedBox(width: 8.w),
                          _unreadBadge(unread),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(ThemeData theme) {
    return CircleAvatar(
      radius: 26.r,
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.grey200
          : AppColors.grey800,
      child: ClipOval(
        child: CachedNetworkImage(
          width: 52.w,
          height: 52.h,
          fit: BoxFit.cover,
          imageUrl: chat['hide_photos'] == '1'
              ? ''
              : chat['profile_image'] ?? '',
          placeholder: (_, __) => Image.asset(AppAssets.defaultImage),
          errorWidget: (_, __, ___) => Image.asset(AppAssets.defaultImage),
        ),
      ),
    );
  }

  Widget _unreadBadge(int count) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: AppColors.lightPrimary,
        shape: BoxShape.circle,
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
