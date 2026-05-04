import 'package:madhya/core/exporters/app_export.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ChatRepository>(() => ChatRepositoryImpl(Get.find()));
    // Get.lazyPut(() => ChatListUsecase(Get.find()));
    // Get.lazyPut(() => ChatDetailsUsecase(Get.find()));
    // Get.lazyPut(() => SendMsgUsecase(Get.find()));
    // Get.lazyPut(() => MsgDeliveredUsecase(Get.find()));
    // Get.lazyPut(() => MsgReadUsecase(Get.find()));
    // Get.lazyPut(() => TypingUsecase(Get.find()));
    // Get.lazyPut(() => CreateChatUsecase(Get.find()));
    Get.lazyPut<ChatController>(
      () => ChatController(
        getIt<ChatListUsecase>(),
        getIt<ChatDetailsUsecase>(),
        getIt<SendMsgUsecase>(),
        getIt<MsgDeliveredUsecase>(),
        getIt<MsgReadUsecase>(),
        getIt<CreateChatUsecase>(),
        getIt<TypingUsecase>(),
      ),
    );
  }
}
