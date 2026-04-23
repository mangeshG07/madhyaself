import 'package:madhya/core/exporters/app_export.dart';

class MailboxScreen extends StatefulWidget {
  const MailboxScreen({super.key});

  @override
  State<MailboxScreen> createState() => _MailboxScreenState();
}

class _MailboxScreenState extends State<MailboxScreen> {
  final controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    controller.getChatList(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: Obx(() {
        final chatList = controller.chatListPagination;

        if (chatList.isLoading.value) {
          return AppLoader.circular(color: AppColors.lightPrimary);
        }
        if (chatList.items.isEmpty) {
          return emptyData(theme);
        }
        return _buildMainState(chatList, theme);
      }),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      surfaceTintColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      centerTitle: false,
      title: AppText(
        text: 'Mailbox',
        fontSize: 22.sp,
        style: theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      // actions: [
      //   AppIconButton(
      //     onPressed: () => Get.back(),
      //     icon: HugeIcons.strokeRoundedUserLove02,
      //     iconColor: Colors.grey,
      //     backgroundColor: theme.inputDecorationTheme.fillColor,
      //   ),
      // ],
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return AppTextField(
      label: 'Search',
      showLabel: false,
      hint: 'Search',
      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
      fillColor: theme.inputDecorationTheme.fillColor,
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 6.w),
        child: Icon(Icons.search, color: Colors.grey, size: 20.sp),
      ),
    );
  }

  Widget _buildMainState(dynamic chatList, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        children: [
          _buildSearchField(theme),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll is ScrollEndNotification &&
                    scroll.metrics.pixels >=
                        scroll.metrics.maxScrollExtent - 50 &&
                    chatList.hasMore &&
                    !chatList.isLoadMore.value &&
                    !chatList.isLoading.value) {
                  controller.getChatList(showLoading: false);
                }
                return false;
              },
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                separatorBuilder: (_, __) => _buildDivider(),
                itemCount: chatList.items.length,
                itemBuilder: (_, index) {
                  final chat = chatList.items[index];
                  return ChatTile(chat: chat, controller: controller);
                },
              ),
            ),
          ),
          Obx(() {
            if (chatList.isLoadMore.value) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: AppLoader.circular(color: AppColors.lightPrimary),
              );
            }
            // else if (!controller.hasMore) {
            //   // All data loaded
            //   return Padding(
            //     padding: EdgeInsets.symmetric(vertical: 16.h),
            //     child: AppText(
            //       text: 'No more chats to show',
            //       fontSize: 14.sp,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.grey,
            //     ),
            //   );
            // }
            else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 20.h, thickness: 0.6, color: AppColors.grey200);
  }

  Widget emptyData(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildSearchField(theme),
          AppText(text: 'No chat Found', fontSize: 14.sp),
        ],
      ),
    );
  }
}
