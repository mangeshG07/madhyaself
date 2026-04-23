import 'package:dropdown_search/dropdown_search.dart';
import '../exporters/app_export.dart';

class AppDropdownSearch<T> extends StatelessWidget {
  final String title;
  final bool isRequired;
  final T? value;
  final List<T> items;
  final String hintText;
  final String searchHintText;
  final double dropdownHeight;
  final bool showSearchBox;
  final bool showTitle;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String Function(T)? itemAsString;

  const AppDropdownSearch({
    super.key,
    required this.title,
    this.isRequired = false,
    this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.searchHintText,
    this.dropdownHeight = 300,
    this.showSearchBox = true,
    this.showTitle = true,
    this.validator,
    this.itemAsString,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
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

        /// Dropdown
        DropdownSearch<T>(
          selectedItem: value,
          compareFn: (a, b) => a == b,
          validator: validator,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: _border(),
              focusedBorder: theme.inputDecorationTheme.focusedBorder,
              enabledBorder: theme.inputDecorationTheme.enabledBorder,
              fillColor: theme.cardColor,
              hintStyle: theme.textTheme.labelMedium!.copyWith(
                color: Colors.grey,
              ),
              errorBorder: _border(color: Colors.red),
            ),
          ),

          items: (filter, _) => items,
          itemAsString: itemAsString ?? (e) => e.toString(),

          popupProps: PopupProps.menu(
            showSearchBox: showSearchBox,
            constraints: BoxConstraints.tightFor(height: dropdownHeight),
            menuProps: MenuProps(backgroundColor: theme.cardColor),
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(
                  itemAsString != null ? itemAsString!(item) : item.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              );
            },

            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: searchHintText,
                hintStyle: TextStyle(fontSize: 14.sp),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: _border(),
              ),
            ),
          ),

          onSelected: onChanged,
        ),
      ],
    );
  }

  OutlineInputBorder _border({Color color = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: color),
    );
  }
}
