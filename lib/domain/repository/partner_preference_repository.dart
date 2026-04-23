import 'package:madhya/core/exporters/app_export.dart';

abstract class PartnerPreferenceRepository {
  Future<dynamic> getPartnerPreference(UserRequest request);

  Future<dynamic> updatePartnerPreference(PartnerPreferenceRequest request);
}
