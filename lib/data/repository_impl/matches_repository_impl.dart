import 'package:madhya/core/exporters/app_export.dart';

class MatchesRepositoryImpl extends MatchesRepository {
  final ApiService _apiService;
  MatchesRepositoryImpl(this._apiService);

  @override
  Future<dynamic> getMatches(UserRequest request) async {
    return await _apiService.getMatches(
      request.userId,
      request.type,
      request.pageNo,
    );
  }
}
