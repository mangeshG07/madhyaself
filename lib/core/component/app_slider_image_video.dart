import 'package:madhya/core/exporters/app_export.dart';

class AppCarouselImageVideoSlider extends StatefulWidget {
  final List<Map<String, dynamic>> sliderItems;

  final double? height;
  final double borderRadius;
  final EdgeInsets? margin;

  final bool autoPlay;
  final Duration autoPlayInterval;

  final Color activeIndicatorColor;
  final Color inactiveIndicatorColor;

  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCarouselImageVideoSlider({
    super.key,
    required this.sliderItems,
    required this.height,
    this.borderRadius = 12,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.activeIndicatorColor = Colors.blue,
    this.inactiveIndicatorColor = Colors.grey,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<AppCarouselImageVideoSlider> createState() =>
      _AppCarouselImageVideoSliderState();
}

class _AppCarouselImageVideoSliderState
    extends State<AppCarouselImageVideoSlider> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sliderItems.isEmpty) {
      return const SizedBox();
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height?.h ?? 200.h,
            viewportFraction: 1,
            autoPlay: widget.sliderItems.length > 1 ? widget.autoPlay : false,
            enableInfiniteScroll: widget.sliderItems.length > 1,

            scrollPhysics: widget.sliderItems.length > 1
                ? null
                : const NeverScrollableScrollPhysics(),
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              _currentIndex.value = index;
            },
          ),
          items: widget.sliderItems
              .map((item) => _buildSliderItem(item))
              .toList(),
        ),
        if (widget.sliderItems.length > 1) _buildIndicators(),
      ],
    );
  }

  Widget _buildSliderItem(Map<String, dynamic> item) {
    final imageUrl = (item['image'] ?? '').toString();

    final videoUrl = (item['video'] ?? '').toString();

    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: videoUrl.isNotEmpty
            ? AppVideoPlayer(videoUrl: videoUrl)
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) =>
                    widget.placeholder ??
                    AppLoader.circular(
                      color: AppColors.lightPrimary,
                      size: 20.r,
                      strokeWidth: 2,
                    ),
                errorWidget: (_, __, ___) =>
                    widget.errorWidget ?? const Icon(Icons.broken_image),
              ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ValueListenableBuilder<int>(
        valueListenable: _currentIndex,
        builder: (_, index, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.sliderItems.length, (i) {
              final isActive = index == i;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 10 : 8,
                height: isActive ? 10 : 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? widget.activeIndicatorColor
                      : widget.inactiveIndicatorColor,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class AppVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const AppVideoPlayer({super.key, required this.videoUrl});

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!controller.value.isInitialized) {
      return CustomShimmerWidget.single(
        width: double.infinity,
        baseColor: theme.brightness == Brightness.light
            ? Colors.grey.shade300
            : Colors.grey.shade800,
        highlightColor: theme.brightness == Brightness.light
            ? Colors.grey.shade100
            : Colors.grey.shade700,
        height: Get.height * 0.23.h,
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
