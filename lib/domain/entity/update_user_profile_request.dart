import '../../core/exporters/app_export.dart';

class UpdateUserProfileRequest {
  final String userId;
  final String? name;
  final String? phone;
  final String? wpNumber;
  final String? alternateNumber;
  final String? aboutMe;
  final String? height;
  final String? maritalStatus;
  final String? educationCategoryId;
  final String? educationDetail;
  final String? jobCategoryId;
  final String? jobDetail;
  final String? annualIncome;
  final String? religionId;
  final String? casteId;
  final String? subCasteId;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final String? fatherName;
  final String? fatherJob;
  final String? motherName;
  final String? motherJob;
  final String? birthtime;
  final String? rasi;
  final String? sibllingDetails;
  final String? profileCreatedFor;
  final String? gender;
  final String? birthdate;
  final String? age;
  final String? hidePhotos;
  final File? profilePicture;
  final File? horoscopeDoc;
  final List<MultipartFile>? photos;
  final List? removeFile;
  final List? removeDocs;
  final List<MultipartFile>? documents;

  UpdateUserProfileRequest({
    required this.userId,
    this.name,
    this.phone,
    this.wpNumber,
    this.alternateNumber,
    this.aboutMe,
    this.height,
    this.maritalStatus,
    this.educationCategoryId,
    this.educationDetail,
    this.jobCategoryId,
    this.jobDetail,
    this.annualIncome,
    this.religionId,
    this.casteId,
    this.subCasteId,
    this.country,
    this.state,
    this.city,
    this.address,
    this.fatherName,
    this.fatherJob,
    this.motherName,
    this.motherJob,
    this.birthtime,
    this.rasi,
    this.sibllingDetails,
    this.profileCreatedFor,
    this.gender,
    this.birthdate,
    this.age,
    this.profilePicture,
    this.photos,
    this.removeDocs,
    this.documents,
    this.removeFile,
    this.horoscopeDoc,
    this.hidePhotos,
  });
}
