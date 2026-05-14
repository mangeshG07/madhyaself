import '../../core/exporters/app_export.dart';

abstract class HomeRepository {
  Future<dynamic> getHome(UserRequest request);

  Future<dynamic> globalSearch(SearchRequest request);

  Future<dynamic> updateFirebaseToken(UserRequest request);

  Future<dynamic> getNotification(UserRequest request);

  Future<dynamic> readNotification(UserRequest request);
}
