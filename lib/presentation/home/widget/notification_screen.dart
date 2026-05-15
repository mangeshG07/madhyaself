import '../../../core/exporters/app_export.dart' hide DateFormat;

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final controller = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getNotificationList(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: 'Notifications'),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return _buildShimmerLoader(theme);
        }

        if (controller.items.isEmpty) {
          return _buildEmptyState(theme);
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent &&
                controller.hasMore &&
                !controller.isLoadMore.value &&
                !controller.isLoading.value) {
              controller.getNotificationList(showLoading: false);
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final notification = controller.items[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () async {
                          try {
                            // Mark the notification as read
                            final notificationId = notification['id']
                                ?.toString();

                            // Safely get notification data
                            final data =
                                notification['data'] as Map<String, dynamic>? ??
                                {};

                            // Handle actions
                            final action = notification['action']?.toString();
                            switch (action) {
                              case 'external_url':
                                final url = data['url']?.toString();
                                if (url != null && url.isNotEmpty) {
                                  launchInBrowser(Uri.parse(url));
                                }
                                break;

                              case 'open_profile':
                                final id = data['profile_id']?.toString();
                                if (id != null && id.isNotEmpty) {
                                  Get.toNamed(
                                    Routes.othersProfile,
                                    arguments: {'id': id, 'source': 'matches'},
                                  );
                                }
                                break;

                              case 'open_chat':
                                final id = data['conversation_id']?.toString();
                                if (id != null && id.isNotEmpty) {
                                  Get.toNamed(
                                    Routes.chatDetails,
                                    arguments: {'id': id},
                                  );
                                }
                                break;

                              case 'document_verification':
                                Get.toNamed(Routes.managePhotos);
                                break;

                              case 'interest_received':
                                Get.toNamed(Routes.interest);
                                break;
                              // Add more actions here if needed
                              case 'interest_accepted':
                                Get.toNamed(Routes.interest);
                                break;
                              default:
                                break;
                            }
                            if (notificationId != null) {
                              await controller.readNotification(notificationId);
                            }
                          } catch (e) {
                            // Optional: handle exceptions
                            // debugPrint('Error handling notification: $e');
                          }
                        },
                      );
                    },
                  ),
                  controller.items.isEmpty ? const SizedBox() : buildLoader(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildLoader() {
    if (controller.isLoadMore.value) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppLoader.circular(
          color: AppColors.lightPrimary,
          strokeWidth: 2.0,
        ),
      );
    } else if (!controller.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('No more data')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImage(
            image: AppAssets.emptyNotification,
            width: Get.width * 0.4,
          ),
          SizedBox(height: 16.sp),
          Text(
            'No Notifications!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.sp),
          const Text(
            'You don\'t have any notifications yet.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader(ThemeData theme) {
    return CustomShimmerWidget.list(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: 8,
      width: double.infinity,
      height: Get.height * 0.08.h,
      baseColor: theme.brightness == Brightness.light
          ? Colors.grey.shade300
          : Colors.grey.shade800,
      highlightColor: theme.brightness == Brightness.light
          ? Colors.grey.shade100
          : Colors.grey.shade700,
    );
  }
}

class NotificationTile extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRead = notification['is_read'].toString() == '1';
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: isRead
            ? theme.scaffoldBackgroundColor
            : isLight
            ? AppColors.lightPink.withValues(alpha: 0.5)
            : theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isRead
                    ? theme.dividerTheme.color!
                    : isLight
                    ? AppColors.lightBorderPink
                    : theme.dividerTheme.color!,
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon/Image with status indicator
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: !isRead
                            ? Colors.transparent
                            : Colors.grey.shade100,
                        border: Border.all(
                          color: !isRead
                              ? AppColors.lightBorderPink
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        !isRead
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_rounded,
                        color: !isRead
                            ? AppColors.lightMidPrimary
                            : Colors.grey.shade600,
                        size: 20.r,
                      ),
                    ),
                    if (!isRead)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 12.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: AppColors.lightBorderPink,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5.w,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title with read status
                                AppText(
                                  text: notification['title'] ?? '-',
                                  fontSize: 14.sp,
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w700,
                                    color: isRead
                                        ? isLight
                                              ? Colors.grey.shade800
                                              : AppColors.grey500
                                        : isLight
                                        ? AppColors.lightMidPrimary
                                        : Colors.white,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                ),

                                const SizedBox(height: 2),

                                // Body text
                                if (notification['body'].toString().isNotEmpty)
                                  AppText(
                                    text: notification['body'] ?? '',
                                    fontSize: 13.sp,
                                    style: theme.textTheme.bodySmall,
                                    maxLines: 2,
                                  ),
                                const SizedBox(height: 4),
                                if (notification['created_on_date']
                                    .toString()
                                    .isNotEmpty)
                                  AppText(
                                    text: formatTime(
                                      notification['created_on_date'] ?? '',
                                    ),
                                    fontSize: 10.sp,
                                    style: theme.textTheme.labelSmall!.copyWith(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Time and quick actions
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AppText(
                                text: TimestampFormatter().format(
                                  DateTime.parse(
                                    notification['created_on_date'] ?? '',
                                  ).toLocal().toString(),
                                ),
                                fontSize: 10.sp,
                                style: theme.textTheme.labelSmall!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Quick action button for unread notifications
                              if (!isRead) _buildNewTag(theme),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewTag(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.lightBorderPink),
      ),
      child: AppText(
        text: 'New',
        fontSize: 10.sp,
        style: theme.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.lightMidPrimary,
        ),
      ),
    );
  }
}
