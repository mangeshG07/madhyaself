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
    return await apiService.globalSearch(request.toJson());
  }

  @override
  Future<dynamic> updateFirebaseToken(UserRequest request) async {
    return await apiService.updateFirebaseToken(request.userId, request.view);
  }

  @override
  Future<dynamic> getNotification(UserRequest request) async {
    return await apiService.getNotification(request.userId,request.pageNo);
  }

  @override
  Future<dynamic> readNotification(UserRequest request) async {
    return await apiService.readNotification(request.userId, request.view);
  }
}
