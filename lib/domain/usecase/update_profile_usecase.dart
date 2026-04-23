import 'package:madhya/core/exporters/app_export.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<dynamic> call(UpdateUserProfileRequest request) async {
    return await repository.updateProfile(request);
  }
}
