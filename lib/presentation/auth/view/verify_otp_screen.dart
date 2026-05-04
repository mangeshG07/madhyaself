import 'package:madhya/core/exporters/app_export.dart';

class VerifyOTPScreen extends GetView<OtpController> {
  const VerifyOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [buildBackgroundImage(theme), _buildForm(theme)],
        ),
      ),
    );
  }

  /// ---------------- OTP FORM ----------------
  Widget _buildForm(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.verifyKey,
          child: Column(
            spacing: 12.h,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              buildTitle("Enter the code send to"),
              buildSubTitle(
                "We’ve sent a 6-digit OTP on +91 ${Get.find<LoginController>().numberController.text.trim()}",
                theme,
              ),
              const SizedBox(height: 10),
              _buildOTPField('OTP', theme),
              _buildResendOtp(),
              const SizedBox(height: 22),
              _buildVerifyButton(),
              _buildChangeNumber(),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- OTP FIELD ----------------
  Widget _buildOTPField(String label, ThemeData theme) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: theme.textTheme.bodySmall!.color,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabel(text: label, color: theme.colorScheme.onSurface),
        SizedBox(height: 8.h),
        Center(
          child: Pinput(
            controller: controller.otpController,
            length: 6,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || value.isEmpty ? 'OTP is required' : null,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.lightPrimary, width: 2),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.lightPrimary),
              ),
            ),
            onCompleted: (pin) {},
          ),
        ),
      ],
    );
  }

  /// ---------------- RESEND OTP ----------------
  Widget _buildResendOtp() {
    return Align(
      alignment: Alignment.topLeft,
      child: Obx(() {
        return controller.start.value > 0
            ? AppText(
                text:
                    'Didn’t receive it? Resend OTP in (${controller.start.value}s)',
                color: AppColors.lightTextLowColor,
                fontSize: 14.sp,
              )
            : GestureDetector(
                onTap: () => Get.find<LoginController>().login(),
                child: AppText(
                  text: 'Resend OTP',
                  color: AppColors.lightPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
      }),
    );
  }

  /// ---------------- VERIFY BUTTON ----------------
  Widget _buildVerifyButton() {
    return Obx(
      () => AppButton(
        text: 'Verify OTP',
        loading: controller.isLoading.value,
        onTap: () async => await controller.verifyOTP(
          Get.find<LoginController>().numberController.text,
        ),
        backgroundColor: AppColors.lightPrimary,
      ),
    );
  }

  /// ---------------- Change Number ----------------
  Widget _buildChangeNumber() {
    return GestureDetector(
      onTap: () => AllDialogs().changeNumber(
        Get.find<LoginController>().numberController.text,
      ),
      child: Text(
        "Change Mobile Number",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.lightPrimary,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.lightPrimary,
        ),
      ),
    );
  }
}
