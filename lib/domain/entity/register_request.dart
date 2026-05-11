import '../../core/exporters/app_export.dart';

class RegisterRequest {
  final String name;
  final String phone;
  final String whatsappNumber;
  final String gender;
  final String birthdate;
  final String age;
  final String religion;
  final String caste;
  final String subCaste;
  final File? profilePicture;
  final List<MultipartFile>? photos;

  RegisterRequest({
    required this.phone,
    required this.whatsappNumber,
    required this.name,
    required this.gender,
    required this.birthdate,
    required this.age,
    required this.religion,
    required this.caste,
    required this.subCaste,
    required this.profilePicture,
    required this.photos,
  });
}
