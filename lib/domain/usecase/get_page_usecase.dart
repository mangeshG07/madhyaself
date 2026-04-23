import 'package:madhya/core/exporters/app_export.dart';

class GetPageUsecase {
  final ProfileRepository _repository;

  GetPageUsecase(this._repository);

  Future<dynamic> call() async {
    return await _repository.getPages();
  }
}
