import 'package:madhya/core/exporters/app_export.dart';

class CreateChatUsecase {
  final ChatRepository repository;
  CreateChatUsecase(this.repository);

  Future<dynamic> call(CreateChatRequest request) async {
    return await repository.createChat(request);
  }
}
