import 'package:madhya/core/exporters/app_export.dart';

abstract class ChatRepository {
  Future<dynamic> getChatList(UserRequest request);

  Future<dynamic> getChatDetails(ChatDetailsRequest request);

  Future<dynamic> sendMsg(SendMessageRequest request);

  Future<dynamic> msgDelivered(ChatDetailsRequest request);

  Future<dynamic> msgRead(ChatDetailsRequest request);

  Future<dynamic> typing(ChatDetailsRequest request);

  Future<dynamic> createChat(CreateChatRequest request);
}
