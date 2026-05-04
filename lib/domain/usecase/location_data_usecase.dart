import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class LocationDataUsecase {
  final ProfileRepository repository;

  LocationDataUsecase(this.repository);

  Future<dynamic> call() async {
    return await repository.getLocationData();
  }
}
