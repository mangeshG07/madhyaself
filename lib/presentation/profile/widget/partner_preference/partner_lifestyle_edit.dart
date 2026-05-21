import 'package:madhya/core/exporters/app_export.dart';

class PartnerLifestyleEdit extends GetView<PreferenceController> {
  const PartnerLifestyleEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(title: 'Partner Lifestyle & Appearances'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.h,
          children: [
            _buildDietHabits(
              theme,
              'Partners Dietary Habits',
              controller.selectedDiet,
              controller.dietOptionsList,
            ),
            _buildDietHabits(
              theme,
              'Partners Smoking Habits',
              controller.selectedSmoking,
              controller.smokingOptionsList,
            ),
            _buildDietHabits(
              theme,
              'Partners Drinking Habits',
              controller.selectedDrinking,
              controller.drinkingOptionsList,
            ),
            _buildDietHabits(
              theme,
              'Partners Special Case',
              controller.selectedSpecialCase,
              controller.specialCasesList,
            ),

            Obx(
              () => controller.isUpdating.isTrue
                  ? AppLoader.circular(
                      color: AppColors.lightPrimary,
                      strokeWidth: 2.5,
                      size: 22.r,
                    )
                  : AppButton(
                      text: 'Submit',
                      onTap: () async {
                        await controller.updateLifestyleDetails();
                      },
                      backgroundColor: AppColors.lightPrimary,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietHabits(
    ThemeData theme,
    String title,
    Rxn<String> selectedValue,
    RxList data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(
          () => Wrap(
            spacing: 4,
            children: data.first.entries.map<Widget>((e) {
              return ChoiceChip(
                surfaceTintColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8.r),
                ),
                side: BorderSide(color: AppColors.grey500, width: 0.5),
                label: Text(e.value, style: theme.textTheme.bodySmall),
                selectedColor: AppColors.lightPrimary.withValues(alpha: 0.1),
                showCheckmark: false,
                elevation: 0,
                pressElevation: 0,

                selected: selectedValue.value == e.key,
                color: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.lightPrimary.withValues(alpha: 0.1);
                  }
                  return Colors.white;
                }),
                onSelected: (value) {
                  if (value) {
                    selectedValue.value = e.key;
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
