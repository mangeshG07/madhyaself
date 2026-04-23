import 'package:madhya/core/exporters/app_export.dart';

class MsgDeliveredUsecase {
  final ChatRepository repository;

  MsgDeliveredUsecase(this.repository);

  Future<dynamic> call(ChatDetailsRequest request) async {
    return await repository.msgDelivered(request);
  }
}
