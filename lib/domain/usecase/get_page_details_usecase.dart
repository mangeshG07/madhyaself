import 'package:madhya/core/exporters/app_export.dart';

class GetPageDetailsUsecase {
  final ProfileRepository _repository;

  GetPageDetailsUsecase(this._repository);

  Future<dynamic> call(UserRequest request) async {
    return await _repository.getPageDetails(request);
  }
}
