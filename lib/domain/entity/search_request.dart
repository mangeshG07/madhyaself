class SearchRequest {
  final String userId;
  final String? partnerAgeFrom;
  final String? partnerAgeTo;
  final String? partnerHeightFrom;
  final String? partnerHeightTo;
  final String? educationCategoryId;
  final String? jobCategoryId;
  final String? religionId;
  final String? casteId;
  final String? country;
  final String? state;
  final String? city;
  final String? annualIncome;
  final String? userName;

  SearchRequest({
    required this.userId,
    this.partnerAgeFrom,
    this.partnerAgeTo,
    this.partnerHeightFrom,
    this.partnerHeightTo,
    this.educationCategoryId,
    this.jobCategoryId,
    this.religionId,
    this.casteId,
    this.country,
    this.state,
    this.city,
    this.annualIncome,
    this.userName,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "user_id": userId,
      "patner_age_from": partnerAgeFrom,
      "patner_age_to": partnerAgeTo,
      "patner_height_from": partnerHeightFrom,
      "patner_height_to": partnerHeightTo,
      "education_category_id": educationCategoryId,
      "job_category_id": jobCategoryId,
      "religion_id": religionId,
      "caste_id": casteId,
      "country": country,
      "state": state,
      "city": city,
      "annual_income": annualIncome,
      "username": userName,
    };

    // 🔥 remove null & empty values
    data.removeWhere((key, value) => value == null || value == "");
    return data;
  }
}
