import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase(this.repository);

  Future<dynamic> call(VerifyOtpRequest request) async {
    return await repository.verifyOTP(request);
  }
}
