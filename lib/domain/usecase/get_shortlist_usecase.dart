import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class GetShortlistUsecase {
  final ProfileRepository repository;

  GetShortlistUsecase(this.repository);

  Future<dynamic> call(UserRequest request) async {
    return await repository.getShortList(request);
  }
}
