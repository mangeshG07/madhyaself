class PartnerPreferenceRequest {
  final String userId;
  final String? partnerAgeFrom;
  final String? partnerAgeTo;
  final String? partnerHeightFrom;
  final String? partnerHeightTo;
  final String? maritalStatus;
  final String? educationCategoryId;
  final String? educationDetail;
  final String? jobCategoryId;
  final String? jobDetail;
  final String? religionId;
  final String? casteId;
  final String? subCasteId;
  final String? country;
  final String? state;
  final String? city;
  final String? annualIncome;

  PartnerPreferenceRequest({
    required this.userId,
    this.partnerAgeFrom,
    this.partnerAgeTo,
    this.partnerHeightFrom,
    this.partnerHeightTo,
    this.maritalStatus,
    this.educationCategoryId,
    this.educationDetail,
    this.jobCategoryId,
    this.jobDetail,
    this.religionId,
    this.casteId,
    this.subCasteId,
    this.country,
    this.state,
    this.city,
    this.annualIncome,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "user_id": userId,
      "patner_age_from": partnerAgeFrom,
      "patner_age_to": partnerAgeTo,
      "patner_height_from": partnerHeightFrom,
      "patner_height_to": partnerHeightTo,
      "marital_status": maritalStatus,
      "education_category_id": educationCategoryId,
      "education_detail": educationDetail,
      "job_category_id": jobCategoryId,
      "job_detail": jobDetail,
      "religion_id": religionId,
      "caste_id": casteId,
      "sub_caste_id": subCasteId,
      "country": country,
      "state": state,
      "city": city,
      "annual_income": annualIncome,
    };

    // 🔥 remove null & empty values
    data.removeWhere((key, value) => value == null || value == "");
    return data;
  }
}
