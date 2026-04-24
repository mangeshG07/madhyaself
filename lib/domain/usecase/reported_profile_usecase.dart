import 'package:madhya/core/exporters/app_export.dart';

class ReportedProfileUsecase {
  final ProfileRepository _profileRepository;

  ReportedProfileUsecase(this._profileRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _profileRepository.getReportedUserList(request);
  }
}
