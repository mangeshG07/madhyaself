import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class GetPlanDetailsUsecase {
  final ProfileRepository _profileRepository;

  GetPlanDetailsUsecase(this._profileRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _profileRepository.getPlanDetails(request);
  }
}
