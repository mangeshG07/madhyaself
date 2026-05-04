import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class HomeUsecase {
  final HomeRepository repository;
  HomeUsecase(this.repository);

  Future<dynamic> call(UserRequest request) async {
    return await repository.getHome(request);
  }
}
