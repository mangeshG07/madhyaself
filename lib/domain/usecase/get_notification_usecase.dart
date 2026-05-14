import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class GetNotificationUsecase {
  final HomeRepository _homeRepository;

  GetNotificationUsecase(this._homeRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _homeRepository.getNotification(request);
  }
}
