import '../exporters/app_export.dart';

class AppCustomSlider extends StatefulWidget {
  final List imageUrls;
  final double? height;
  final double borderRadius;
  final EdgeInsets? margin;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCustomSlider({
    super.key,
    required this.imageUrls,
    required this.height,
    this.borderRadius = 12,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<AppCustomSlider> createState() => _AppCustomSliderState();
}

class _AppCustomSliderState extends State<AppCustomSlider> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height?.h ?? 200.h,
            viewportFraction: 0.75,
            enlargeCenterPage: true,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, _) => _currentIndex.value = index,
          ),
          items: widget.imageUrls
              .map<Widget>((v) => MatchCardOverlay(details: v))
              .toList(),
        ),
      ],
    );
  }
}
