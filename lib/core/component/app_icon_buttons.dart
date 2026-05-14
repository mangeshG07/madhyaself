import '../exporters/app_export.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
  });

  final dynamic icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: HugeIcon(icon: icon, size: 16.r, color: iconColor),
      ),
    );
  }
}
