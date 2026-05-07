import '../../core/exporters/app_export.dart';

abstract class OtherUserRepository {
  Future<dynamic> otherUserProfile(OtherUserRequest request);

  Future<dynamic> blockProfile(OtherUserRequest request);

  Future<dynamic> reportProfile(OtherUserRequest request);

  Future<dynamic> whatsappConnect(UserRequest request);

  Future<dynamic> viewContact(OtherUserRequest request);
}
