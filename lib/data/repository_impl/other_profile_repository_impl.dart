import 'package:madhya/core/exporters/app_export.dart';

@LazySingleton(as: OtherUserRepository)
class OtherProfileRepositoryImpl extends OtherUserRepository {
  final ApiService _apiService;

  OtherProfileRepositoryImpl(this._apiService);

  @override
  Future<dynamic> otherUserProfile(OtherUserRequest request) async {
    return await _apiService.getOtherProfile(
      request.userId,
      request.otherUserId,
    );
  }

  @override
  Future<dynamic> blockProfile(OtherUserRequest request) async {
    return await _apiService.blockUser(request.userId, request.otherUserId);
  }

  @override
  Future<dynamic> reportProfile(OtherUserRequest request) async {
    return await _apiService.reportProfile(
      request.userId,
      request.otherUserId,
      request.reason,
    );
  }
}
