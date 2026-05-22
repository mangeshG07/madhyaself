import 'package:dropdown_search/dropdown_search.dart';
import '../exporters/app_export.dart';

class AppMultiDropdown extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final String hintText;
  final String? Function(List<String>?)? validator;
  final void Function(List<dynamic>) onChanged;
  final bool isRequired;
  final String title;
  final Widget? suffixIcon;

  const AppMultiDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.title,
    this.hintText = "Select",
    this.validator,
    this.suffixIcon,
    this.isRequired = false,
  });

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Colors.grey, width: 0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyles.labelMedium),
            if (isRequired)
              Text(
                " *",
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        DropdownSearch<dynamic>.multiSelection(
          items: (filter, infiniteScrollProps) => items,
          compareFn: (item1, item2) => item1 == item2,
          selectedItems: selectedItems,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              fillColor: theme.scaffoldBackgroundColor,
              filled: true,
              border: _border(),
              prefixIcon: suffixIcon,
              enabledBorder: _border(),
              focusedBorder: _border(),
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          dropdownBuilder: (context, selectedItems) {
            final visibleItems = selectedItems.take(3).toList();
            final remainingCount = selectedItems.length - visibleItems.length;

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...visibleItems.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isLight
                            ? AppColors.lightBorderPink
                            : theme.dividerTheme.color!,
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }),
                if (remainingCount > 0)
                  Text(
                    "+$remainingCount More",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            );
          },
          popupProps: MultiSelectionPopupProps.menu(
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              );
            },
            showSelectedItems: false,
            fit: FlexFit.tight,
            menuProps: MenuProps(
              surfaceTintColor: theme.scaffoldBackgroundColor,
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            constraints: const BoxConstraints(maxHeight: 300),
          ),

          onSelected: onChanged,
        ),
      ],
    );
  }
}

// AppMultiDropdown(
// items: catController.categories
//     .map((item) => item['name'].toString())
//     .toList(),
// selectedItems: controller.selectedBusiness,
// hintText: "Business Interest",
// validator: (value) {
// if (value == null || value.isEmpty) {
// return "Please select Interest";
// }
// return null;
// },
// onChanged: (selected) {
// controller.selectedBusiness.value = selected;
// },
// ),
