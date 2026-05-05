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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getChatList(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: _buildMainState(theme),
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

  Widget _buildMainState(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSearchField(theme),
        ),
        const SizedBox(height: 10),

        Expanded(
          child: Obx(() {
            final chatList = controller.chatListPagination;

            if (chatList.isLoading.value) {
              return CustomShimmerWidget.list(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: 4,
                baseColor: theme.brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.grey.shade800,
                highlightColor: theme.brightness == Brightness.light
                    ? Colors.grey.shade100
                    : Colors.grey.shade700,
                width: double.infinity,
                height: Get.height * 0.08.h,
              );
            }

            if (chatList.items.isEmpty) {
              return emptyData(theme);
            }

            return NotificationListener<ScrollNotification>(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: chatList.items.length,
                separatorBuilder: (_, __) => _buildDivider(),
                itemBuilder: (_, index) {
                  final chat = chatList.items[index];
                  return ChatTile(chat: chat, controller: controller);
                },
              ),
            );
          }),
        ),

        Obx(() {
          if (controller.chatListPagination.isLoadMore.value) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: AppLoader.circular(color: AppColors.lightPrimary),
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(height: 20.h, thickness: 0.6, color: AppColors.grey200);
  }

  Widget emptyData(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: AppText(text: 'No chat Found', fontSize: 14.sp),
      ),
    );
  }
}
