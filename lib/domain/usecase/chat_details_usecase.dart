import 'package:madhya/core/exporters/app_export.dart';

class ChatDetailsUsecase {
  final ChatRepository repository;

  ChatDetailsUsecase(this.repository);

  Future<dynamic> call(ChatDetailsRequest request) async {
    return await repository.getChatDetails(request);
  }
}
