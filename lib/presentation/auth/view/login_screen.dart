import 'package:madhya/core/exporters/app_export.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.bgColor
          : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          color: theme.brightness == Brightness.light
              ? AppColors.bgColor
              : theme.scaffoldBackgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: [buildBackgroundImage(theme), _buildForm(theme)],
          ),
        ),
      ),
    );
  }

  ///Login Form///
  Widget _buildForm(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.loginKey,
          child: Column(
            spacing: 12.h,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              buildTitle("Let's set\nyour account up"),
              buildSubTitle(
                "Enter a number to receive a confirmation code",
                theme,
              ),
              const SizedBox(height: 22),
              _buildNumberField(theme),
              const SizedBox(height: 22),
              _buildContinueButton(),
              // AppButton(
              //   text: 'Login with Face ID / Fingerprint',
              //   onTap: () {},
              //   backgroundColor: theme.cardColor,
              //   textColor: AppColors.lightTextLowColor,
              //   type: AppButtonType.secondary,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(ThemeData theme) {
    return Row(
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(
              color: theme.brightness == Brightness.light
                  ? Colors.transparent
                  : theme.inputDecorationTheme.enabledBorder!.borderSide.color,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            spacing: 8.w,
            children: [
              Image.asset(AppAssets.flag, width: 25.0, height: 25.0),
              AppText(text: '+91', fontSize: 14.sp),
            ],
          ),
        ),

        Expanded(
          child: AppTextField(
            filled: true,
            label: 'Enter Number',
            showLabel: false,
            hint: 'Enter Number',
            contentPadding: const EdgeInsets.all(15),
            focusedBorder: theme.inputDecorationTheme.focusedBorder,
            enabledBorder: theme.inputDecorationTheme.enabledBorder,
            textStyle: TextStyle(color: theme.colorScheme.onSurface),
            validator: AppValidators.phone,
            labelStyle: theme.textTheme.labelLarge,
            controller: controller.numberController,
            fillColor: theme.cardColor,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
        ),
      ],
    );
  }

  ///Login Button///
  Widget _buildContinueButton() {
    return Obx(
      () => AppButton(
        size: AppButtonSize.medium,
        text: 'Continue',
        loading: controller.isLoading.value,
        onTap: controller.login,
        backgroundColor: AppColors.lightPrimary,
      ),
    );
  }
}
