import 'package:madhya/core/exporters/app_export.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl extends HomeRepository {
  final ApiService apiService;

  HomeRepositoryImpl(this.apiService);

  @override
  Future<dynamic> getHome(UserRequest request) async {
    return await apiService.getHome(request.userId);
  }

  @override
  Future<dynamic> globalSearch(SearchRequest request) async {
    final Map<String, dynamic> map = {};

    void add(String key, dynamic value) {
      if (value != null) map[key] = value.toString();
    }

    add('user_id', request.userId);
    add('age_from', request.partnerAgeFrom);
    add('age_to', request.partnerAgeTo);
    add('height_from', request.partnerHeightFrom);
    add('height_to', request.partnerHeightTo);
    add('country', request.country);
    add('state', request.state);
    add('city', request.city);
    add('income_range', request.annualIncome);
    add('username', request.userName);
    add('sub_caste', request.subcaste);
    add('page_no', request.pageNo);

    final formData = FormData.fromMap(map);

    if (request.educationCategoryId != null &&
        request.educationCategoryId!.isNotEmpty) {
      for (int i = 0; i < request.educationCategoryId!.length; i++) {
        formData.fields.add(
          MapEntry(
            'education_cat[$i]',
            request.educationCategoryId![i].toString(),
          ),
        );
      }
    }

    if (request.jobCategoryId != null && request.jobCategoryId!.isNotEmpty) {
      for (int i = 0; i < request.jobCategoryId!.length; i++) {
        formData.fields.add(
          MapEntry('job_cat[$i]', request.jobCategoryId![i].toString()),
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
    return await apiService.globalSearch(formData);
  }

  // @override
  // Future<dynamic> globalSearch(SearchRequest request) async {
  //   return await apiService.globalSearch(request.toJson());
  // }

  @override
  Future<dynamic> updateFirebaseToken(UserRequest request) async {
    return await apiService.updateFirebaseToken(request.userId, request.view);
  }

  @override
  Future<dynamic> getNotification(UserRequest request) async {
    return await apiService.getNotification(request.userId, request.pageNo);
  }

  @override
  Future<dynamic> readNotification(UserRequest request) async {
    return await apiService.readNotification(request.userId, request.view);
  }

  @override
  Future<dynamic> getMultiCasteByReligion(
    CasteByReligionRequest request,
  ) async {
    final Map<String, dynamic> map = {};

    void add(String key, dynamic value) {
      if (value != null) map[key] = value.toString();
    }

    add('user_id', request.userId);

    final formData = FormData.fromMap(map);

    if (request.religionId != null && request.religionId!.isNotEmpty) {
      for (int i = 0; i < request.religionId!.length; i++) {
        formData.fields.add(
          MapEntry('religion_ids[$i]', request.religionId![i].toString()),
        );
      }
    }
    return await apiService.getMultiCasteByReligion(formData);
  }

  @override
  Future<dynamic> getMultiSubCasteByCaste(
    SubcasteByCasteRequest request,
  ) async {
    final Map<String, dynamic> map = {};

    void add(String key, dynamic value) {
      if (value != null) map[key] = value.toString();
    }

    add('user_id', request.userId);

    final formData = FormData.fromMap(map);

    if (request.casteIds != null && request.casteIds!.isNotEmpty) {
      for (int i = 0; i < request.casteIds!.length; i++) {
        formData.fields.add(
          MapEntry('caste_ids[$i]', request.casteIds![i].toString()),
        );
      }
    }
    return await apiService.getMultiSubCasteByCaste(formData);
  }
}
