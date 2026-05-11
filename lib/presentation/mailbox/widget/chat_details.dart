import 'package:madhya/core/exporters/app_export.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    final chatId = Get.arguments['id']?.toString() ?? '';
    controller.initUser();
    controller.getChatDetails(chatId, isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final chatList = controller.chatDetailsPagination;

      if (chatList.isLoading.value) {
        return Scaffold(
          body: Center(
            child: AppLoader.circular(color: AppColors.lightPrimary),
          ),
        );
      }
      return Scaffold(
        appBar: _buildAppBar(theme),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAllChat(chatList, theme),
              _buildAttachmentsPreview(),
              _buildTextField(theme),
            ],
          ),
        ),
      );
    });
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: theme.scaffoldBackgroundColor,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
      ),
      title: Obx(
        () => Row(
          spacing: 12.w,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey.shade200,
              child: CircleAvatar(
                radius: 19.r,
                backgroundColor: AppColors.grey100,
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: const AssetImage(AppAssets.defaultImage),
                    image: NetworkImage(
                      controller.userDetails['hide_photos'].toString() == '0'
                          ? controller.userDetails['profile_image'] ?? ''
                          : '',
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    fadeInDuration: const Duration(milliseconds: 300),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppAssets.defaultImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: capitalizeFirst(controller.userDetails['name'] ?? ''),
                    fontSize: 16.sp,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  Obx(() {
                    if (controller.isTyping.value) {
                      return AppText(
                        text: 'Typing...',
                        fontSize: 12.sp,
                        color: Colors.green,
                      );
                    }

                    return AppText(
                      text: controller.userDetails['is_online'] == true
                          ? 'Online'
                          : 'Offline',
                      fontSize: 12.sp,
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppIconButton(
          onPressed: () => Get.toNamed(
            Routes.chatProfileDetails,
            arguments: {'userData': controller.userDetails},
          ),
          icon: HugeIcons.strokeRoundedUser,
          iconColor: Colors.grey,
          backgroundColor: theme.inputDecorationTheme.fillColor,
        ),
      ],
    );
  }

  Widget _buildAllChat(dynamic messageList, ThemeData theme) {
    final isLight = theme.brightness == Brightness.light;
    return Expanded(
      child: RefreshIndicator(
        backgroundColor: theme.colorScheme.onSurface,
        strokeWidth: 1,
        color: AppColors.lightPrimary,
        onRefresh: () async {
          await controller.getChatDetails(
            Get.arguments['id']?.toString() ?? '',
            isRefresh: true,
          );
        },
        child: Obx(
          () => NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 50 &&
                  messageList.hasMore &&
                  !messageList.isLoadMore.value &&
                  !messageList.isLoading.value) {
                controller.getChatDetails(
                  Get.arguments['id']?.toString() ?? '',
                  showLoading: false,
                );
              }
              return false;
            },
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: messageList.items.length,
              itemBuilder: (context, index) {
                final message = messageList.items[index];
                final isMe = controller.isMe(
                  message['sender_id']?.toString() ?? '',
                );

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                    child: IntrinsicWidth(
                      child: Card(
                        elevation: isMe ? 0 : 1,
                        color: isMe
                            ? (isLight ? AppColors.grey100 : AppColors.grey800)
                            : (isLight ? Colors.white : AppColors.darkSurface),
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.5,
                            color: isLight || isMe
                                ? Colors.transparent
                                : theme.dividerTheme.color!,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if ((message['media_url'] ?? []).isNotEmpty)
                                _buildMedia(message['media_url']),

                              Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: AppText(
                                  text: message['message']?.toString() ?? '',
                                  fontSize: 13.sp,
                                  maxLines: 5,
                                  textAlign: TextAlign.start,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                spacing: 5.w,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    text: TimestampFormatter().format(
                                      DateTime.parse(
                                        message['created_at']?.toString() ?? '',
                                      ).toLocal().toString(),
                                    ),
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                  if (isMe)
                                    Icon(
                                      getStatusIcon(message['status']),
                                      size: 12.r,
                                      color: message['status'].toString() == '2'
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(ThemeData theme) {
    final isLight = theme.brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.dividerTheme.color!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              showLabel: false,
              controller: controller.msgController,
              label: 'label',
              contentPadding: const EdgeInsets.all(15),
              focusedBorder: theme.inputDecorationTheme.focusedBorder,
              enabledBorder: theme.inputDecorationTheme.enabledBorder,
              textStyle: TextStyle(color: theme.colorScheme.onSurface),
              fillColor: theme.scaffoldBackgroundColor,
              hint: 'Message',
              onChanged: (value) {
                if (value.trim().isNotEmpty) {
                  controller.onTyping(value, Get.arguments['id'].toString());
                }
              },
            ),
          ),
          SizedBox(width: 12.w),
          // AppIconButton(
          //   onPressed: () {
          //     AppFilePicker.open(
          //       config: const AppFilePickerConfig(
          //         allowMultiImage: true,
          //         allowVideo: false,
          //       ),
          //       onMultiPicked: (files) {
          //         if (files.isNotEmpty) {
          //           controller.attachments.addAll(files);
          //         }
          //       },
          //       onPicked: (file) {
          //         if (file.path.isNotEmpty) {
          //           controller.attachments.add(file);
          //         }
          //       },
          //     );
          //   },
          //   icon: HugeIcons.strokeRoundedAttachment01,
          //   backgroundColor: theme.inputDecorationTheme.fillColor,
          //   iconColor: isLight ? AppColors.lightPrimary : Colors.white,
          // ),
          Obx(
            () => controller.isSendLoading.isTrue
                ? AppLoader(size: 20.r)
                : AppIconButton(
                    icon: HugeIcons.strokeRoundedSent,
                    backgroundColor: theme.inputDecorationTheme.fillColor,
                    iconColor: isLight ? AppColors.lightPrimary : Colors.white,
                    onPressed: () async {
                      await controller.sendMessage(
                        Get.arguments['id'].toString(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsPreview() {
    return Obx(() {
      final files = controller.attachments;

      if (files.isEmpty) return const SizedBox();

      return Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _isImage(file.path)
                        ? Image.file(File(file.path), fit: BoxFit.cover)
                        : Center(child: Icon(Icons.insert_drive_file)),
                  ),
                ),

                /// ❌ Remove Button
                Positioned(
                  right: 5,
                  top: -5,
                  child: GestureDetector(
                    onTap: () {
                      controller.attachments.removeAt(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  bool _isImage(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.png') ||
        ext.endsWith('.jpg') ||
        ext.endsWith('.jpeg') ||
        ext.endsWith('.webp');
  }

  Widget _buildMedia(List mediaList) {
    return Column(
      children: mediaList.map<Widget>((url) {
        final isImage = _isImage(url);

        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: isImage
                ? Image.network(
                    url,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 180,
                        height: 180,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50);
                    },
                  )
                : Container(
                    width: 180,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.insert_drive_file),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            url.split('/').last,
                            overflow: TextOverflow.ellipsis,
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
}
