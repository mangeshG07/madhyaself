import 'package:madhya/core/exporters/app_export.dart';

class ReportProfileUsecase {
  final OtherUserRepository _otherUserRepository;
  ReportProfileUsecase(this._otherUserRepository);

  Future<dynamic> call(OtherUserRequest request) async {
    return await _otherUserRepository.reportProfile(request);
  }
}
