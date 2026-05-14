import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class FirebaseTokenUsecase {
  final HomeRepository _homeRepository;

  FirebaseTokenUsecase(this._homeRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _homeRepository.updateFirebaseToken(request);
  }
}
