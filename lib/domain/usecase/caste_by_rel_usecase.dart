import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class CasteByRelUsecase {
  final AuthRepository repository;
  CasteByRelUsecase(this.repository);

  Future<dynamic> call(CasteRequest request) async {
    final res = await repository.casteByReligion(request);
    return res;
  }
}
