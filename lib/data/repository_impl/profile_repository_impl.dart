import '../../core/exporters/app_export.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl extends ProfileRepository {
  final ApiService _apiService;

  ProfileRepositoryImpl(this._apiService);

  @override
  Future<dynamic> getLocationData() async {
    final res = await _apiService.getLocationData();

    final decoded = jsonDecode(res.toString());

    return decoded;
  }

  @override
  Future<dynamic> getPages() async {
    final res = await _apiService.getPages();

    final decoded = jsonDecode(res.toString());

    return decoded;
  }

  @override
  Future<dynamic> getPageDetails(UserRequest request) async {
    return await _apiService.getPageDetails(request.userId);
  }

  @override
  Future<dynamic> getProfile(UserRequest request) async {
    return await _apiService.getProfile(request.userId);
  }

  @override
  Future<dynamic> getView(UserRequest request) async {
    return await _apiService.getView(
      request.userId,
      request.type,
      request.pageNo,
    );
  }

  @override
  Future<dynamic> getShortList(UserRequest request) async {
    return await _apiService.getShortlist(
      request.userId,
      request.type,
      request.pageNo,
    );
  }

  @override
  Future<dynamic> shortListProfile(InterestRequested request) async {
    return await _apiService.shortlistProfile(
      request.userId,
      request.interestId,
    );
  }

  @override
  Future<dynamic> getInterest(UserRequest request) async {
    return await _apiService.getInterest(
      request.userId,
      request.type,
      request.pageNo,
    );
  }

  @override
  Future<dynamic> sendInterest(InterestRequested request) async {
    return await _apiService.sendInterest(
      request.userId,
      request.interestId,
      request.status!,
    );
  }

  @override
  Future<dynamic> updateInterest(InterestRequested request) async {
    return await _apiService.updateInterest(
      request.userId,
      request.interestId,
      request.status!,
    );
  }

  @override
  Future<dynamic> deleteInterest(InterestRequested request) async {
    return await _apiService.deleteInterest(request.userId, request.interestId);
  }

  @override
  Future<dynamic> updateProfile(UpdateUserProfileRequest request) async {
    final Map<String, dynamic> map = {};

    void add(String key, dynamic value) {
      if (value != null) map[key] = value.toString();
    }

    add('user_id', request.userId);
    add('name', request.name);
    add('mobile_no', request.phone);
    add('wp_no', request.wpNumber);
    add('alternate_no', request.alternateNumber);
    add('birth_date', request.birthdate);
    add('about_me', request.aboutMe);
    add('gender', request.gender);
    add('height', request.height);
    add('age', request.age);
    add('marital_status', request.maritalStatus);
    add('profile_created_for', request.profileCreatedFor);
    add('education_category_id', request.educationCategoryId);
    add('education_detail', request.educationDetail);
    add('job_category_id', request.jobCategoryId);
    add('job_detail', request.jobDetail);
    add('annual_income', request.annualIncome);
    add('religion_id', request.religionId);
    add('caste_id', request.casteId);
    add('sub_caste_id', request.subCasteId);
    add('country', request.country);
    add('state', request.state);
    add('city', request.city);
    add('address', request.address);
    add('father_name', request.fatherName);
    add('father_job', request.fatherJob);
    add('mother_name', request.motherName);
    add('mother_job', request.motherJob);
    add('birthtime', request.birthtime);
    add('rasi', request.rasi);
    add('siblling_details', request.sibllingDetails);
    add('hide_photos', request.hidePhotos);

    final formData = FormData.fromMap(map);

    /// ✅ FILES
    if (request.profilePicture != null) {
      formData.files.add(
        MapEntry(
          'profile_picture',
          await MultipartFile.fromFile(request.profilePicture!.path),
        ),
      );
    }
    if (request.horoscopeDoc != null) {
      formData.files.add(
        MapEntry(
          'horoscope_photo',
          await MultipartFile.fromFile(request.horoscopeDoc!.path),
        ),
      );
    }
    if (request.photos != null) {
      for (var file in request.photos!) {
        formData.files.add(MapEntry('photos[]', file));
      }
    }

    if (request.removeFile != null) {
      for (var url in request.removeFile!) {
        formData.fields.add(MapEntry('removed_files[]', url));
      }
    }
    if (request.removeDocs != null) {
      for (var url in request.removeDocs!) {
        formData.fields.add(MapEntry('removed_documents[]', url));
      }
    }
    if (request.documents != null) {
      for (var file in request.documents!) {
        formData.files.add(MapEntry('documents[]', file));
      }
    }

    return await _apiService.updateUserProfile(formData);
  }

  @override
  Future<dynamic> getBlockUserList(UserRequest request) async {
    return await _apiService.blockProfileList(request.userId);
  }

  @override
  Future<dynamic> getReportedUserList(UserRequest request) async {
    return await _apiService.reportProfileList(request.userId);
  }

  @override
  Future<dynamic> getPlans(UserRequest request) async {
    return await _apiService.getPlans(request.userId);
  }

  @override
  Future<dynamic> getPlanDetails(UserRequest request) async {
    return await _apiService.getPlanDetails(request.userId, request.type);
  }

  @override
  Future<dynamic> checkOut(CheckoutRequest request) async {
    return await _apiService.checkout(
      request.userId,
      request.planId,
      request.price,
      request.paymentMethod,
      request.type,
    );
  }

  @override
  Future<dynamic> verifyPayment(VerifyPaymentRequest request) async {
    return await _apiService.verifyPayment(
      request.userId,
      request.razorpayPaymentId,
      request.razorpayOrderId,
      request.paymentId,
      request.razorpaySignature,
      request.status,
    );
  }
}
