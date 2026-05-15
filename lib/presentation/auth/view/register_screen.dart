import 'package:madhya/core/exporters/app_export.dart';
import 'package:madhya/presentation/profile/binding/profile_bindings.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(child: buildBackgroundImage(theme)),
          _buildForm(theme, context),
        ],
      ),
    );
  }

  Widget _buildForm(ThemeData theme, BuildContext context) {
    return Obx(
      () => controller.isDataLoading.isTrue
          ? AppLoader()
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Form(
                key: controller.registerKey,
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.06),
                    buildTitle("Join Madhyasthi"),
                    buildSubTitle(
                      "Create your profile and discover\nmeaningful matches.",
                      theme,
                    ),
                    _buildNameField(theme),
                    _buildNumberField(theme),
                    _buildWhatsappSameCheckbox(theme),
                    _buildGender(theme),
                    _buildDOB(theme, context),
                    _buildAgeDropdown(),
                    _buildReligionDropdown(),
                    _buildCasteDropdown(),
                    _buildSubCasteDropdown(),
                    const SizedBox(height: 12),
                    _buildAcceptTerms(),
                    const SizedBox(height: 8),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNameField(ThemeData theme) {
    return AppTextField(
      label: 'Full Name',
      hint: 'Full Name',
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: theme.colorScheme.onSurface,
      ),
      filled: true,
      textStyle: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      fillColor: theme.cardColor,
      hintStyle: theme.textTheme.labelMedium!.copyWith(color: Colors.grey),
      controller: controller.nameController,
      validator: AppValidators.required,
    );
  }

  Widget _buildNumberField(ThemeData theme) {
    return AppTextField(
      filled: true,
      label: 'WhatsApp Number',
      showLabel: true,
      hint: 'Enter WhatsApp Number',
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface),
      validator: AppValidators.phone,
      labelStyle: theme.textTheme.labelLarge,
      controller: controller.whatsappNumber,
      fillColor: theme.cardColor,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget _buildWhatsappSameCheckbox(ThemeData theme) {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: 22.r,
            height: 22.r,
            child: Checkbox(
              value: controller.isWhatsappSame.value,
              activeColor: AppColors.lightPrimary,
              onChanged: (value) {
                controller.isWhatsappSame.value = value!;

                if (value) {
                  controller.whatsappNumber.text =
                      Get.find<LoginController>().numberController.text;
                } else {
                  controller.whatsappNumber.clear();
                }
              },
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Text(
              "Same as mobile number",
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGender(ThemeData theme) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabel(
          text: 'Select your gender',
          fontSize: 14.sp,
          color: theme.colorScheme.onSurface,
        ),

        Obx(
          () => Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectedGender.value = 'Male',
                  child: buildGenderCard(
                    controller.selectedGender.value == 'Male',
                    'Male',
                    HugeIcons.strokeRoundedMale02,
                    theme,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectedGender.value = 'Female',
                  child: buildGenderCard(
                    controller.selectedGender.value == 'Female',
                    'Female',
                    HugeIcons.strokeRoundedFemale02,
                    theme,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDOB(ThemeData theme, BuildContext context) {
    return AppTextField(
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: theme.colorScheme.onSurface,
      ),
      textStyle: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      fillColor: theme.cardColor,
      hintStyle: theme.textTheme.labelMedium!.copyWith(color: Colors.grey),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.lightPrimary,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          controller.dobController.text =
              "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";
        }
      },
      validator: AppValidators.required,
      suffixIcon: Icon(
        Icons.calendar_today,
        size: 20.r,
        color: AppColors.grey400,
      ),
      readOnly: true,
      label: 'Select DOB',
      hint: 'Select DOB',
      filled: true,
      controller: controller.dobController,
    );
  }

  Widget _buildAgeDropdown() {
    return Obx(
      () => AppDropdownField(
        isRequired: true,
        // isDynamic: true,
        title: "Select Your Age",
        value: controller.selectedAge.value,
        items: controller.ageList.map((e) => e['name']).toList(),
        hintText: 'Select your Age',
        validator: AppValidators.required,
        onChanged: (val) => controller.selectedAge.value = val,
      ),
    );
  }

  Widget _buildReligionDropdown() {
    return Obx(
      () => AppDropdownField(
        isRequired: true,
        isDynamic: true,
        title: "Select Your Religion",
        value: controller.selectedReligion.value,
        items: controller.religionList,
        hintText: 'Select your Religion',
        validator: AppValidators.required,
        onChanged: (val) {
          controller.selectedReligion.value = val;
          controller.fetchCaste(val.toString());
        },
      ),
    );
  }

  Widget _buildCasteDropdown() {
    return Obx(() {
      return AppDropdownField(
        isRequired: true,
        isDynamic: true,
        title: "Select Your Caste",
        value: controller.selectedCaste.value,
        items: controller.casteList,
        hintText: controller.isCasteLoading.value
            ? "Loading caste..."
            : "Select your Caste",
        validator: AppValidators.required,
        onChanged: controller.isCasteLoading.value
            ? null
            : (val) {
                controller.selectedCaste.value = val;
                controller.fetchSubCaste(val.toString());
              },
      );
    });
  }

  Widget _buildSubCasteDropdown() {
    return Obx(() {
      return AppDropdownField(
        isRequired: true,
        isDynamic: true,
        title: "Select Your Subcaste",
        value: controller.selectedSubCaste.value,
        items: controller.subCasteList,
        hintText: controller.isSubCasteLoading.value
            ? "Loading Subcaste..."
            : "Select your Subcaste",
        validator: AppValidators.required,
        onChanged: controller.isSubCasteLoading.value
            ? null
            : (val) => controller.selectedSubCaste.value = val,
      );
    });
  }

  Widget _buildAcceptTerms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SizedBox(
            width: 24.r,
            height: 24.r,
            child: Checkbox(
              value: controller.isTermsAccepted.value,
              onChanged: (value) {
                controller.isTermsAccepted.value = value!;
              },
              activeColor: AppColors.lightPrimary,
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.r),

        /// Text Section
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[700],
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'I have read and agree to the '),

                /// Terms of Use
                TextSpan(
                  text: 'Terms of Use',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightPrimary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (!Get.isRegistered<ProfileController>()) {
                        ProfileBindings().dependencies();
                      }

                      Get.to(() => PolicyData(slug: 'terms_and_conditions'));
                    },
                ),

                const TextSpan(text: ' & '),

                /// Privacy Policy
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightPrimary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (!Get.isRegistered<ProfileController>()) {
                        ProfileBindings().dependencies();
                      }

                      Get.to(() => PolicyData(slug: 'privacy_policy'));
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Obx(
      () => SafeArea(
        child: AppButton(
          text: 'Continue',
          onTap: controller.isLoading.value ? null : _validateAndSubmit,
          backgroundColor: AppColors.lightPrimary,
          type: AppButtonType.secondary,
          textColor: Colors.white,
        ),
      ),
    );
  }

  void _validateAndSubmit() async {
    final form = controller.registerKey.currentState;

    if (form == null) return;

    /// ✅ This is SAFE (outside build)
    if (!form.validate()) {
      showError("Please fill all required fields");
      return;
    }

    if (controller.selectedGender.value == null ||
        controller.selectedGender.value!.isEmpty) {
      showError("Please select your gender");
      return;
    }

    if (!controller.isTermsAccepted.value) {
      showError("Please accept Terms & Privacy Policy");
      return;
    }

    /// SUCCESS
    Get.toNamed(Routes.addProfile);
  }
}
