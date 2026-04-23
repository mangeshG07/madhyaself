import 'package:madhya/core/exporters/app_export.dart';

class UpdatePrefsUsecase {
  final PartnerPreferenceRepository _repository;

  UpdatePrefsUsecase(this._repository);

  Future<dynamic> call(PartnerPreferenceRequest request) async {
    return await _repository.updatePartnerPreference(request);
  }
}
