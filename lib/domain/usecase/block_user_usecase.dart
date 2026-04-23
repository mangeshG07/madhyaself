import 'package:madhya/core/exporters/app_export.dart';

class BlockUserUsecase {
  final OtherUserRepository _otherUserRepository;
  BlockUserUsecase(this._otherUserRepository);

  Future<dynamic> call(OtherUserRequest request) async {
    return await _otherUserRepository.blockProfile(request);
  }
}
