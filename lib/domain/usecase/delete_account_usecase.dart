import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class DeleteAccountUsecase {
  final ProfileRepository _profileRepository;

  DeleteAccountUsecase(this._profileRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _profileRepository.deleteAccount(request);
  }
}
