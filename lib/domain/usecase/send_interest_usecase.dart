import 'package:madhya/core/exporters/app_export.dart';

class SendInterestUsecase {
  final ProfileRepository repository;
  SendInterestUsecase(this.repository);

  Future<dynamic> call(InterestRequested request) async {
    return await repository.sendInterest(request);
  }
}
