import 'package:madhya/core/exporters/app_export.dart';
import '../../../core/component/socket_service.dart' as socket_service;

class ChatController extends GetxController {
  final ChatListUsecase usecase;
  final ChatDetailsUsecase detailsUsecase;
  final SendMsgUsecase sendMsgUsecase;
  final MsgDeliveredUsecase msgDeliveredUsecase;
  final MsgReadUsecase msgReadUsecase;
  final TypingUsecase typingUsecase;
  final CreateChatUsecase createChatUsecase;

  ChatController(
    this.usecase,
    this.detailsUsecase,
    this.sendMsgUsecase,
    this.msgDeliveredUsecase,
    this.msgReadUsecase,
    this.createChatUsecase,
    this.typingUsecase,
  );

  final msgController = TextEditingController();

  ///===============================CHAT LIST====================================///

  final chatListPagination = PaginationState<dynamic>();
  final chatDetailsPagination = PaginationState<dynamic>();
  final userDetails = {}.obs;
  String userId = '';
  final nextCursor = RxnString();
  final isCreating = false.obs;
  RxString creatingChatId = ''.obs;

  Future<void> createChat(String partTwoId) async {
    final userId = await SecureStorageService.read('user_id') ?? '';

    /// 🔥 OR fallback API
    try {
      isCreating(true);
      creatingChatId.value = partTwoId;
      final res = await createChatUsecase.call(
        CreateChatRequest(userId, partTwoId),
      );

      if (res['common']['status'] == true) {
        Get.toNamed(
          Routes.chatDetails,
          arguments: {'id': res['data']['conversation_id']?.toString() ?? ''},
        );
      }
    } catch (_) {
    } finally {
      isCreating(false);
      creatingChatId.value = '';
    }
  }

