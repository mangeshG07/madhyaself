import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class CasteByReligionListUsecase {
  final HomeRepository _homeRepository;
  CasteByReligionListUsecase(this._homeRepository);

  Future<dynamic> call(CasteByReligionRequest request) async {
    return await _homeRepository.getMultiCasteByReligion(request);
  }
}
