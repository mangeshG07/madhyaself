import 'package:madhya/core/exporters/app_export.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl extends ChatRepository {
  final ApiService _apiService;

  ChatRepositoryImpl(this._apiService);

  @override
  Future<dynamic> getChatList(UserRequest request) async {
    return await _apiService.getChatList(
      request.userId,
      request.type,
      request.pageNo,
    );
  }

  @override
  Future<dynamic> getChatDetails(ChatDetailsRequest request) async {
    return await _apiService.getChatDetails(
      request.userId,
      request.conversationId,
      request.nextCursor,
    );
  }

  @override
  Future<dynamic> sendMsg(SendMessageRequest request) async {
    return await _apiService.sendMsg(
      request.userId,
      request.conversationId,
      request.userId,
      request.message,
      attachment: request.photos,
    );
  }

  @override
  Future<dynamic> msgDelivered(ChatDetailsRequest request) async {
    return await _apiService.msgDelivered(
      request.userId,
      request.conversationId,
    );
  }

  @override
  Future<dynamic> msgRead(ChatDetailsRequest request) async {
    return await _apiService.msgRead(request.userId, request.conversationId);
  }

  @override
  Future<dynamic> typing(ChatDetailsRequest request) async {
    return await _apiService.typing(
      request.userId,
      request.conversationId,
      request.nextCursor,
    );
  }

  @override
  Future<dynamic> createChat(CreateChatRequest request) async {
    return await _apiService.createChat(
      request.participateOne,
      request.participateTwo,
      request.userId,
    );
  }
}
