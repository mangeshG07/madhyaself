import 'package:madhya/core/exporters/app_export.dart';

class TypingUsecase {
  final ChatRepository repository;

  TypingUsecase(this.repository);

  Future<dynamic> call(ChatDetailsRequest request) async {
    return await repository.typing(request);
  }
}
