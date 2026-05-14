import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class FirebaseTokenController extends GetxController {
  final FirebaseTokenUsecase _firebaseTokenUsecase;
  FirebaseTokenController(this._firebaseTokenUsecase);

  Future<void> updateToken() async {
    await FirebaseMessaging.instance.deleteToken();
    String? token = await FirebaseMessaging.instance.getToken();
    final userId = await SecureStorageService.read('user_id') ?? '';
    try {
      await _firebaseTokenUsecase(UserRequest(userId, view: token.toString()));
    } catch (_) {}
  }
}
