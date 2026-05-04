import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class GetInterestUsecase {
  final ProfileRepository repository;
  GetInterestUsecase(this.repository);

  Future<dynamic> call(UserRequest request) async {
    return await repository.getInterest(request);
  }
}
