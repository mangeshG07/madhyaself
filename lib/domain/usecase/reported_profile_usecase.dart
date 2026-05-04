import 'package:madhya/core/exporters/app_export.dart';
@lazySingleton
class ReportedProfileUsecase {
  final ProfileRepository _profileRepository;

  ReportedProfileUsecase(this._profileRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _profileRepository.getReportedUserList(request);
  }
}