  Future<void> getChatList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) {
      chatListPagination.reset();
    }

    chatListPagination.startLoading(showLoading: showLoading);

    final userId = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await usecase.call(UserRequest(userId));

      if (response['common']['status'] == true) {
        final List list = response['data'] ?? [];

        chatListPagination.handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      chatListPagination.stopLoading();
    }
  }

  Future<void> getChatDetails(
    String convId, {
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) {
      chatDetailsPagination.reset();
      nextCursor.value = null;
      chatDetailsPagination.hasMore = true;
    }

    if (!chatDetailsPagination.hasMore) return;

    chatDetailsPagination.startLoading(showLoading: showLoading);

    final userId = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await detailsUsecase.call(
        ChatDetailsRequest(
          userId,
          convId,
          nextCursor: nextCursor.value?.toString() ?? '',
        ),
      );

      if (response['common']['status'] == true) {
        final List list = response['data']['messages'] ?? [];

        nextCursor.value = response['data']['next_cursor']?.toString() ?? '';
        chatDetailsPagination.hasMore = response['data']['has_more'] ?? false;
        if (chatDetailsPagination.currentPage == 1) {
          userDetails.assignAll(response['data']['user'] ?? {});
          connectSocket(convId);
        }
        chatDetailsPagination.handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      chatDetailsPagination.stopLoading();
    }
  }

  Future<void> initUser() async {
    userId = await SecureStorageService.read('user_id') ?? '';
  }

  bool isMe(String id) {
    return userId == id;
  }

  ///=============================== WEBSOCKET ====================================///
  final isTyping = false.obs;
  final socketStatus = socket_service.SocketStatus.connecting.obs;
  final attachments = <File>[].obs;

  void connectSocket(String convId, {bool isGlobal = false}) async {
    socket_service.connect(convId, isGlobal: isGlobal);

    socket_service.onStatusChange = (status) async {
      socketStatus.value = status;
    };

    socket_service.onEvent = (event, data) {
      switch (event) {
        /// ================= MESSAGE =================
        case 'message.sent':
          _handleIncomingMessage(data);
          break;

        /// ================= STATUS =================
        case 'message.status':
          _handleStatusUpdate(data);
          break;

        /// ================= TYPING =================
        case 'user.typing':
          _handleTyping(data);
          onTypingEvent(data);
          break;
      }
    };
  }

  void _handleIncomingMessage(Map data) async {
    final userId = await SecureStorageService.read('user_id') ?? '';

    /// ✅ mark delivered only for received msg
    if (data['receiver_id'].toString() == userId) {
      await msgDelivered(data['conversation_id'].toString());
    }

    /// IGNORE OWN MESSAGE
    // if (data['sender_id'].toString() == userId.toString()) return;

    _addMessageIfNotExists(data);
  }

  void _handleStatusUpdate(Map data) async {
    final newStatus = data['status'].toString();
    bool updated = false;

    dynamic rawMessages = data['messages'];

    /// ✅ CASE 1: messages list available
    if (rawMessages.isNotEmpty) {
      for (var id in rawMessages) {
        final index = chatDetailsPagination.items.indexWhere(
          (e) => e['message_id'].toString() == id.toString(),
        );
        if (index != -1) {
          if (chatDetailsPagination.items[index]['status'] != newStatus) {
            chatDetailsPagination.items[index]['status'] = newStatus;
            updated = true;
          }
        }
      }
    }

    /// ✅ refresh only once
    if (updated) {
      chatDetailsPagination.items.refresh();
    }
    if (Get.currentRoute == Routes.chatDetails) {
      await msgRead(data['conversation_id'].toString());
    }
  }

  void _handleTyping(Map data) {
    if (data['user_id'].toString() == userId.toString()) return;

    isTyping.value = true;

    Future.delayed(Duration(seconds: 2), () {
      isTyping.value = false;
    });
  }

  void _addMessageIfNotExists(dynamic msg) {
    final msgId = (msg['id'] ?? msg['message_id'] ?? '').toString();

    final exists = chatDetailsPagination.items.any(
      (e) => (e['id'] ?? e['message_id'] ?? '').toString() == msgId,
    );

    if (!exists) {
      chatDetailsPagination.items.insert(0, msg);
      chatDetailsPagination.items.refresh();
    }
  }

  @override
  void onClose() {
    typingDebouncer.dispose();
    socket_service.disconnect();

    for (var timer in _typingTimers.values) {
      timer.cancel();
    }
    super.onClose();
  }

  ///=============================== SEND MESSAGE ====================================///

  final isSendLoading = false.obs;
  final isDeliverLoading = false.obs;
  final isReadLoading = false.obs;
  RxMap<String, bool> typingUsers = <String, bool>{}.obs;

  Future<void> sendMessage(String convId) async {
    if (msgController.text.trim().isEmpty) return;

    final message = msgController.text.trim();
    msgController.clear();
    final userId = await SecureStorageService.read('user_id') ?? '';

    /// 🔥 OR fallback API
    try {
      isSendLoading(true);

      final attachment = await prepareDocuments(attachments);

      final res = await sendMsgUsecase.call(
        SendMessageRequest(userId, convId, message, attachment),
      );

      if (res['common']['status'] == true) {
        attachments.clear();

        _addMessageIfNotExists(res['data']);
      }
    } catch (_) {
    } finally {
      isSendLoading(false);
    }
  }

  Future<void> msgDelivered(String convId) async {
    try {
      final userId = await SecureStorageService.read('user_id') ?? '';
      isDeliverLoading(true);
      await msgDeliveredUsecase.call(ChatDetailsRequest(userId, convId));
    } catch (_) {
    } finally {
      isDeliverLoading(false);
    }
  }

  Future<void> msgRead(String convId) async {
    /// 🔥 OR fallback API
    try {
      final userId = await SecureStorageService.read('user_id') ?? '';
      isReadLoading(true);
      await msgReadUsecase.call(ChatDetailsRequest(userId, convId));
    } catch (_) {
    } finally {
      isReadLoading(false);
    }
  }

  final Debouncer typingDebouncer = Debouncer(milliseconds: 2000);

  void onTyping(String value, String convId) {
    typingDebouncer.run(() {
      if (value.trim().isNotEmpty) {
        typing(convId);
      }
    });
  }

  Future<void> typing(String convId) async {
    try {
      final userId = await SecureStorageService.read('user_id') ?? '';
      await typingUsecase.call(
        ChatDetailsRequest(
          userId,
          convId,
          nextCursor: userDetails['id'].toString(),
        ),
      );
    } catch (_) {}
  }

  final Map<String, Timer> _typingTimers = {};

  void onTypingEvent(Map data) async {
    final convId = data['conversation_id']?.toString();
    final senderId = data['user_id']?.toString();
    if (convId == null) return;
    final userId = await SecureStorageService.read('user_id') ?? '';
    typingUsers[convId] = true;

    if (senderId == userId) return;
    _typingTimers[convId]?.cancel();

    /// optional: auto remove after few seconds (safety)
    _typingTimers[convId] = Timer(const Duration(seconds: 2), () {
      typingUsers[convId] = false;
    });
  }
}
