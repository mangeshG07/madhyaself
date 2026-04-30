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
      "age_from": partnerAgeFrom,
      "age_to": partnerAgeTo,
      "height_from": partnerHeightFrom,
      "height_to": partnerHeightTo,
      "education_cat": educationCategoryId,
      "job_cat": jobCategoryId,
      "religion_id": religionId,
      "caste_id": casteId,
      "country": country,
      "state": state,
      "city": city,
      "income_range": annualIncome,
      "username": userName,
    };

    // 🔥 remove null & empty values
    data.removeWhere((key, value) => value == null || value == "");
    return data;
  }
}
