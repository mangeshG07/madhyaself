import '../../core/exporters/app_export.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<dynamic> login(LoginRequest number) async {
    return await _api.loginUser(number.phone);
  }

  @override
  Future<dynamic> verifyOTP(VerifyOtpRequest request) async {
    return await _api.verifyOTP(request.phone, request.otp);
  }

  @override
  Future<dynamic> getCommonData() async {
    final res = await _api.getCommonData();

    // final decoded = jsonDecode(res.toString());

    return res;
  }

  @override
  Future<dynamic> register(RegisterRequest request) async {
    print(request.birthdate);
    print(request.birthdate);
    return await _api.registerUser(
      request.name,
      request.phone,
      request.gender,
      request.birthdate,
      request.age,
      request.religion,
      request.caste,
      request.subCaste,
      profilePicture: request.profilePicture,
      attachment: request.photos as List<MultipartFile>,
    );
  }

  @override
  Future<dynamic> casteByReligion(CasteRequest request) async {
    return await _api.getCasteByReligion(request.religionId);
  }

  @override
  Future<dynamic> subCasteByCaste(SubCasteRequest request) async {
    return await _api.getSubCasteByCaste(request.casteId);
  }
}
