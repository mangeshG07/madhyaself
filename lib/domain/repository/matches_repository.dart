import '../../core/exporters/app_export.dart';

abstract class MatchesRepository {
  Future<dynamic> getMatches(UserRequest request);
}
