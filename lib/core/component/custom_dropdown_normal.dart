import '../exporters/app_export.dart';

class AppDropdownField extends StatelessWidget {
  final String? value;
  final List items;
  final String title;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool isExpanded;
  final bool isRequired;
  final String? errorText;
  final bool? isDynamic;
  final bool? isWithColor;
  final bool? isHeight;

  const AppDropdownField({
    super.key,
    required this.items,
    required this.title,
    required this.hintText,
    this.value,
    this.validator,
    this.onChanged,
    this.isExpanded = true,
    this.isRequired = false,
    this.errorText,
    this.isWithColor = false,
    this.isDynamic = false,
    this.isHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        ButtonTheme(
          alignedDropdown: true,
          buttonColor: Colors.grey[700],
          splashColor: Colors.transparent,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          child: DropdownButtonFormField(
            borderRadius: BorderRadius.circular(12.r),
            initialValue: value,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
              size: 18,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              isDense: true,
              filled: true,
              fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
              focusedBorder: buildOutlineInputBorder(),
              enabledBorder: buildOutlineInputBorder(),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
              disabledBorder: buildOutlineInputBorder(),
              border: buildOutlineInputBorder(),
              hintText: hintText,
              errorStyle: TextStyle(fontSize: 12.sp),
              errorMaxLines: 1,
            ),
            validator: validator,
            dropdownColor:Get.isDarkMode ? AppColors.grey800 : AppColors.grey300,
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            isExpanded: isExpanded,
            elevation: 4,
            items: isDynamic!
                ? items.map((value) {
                    return DropdownMenuItem(
                      value: isHeight == true
                          ? value['height_in_cm'].toString()
                          : value['id'].toString(),
                      child: isWithColor == true
                          ? Row(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(
                                    int.parse(value['color_code']),
                                  ),
                                ),
                                AppText(
                                  textAlign: TextAlign.start,
                                  text: value['name'],
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 14.sp,
                                ),
                              ],
                            )
                          : AppText(
                              textAlign: TextAlign.start,
                              text: isHeight == true
                                  ? '${value['height_in_cm']} - ${value['height']}'
                                  : value['name'],
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14.sp,
                            ),
                    );
                  }).toList()
                : items.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: AppText(
                        text: value,
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder buildOutlineInputBorder() {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.grey,
      width: 0.2,
    ), // Replace with AppColors.primaryColor
    borderRadius: BorderRadius.circular(10.r),
  );
}
