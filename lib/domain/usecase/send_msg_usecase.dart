import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class SendMsgUsecase {
  final ChatRepository repository;

  SendMsgUsecase(this.repository);

  Future<dynamic> call(SendMessageRequest request) async {
    return await repository.sendMsg(request);
  }
}
