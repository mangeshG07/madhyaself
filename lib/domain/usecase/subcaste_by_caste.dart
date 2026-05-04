import '../../core/exporters/app_export.dart';

@lazySingleton
class SubCasteByCasteUsecase {
  final AuthRepository repository;
  SubCasteByCasteUsecase(this.repository);

  Future<dynamic> call(SubCasteRequest request) async {
    final res = await repository.subCasteByCaste(request);
    return res;
  }
}
