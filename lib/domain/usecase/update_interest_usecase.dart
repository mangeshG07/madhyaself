import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class UpdateInterestUsecase {
  final ProfileRepository repository;
  UpdateInterestUsecase(this.repository);

  Future<dynamic> call(InterestRequested request) async {
    return await repository.updateInterest(request);
  }
}
