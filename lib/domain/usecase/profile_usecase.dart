import 'package:madhya/core/exporters/app_export.dart';

class ProfileUsecase {
  final ProfileRepository repository;

  ProfileUsecase(this.repository);

  Future<dynamic> call(UserRequest request) async {
    return await repository.getProfile(request);
  }
}
