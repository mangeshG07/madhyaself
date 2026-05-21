class PartnerPreferenceRequest {
  final String userId;
  final String? partnerAgeFrom;
  final String? partnerAgeTo;
  final String? partnerHeightFrom;
  final String? partnerHeightTo;
  final String? maritalStatus;
  final List<String>? educationCategoryId;
  final String? educationDetail;
  final List<String>? jobCategoryId;
  final String? jobDetail;
  final List<String>? religionId;
  final List<String>? casteId;
  final List<String>? subCasteId;
  final String? country;
  final String? state;
  final String? city;
  final String? annualIncome;
  final String? dietaryHabits;
  final String? smokingHabits;
  final String? drinkingHabits;
  final String? specialCase;

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
    this.dietaryHabits,
    this.smokingHabits,
    this.drinkingHabits,
    this.specialCase,
  });

  // Map<String, dynamic> toJson() {
  //   final data = {
  //     "user_id": userId,
  //     "patner_age_from": partnerAgeFrom,
  //     "patner_age_to": partnerAgeTo,
  //     "patner_height_from": partnerHeightFrom,
  //     "patner_height_to": partnerHeightTo,
  //     "marital_status": maritalStatus,
  //     "education_detail": educationDetail,
  //     "job_detail": jobDetail,
  //     "religion_id": religionId,
  //     "caste_id": casteId,
  //     "sub_caste_id": subCasteId,
  //     "country": country,
  //     "state": state,
  //     "city": city,
  //     "annual_income": annualIncome,
  //   };
  //
  //   if (educationCategoryId != null) {
  //     for (int i = 0; i < educationCategoryId!.length; i++) {
  //       data["education_category_id[$i]"] = educationCategoryId![i];
  //     }
  //   }
  //
  //   // job_category_id[0], job_category_id[1]
  //   if (jobCategoryId != null) {
  //     for (int i = 0; i < jobCategoryId!.length; i++) {
  //       data["job_category_id[$i]"] = jobCategoryId![i];
  //     }
  //   }
  //
  //   // 🔥 remove null & empty values
  //   data.removeWhere(
  //     (key, value) =>
  //         value == null || value == "" || (value is List && value.isEmpty),
  //   );
  //   return data;
  // }
}
