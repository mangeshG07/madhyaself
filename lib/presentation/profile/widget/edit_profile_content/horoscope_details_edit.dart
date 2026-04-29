import 'package:madhya/core/exporters/app_export.dart';

class HoroscopeDetailsEdit extends GetView<ProfileController> {
  const HoroscopeDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Horoscope details Edit',
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.horoscopeDetailsFormKey,
            child: Column(
              spacing: 12.h,
              children: [
                Row(
                  spacing: 16.w,
                  children: [
                    Expanded(child: _buildBirthTime(theme)),
                    Expanded(child: _buildBirthDate(theme)),
                  ],
                ),
                _buildRashiDropdown(),
                _buildUploadDocuments(theme),
                SizedBox(height: 16.h),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⏰ TIME PICKER
  Widget _buildBirthTime(ThemeData theme) {
    return AppTextField(
      filled: true,
      label: "Birth Time",
      showLabel: true,
      isRequired: true,
      readOnly: true,
      minLines: 1,
      maxLines: 10,
      hint: "HH:MM AM/PM",
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.lightPrimary, // header bg color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                dialogTheme: DialogThemeData(backgroundColor: Colors.black),
              ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          final hour = pickedTime.hourOfPeriod == 0
              ? 12
              : pickedTime.hourOfPeriod;

          final period = pickedTime.period == DayPeriod.am ? "AM" : "PM";

          controller.birthTimeController.text =
              "${hour.toString().padLeft(2, '0')}:"
              "${pickedTime.minute.toString().padLeft(2, '0')} $period";
        }
      },
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface),
      validator: AppValidators.required,
      labelStyle: theme.textTheme.labelMedium,
      controller: controller.birthTimeController,
      fillColor: theme.cardColor,
      keyboardType: TextInputType.text,
    );
  }

  // 📅 DATE PICKER
  Widget _buildBirthDate(ThemeData theme) {
    return AppTextField(
      filled: true,
      label: "Birth Date",
      showLabel: true,
      isRequired: true,
      hint: "DD/MM/YYYY",
      readOnly: true,
      minLines: 1,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.lightPrimary, // header bg color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                dialogTheme: DialogThemeData(backgroundColor: Colors.black),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          controller.birthDateController.text =
              "${pickedDate.day.toString().padLeft(2, '0')}/"
              "${pickedDate.month.toString().padLeft(2, '0')}/"
              "${pickedDate.year}";
        }
      },
      suffixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HugeIcon(
          icon: HugeIconsStrokeRounded.calendar02,
          size: 20.r,
          color: theme.colorScheme.onSurface,
          strokeWidth: 1,
        ),
      ),
      contentPadding: const EdgeInsets.all(15),
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder,
      textStyle: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14.sp),
      validator: AppValidators.required,
      labelStyle: theme.textTheme.labelMedium,
      controller: controller.birthDateController,
      fillColor: theme.cardColor,
      keyboardType: TextInputType.text,
    );
  }

  // 🔽 RASHI
  Widget _buildRashiDropdown() {
    return AppDropdownField(
      isRequired: true,
      title: "Star / Rashi",
      value: controller.selectedRashi.value,
      items: controller.rashiList.map((e) => e['name']).toList(),
      hintText: 'Select Rashi',
      validator: AppValidators.required,
      onChanged: (val) => controller.selectedRashi.value = val,
    );
  }

  // 📎 FILE UPLOAD
  Widget _buildUploadDocuments(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.scaffoldBackgroundColor,
      ),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            AppFilePicker.open(
              onPicked: (file) {
                controller.horoscopeFile.value = file;
              },
            );
          },
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(12),
              dashPattern: [1, 1],
              color: AppColors.grey400,
              strokeWidth: 0.5,
              padding: EdgeInsets.all(16),
            ),

            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              child: Column(
                spacing: 8.h,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedCloudUpload),
                  AppText(
                    text: controller.horoscopeFile.value == null
                        ? "Upload Horoscope"
                        : "File Selected",
                    fontSize: 13.sp,
                  ),
                  if (controller.horoscopeFile.value == null)
                    AppText(
                      text: 'Click here to and upload Horoscope'.tr,
                      color: AppColors.grey500,
                      fontSize: 14.sp,
                    ),
                  if (controller.horoscopeFile.value != null)
                    AppText(
                      text: controller.horoscopeFile.value!.path
                          .split('/')
                          .last,
                      fontSize: 11.sp,
                      color: theme.hintColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => controller.isUpdateLoading.isTrue
          ? AppLoader.circular(
              color: AppColors.lightPrimary,
              strokeWidth: 2.5,
              size: 22.r,
            )
          : AppButton(
              text: 'Save Changes',
              onTap: () async {
                if (controller.horoscopeDetailsFormKey.currentState!
                    .validate()) {
                  await controller.updateHoroscopeDetails();
                }
              },
              backgroundColor: AppColors.lightPrimary,
            ),
    );
  }
}
