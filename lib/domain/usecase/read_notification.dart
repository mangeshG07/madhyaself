import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class ReadNotification {
  final HomeRepository _homeRepository;

  ReadNotification(this._homeRepository);

  Future<dynamic> call(UserRequest request) async {
    return await _homeRepository.readNotification(request);
  }
}
