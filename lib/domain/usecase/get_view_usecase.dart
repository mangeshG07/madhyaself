import 'package:madhya/core/exporters/app_export.dart';

class GetViewUsecase {
  final ProfileRepository repository;

  GetViewUsecase(this.repository);

  Future<dynamic> call(UserRequest request) async {
    return await repository.getView(request);
  }
}
