import 'package:madhya/core/exporters/app_export.dart';

class GlobalSearchUsecase {
  final HomeRepository _repository;

  GlobalSearchUsecase(this._repository);

  Future<dynamic> call(SearchRequest request) async {
    return await _repository.globalSearch(request);
  }
}
