import '../exporters/app_export.dart';

class CustomToggle extends StatelessWidget {
  final InterestController controller;

  const CustomToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Obx(() {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isLight ? AppColors.catBgColor : AppColors.grey700,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(controller.labels.length, (index) {
            final isSelected = controller.selectedType.value == index;

            return GestureDetector(
              onTap: () async {
                controller.selectedType.value = index;
                await controller.getInterestList(isRefresh: true);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isLight ? AppColors.catBgColor : AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.labels[index],
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isSelected
                        ? isLight
                              ? AppColors.lightPrimary
                              : Colors.white
                        : AppColors.lightTextLowColor,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
