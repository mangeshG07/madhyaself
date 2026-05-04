import '../../core/exporters/app_export.dart';

@lazySingleton
class GetMatchesUsecase {
  final MatchesRepository _repository;
  GetMatchesUsecase(this._repository);

  Future<dynamic> call(UserRequest request) async {
    return await _repository.getMatches(request);
  }
}
