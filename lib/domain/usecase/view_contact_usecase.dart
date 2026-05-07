import '../../core/exporters/app_export.dart';

@lazySingleton
class ViewContactUsecase {
  final OtherUserRepository _otherUserRepository;

  ViewContactUsecase(this._otherUserRepository);

  Future<dynamic> call(OtherUserRequest request) async {
    return await _otherUserRepository.viewContact(request);
  }
}
