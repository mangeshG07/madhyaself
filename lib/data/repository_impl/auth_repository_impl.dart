import '../../core/exporters/app_export.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService api;

  AuthRepositoryImpl(this.api);

  @override
  Future<dynamic> login(LoginRequest number) async {
    final res = await api.loginUser(number.phone);
    return res;
  }

  @override
  Future<dynamic> verifyOTP(VerifyOtpRequest request) async {
    final res = await api.verifyOTP(request.phone, request.otp);
    return res;
  }

  @override
  Future<dynamic> getCommonData() async {
    final res = await api.getCommonData();

    final decoded = jsonDecode(res.toString());

    return decoded;
  }

  @override
  Future<dynamic> register(RegisterRequest request) async {
    final res = await api.registerUser(
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
    return res;
  }

  @override
  Future<dynamic> casteByReligion(CasteRequest request) async {
    final res = await api.getCasteByReligion(request.religionId);
    return res;
  }

  @override
  Future<dynamic> subCasteByCaste(SubCasteRequest request) async {
    final res = await api.getSubCasteByCaste(request.casteId);
    return res;
  }
}
