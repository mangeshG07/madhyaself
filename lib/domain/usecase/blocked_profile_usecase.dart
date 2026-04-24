import 'package:madhya/core/exporters/app_export.dart';

class BlockedProfileUsecase {
  final ProfileRepository _profileRepository;

  BlockedProfileUsecase(this._profileRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _profileRepository.getBlockUserList(request);
  }
}
