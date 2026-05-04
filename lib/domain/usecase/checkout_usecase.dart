import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class CheckoutUsecase {
  final ProfileRepository _profileRepository;
  CheckoutUsecase(this._profileRepository);

  Future<dynamic> call(CheckoutRequest request) async {
    return await _profileRepository.checkOut(request);
  }
}
