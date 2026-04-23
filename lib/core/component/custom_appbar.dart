import '../exporters/app_export.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final double? titleSpacing;
  final bool? centerTitle;
  final Color? backgroundColor;
  final String title;
  const CustomAppbar({
    super.key,
    this.centerTitle = false,
    this.actions,
    this.titleSpacing = 0,
    this.title = '',
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      title: AppText(
        text: title,
        fontSize: 22.sp,
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        fontWeight: FontWeight.bold,
      ),
      leading: BackButton(color: Theme.of(context).colorScheme.onSurface),
      actions: actions,
      elevation: 0,
    );
  }
}
