import 'package:madhya/core/exporters/app_export.dart';

class DeleteInterestUsecase {
  final ProfileRepository repository;
  DeleteInterestUsecase(this.repository);

  Future<dynamic> call(InterestRequested request) async {
    return await repository.deleteInterest(request);
  }
}
