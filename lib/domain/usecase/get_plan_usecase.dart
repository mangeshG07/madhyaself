import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class GetPlanUsecase {
  final ProfileRepository _profileRepository;

  GetPlanUsecase(this._profileRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _profileRepository.getPlans(request);
  }
}
