import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class SubcasteByCasteListUsecase {
  final HomeRepository _homeRepository;

  SubcasteByCasteListUsecase(this._homeRepository);

  Future<dynamic> call(SubcasteByCasteRequest request) async {
    return await _homeRepository.getMultiSubCasteByCaste(request);
  }
}
