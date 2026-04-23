import 'package:madhya/core/exporters/app_export.dart';

class GetPartPrefUsecase {
  final PartnerPreferenceRepository repository;

  GetPartPrefUsecase(this.repository);

  Future<dynamic> call(UserRequest request) async {
    return await repository.getPartnerPreference(request);
  }
}
