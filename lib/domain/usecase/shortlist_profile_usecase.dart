import 'package:madhya/core/exporters/app_export.dart';

class ShortlistProfileUsecase {
  final ProfileRepository _repository;

  ShortlistProfileUsecase(this._repository);

  Future<dynamic> call(InterestRequested request) async {
    return await _repository.shortListProfile(request);
  }
}
