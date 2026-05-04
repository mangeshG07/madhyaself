import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class VerifyPaymentUsecase {
  final ProfileRepository _profileRepository;
  VerifyPaymentUsecase(this._profileRepository);

  Future<dynamic> call(VerifyPaymentRequest request) async {
    return await _profileRepository.verifyPayment(request);
  }
}
