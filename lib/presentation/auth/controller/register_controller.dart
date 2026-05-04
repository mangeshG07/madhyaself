import 'package:madhya/core/exporters/app_export.dart';

class RegisterController extends GetxController {
  final CommonDataUsecase commonDataUsecase;
  final RegisterUsecase registerUsecase;
  final CasteByRelUsecase casteUsecase;
  final SubCasteByCasteUsecase subCasteUsecase;

  RegisterController(
    this.commonDataUsecase,
    this.registerUsecase,
    this.casteUsecase,
    this.subCasteUsecase,
  );

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  /// ------------------ FORM ------------------ ///
  final registerKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final dobController = TextEditingController();

  /// ------------------ SELECTION ------------------ ///
  final selectedGender = Rxn<String>();
  final selectedAge = Rxn<String>();
  final selectedReligion = Rxn<String>();
  final selectedCaste = Rxn<String>();
  final selectedSubCaste = Rxn<String>();

  /// ------------------ STATES ------------------ ///
  final isLoading = false.obs;
  final isDataLoading = false.obs;
  final isCasteLoading = false.obs;
  final isSubCasteLoading = false.obs;

  final isTermsAccepted = false.obs;

  /// ------------------ FILES ------------------ ///
  final profileImage = Rx<File?>(null);
  final profileImages = <File>[].obs;

  /// ------------------ DATA LISTS ------------------ ///
  final ageList = [].obs;
  final religionList = [].obs;
  final casteList = [].obs;
  final subCasteList = [].obs;

  /// ------------------ COMMON DATA ------------------ ///
  Future<void> fetchInitialData() async {
    try {
      isDataLoading(true);

      final res = await commonDataUsecase.call();

      if (res['common']['status'] == true) {
        final data = res['data'];
        ageList.assignAll(data['age'] ?? []);
        religionList.assignAll(data['religion'] ?? []);
      }
    } catch (_) {
    } finally {
      isDataLoading(false);
    }
  }

  /// ------------------ CASTE ------------------ ///
  Future<void> fetchCaste(String religionId) async {
    try {
      isCasteLoading(true);
      selectedCaste.value = null;
      selectedSubCaste.value = null;
      casteList.clear();
      subCasteList.clear();

      final res = await casteUsecase.call(CasteRequest(religionId));

      if (res['common']['status'] == true) {
        final data = res['data'];
        casteList.value = data['caste'] ?? [];
      }
    } finally {
      isCasteLoading(false);
    }
  }

  /// ------------------ SUB CASTE ------------------ ///
  Future<void> fetchSubCaste(String casteId) async {
    try {
      isSubCasteLoading(true);
      selectedSubCaste.value = null;
      subCasteList.clear();
      final res = await subCasteUsecase.call(SubCasteRequest(casteId));

      if (res['common']['status'] == true) {
        final data = res['data'];

        subCasteList.value = data['sub_caste'] ?? [];
      }
    } catch (_) {
    } finally {
      isSubCasteLoading(false);
    }
  }

  /// ------------------ REGISTER ------------------ ///
  Future<void> registerUser(String phone) async {
    if (!registerKey.currentState!.validate()) return;

    try {
      isLoading(true);

      final attachment = await prepareDocuments(profileImages);

      final res = await registerUsecase.call(
        RegisterRequest(
          phone: phone,
          name: nameController.text.trim(),
          gender: selectedGender.value == 'Male' ? '0' : '1',
          birthdate: dobController.text.trim(),
          age: selectedAge.value!,
          religion: selectedReligion.value!,
          caste: selectedCaste.value!,
          subCaste: selectedSubCaste.value!,
          profilePicture: profileImage.value,
          photos: attachment,
        ),
      );
      if (res['common']['status'] == true) {
        Get.snackbar('Success', res['common']['message']);
        await SecureStorageService.write('token', res['user']['app_auth_key']);
        await SecureStorageService.write(
          'user_id',
          res['user']['id'].toString(),
        );
        Get.offAllNamed(Routes.mainScreen);
      } else {
        Get.snackbar('Success', res['common']['message']);
      }
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }
}
