import '../../core/exporters/app_export.dart';

class PartnerPreferenceRepositoryImpl extends PartnerPreferenceRepository {
  final ApiService _apiService;

  PartnerPreferenceRepositoryImpl(this._apiService);

  @override
  Future<dynamic> getPartnerPreference(UserRequest request) async {
    return await _apiService.getPartnerPreference(request.userId);
  }

  @override
  Future<dynamic> updatePartnerPreference(
    PartnerPreferenceRequest request,
  ) async {
    return await _apiService.updatePartnerPreference(request.toJson());
  }
}
