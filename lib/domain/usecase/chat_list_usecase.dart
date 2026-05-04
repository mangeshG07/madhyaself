import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class ChatListUsecase {
  final ChatRepository repository;

  ChatListUsecase(this.repository);

  Future<dynamic> call(UserRequest request) async {
    return await repository.getChatList(request);
  }
}
