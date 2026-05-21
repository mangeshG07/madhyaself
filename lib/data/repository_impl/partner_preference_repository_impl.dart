import '../../core/exporters/app_export.dart';

@LazySingleton(as: PartnerPreferenceRepository)
class PartnerPreferenceRepositoryImpl extends PartnerPreferenceRepository {
  final ApiService _apiService;

  PartnerPreferenceRepositoryImpl(this._apiService);

  @override
  Future<dynamic> getPartnerPreference(UserRequest request) async {
    return await _apiService.getPartnerPreference(request.userId);
  }

  // @override
  // Future<dynamic> updatePartnerPreference(
  //   PartnerPreferenceRequest request,
  // ) async {
  //   print(request.educationCategoryId);
  //   print(request.jobCategoryId);
  //   print(request);
  //   return await _apiService.updatePartnerPreference(request.toJson());
  // }

  @override
  Future<dynamic> updatePartnerPreference(
    PartnerPreferenceRequest request,
  ) async {
    final Map<String, dynamic> map = {};

    void add(String key, dynamic value) {
      if (value != null) map[key] = value.toString();
    }

    add('user_id', request.userId);
    add('patner_age_from', request.partnerAgeFrom);
    add('patner_age_to', request.partnerAgeTo);
    add('patner_height_from', request.partnerHeightFrom);
    add('patner_height_to', request.partnerHeightTo);
    add('marital_status', request.maritalStatus);
    add('education_detail', request.educationDetail);
    add('job_detail', request.jobDetail);
    add('country', request.country);
    add('state', request.state);
    add('city', request.city);
    add('annual_income', request.annualIncome);
    add('dietary_habits', request.dietaryHabits);
    add('smoking_habits', request.smokingHabits);
    add('drinking_habits', request.drinkingHabits);
    add('special_case', request.specialCase);

    final formData = FormData.fromMap(map);

    if (request.educationCategoryId != null &&
        request.educationCategoryId!.isNotEmpty) {
      for (int i = 0; i < request.educationCategoryId!.length; i++) {
        formData.fields.add(
          MapEntry(
            'education_category_id[$i]',
            request.educationCategoryId![i].toString(),
          ),
        );
      }
    }

    if (request.jobCategoryId != null && request.jobCategoryId!.isNotEmpty) {
      for (int i = 0; i < request.jobCategoryId!.length; i++) {
        formData.fields.add(
          MapEntry('job_category_id[$i]', request.jobCategoryId![i].toString()),
        );
      }
    }

    if (request.religionId != null && request.religionId!.isNotEmpty) {
      for (int i = 0; i < request.religionId!.length; i++) {
        formData.fields.add(
          MapEntry('religion_id[$i]', request.religionId![i].toString()),
        );
      }
    }

    if (request.casteId != null && request.casteId!.isNotEmpty) {
      for (int i = 0; i < request.casteId!.length; i++) {
        formData.fields.add(
          MapEntry('caste_id[$i]', request.casteId![i].toString()),
        );
      }
    }

    if (request.subCasteId != null && request.subCasteId!.isNotEmpty) {
      for (int i = 0; i < request.subCasteId!.length; i++) {
        formData.fields.add(
          MapEntry('sub_caste_id[$i]', request.subCasteId![i].toString()),
        );
      }
    }

    return await _apiService.updatePartnerPreference(formData);
  }
}
