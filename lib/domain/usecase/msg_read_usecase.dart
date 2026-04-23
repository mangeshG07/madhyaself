import '../../core/exporters/app_export.dart';

class MsgReadUsecase {
  final ChatRepository repository;

  MsgReadUsecase(this.repository);

  Future<dynamic> call(ChatDetailsRequest request) async {
    return await repository.msgRead(request);
  }
}
