import 'package:madhya/core/exporters/app_export.dart';

class OtherProfileUsecase {
  final OtherUserRepository repository;

  OtherProfileUsecase(this.repository);

  Future<dynamic> call(OtherUserRequest request) async {
    return await repository.otherUserProfile(request);
  }
}
