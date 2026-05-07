import '../../core/exporters/app_export.dart';

@lazySingleton
class WhatsappConnectUsecase {
  final OtherUserRepository _otherUserRepository;

  WhatsappConnectUsecase(this._otherUserRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _otherUserRepository.whatsappConnect(request);
  }
}
