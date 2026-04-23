import 'package:madhya/core/exporters/app_export.dart';

class HomeRepositoryImpl extends HomeRepository {
  final ApiService apiService;

  HomeRepositoryImpl(this.apiService);

  @override
  Future<dynamic> getHome(UserRequest request) async {
    return await apiService.getHome(request.userId);
  }
}
