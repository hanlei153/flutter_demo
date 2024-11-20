import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const ImageSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  ImageSliderState createState() => ImageSliderState();
}

class ImageSliderState extends State<ImageSlider> {
  final PageController pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();

    pageController.addListener(() {
      _currentPage = pageController.page!.round();
    });
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < widget.imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // 回到第一张
      }
      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    _timer?.cancel(); // 仅在 _timer 不为空时取消计时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Column(children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.darken),
                        child: Image.asset(widget.imageUrls[index],
                            fit: BoxFit.cover),
                      ),
                    ),
                  ));
            },
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: widget.imageUrls.length,
          effect: ExpandingDotsEffect(
            activeDotColor: const Color.fromARGB(255, 239, 234, 234),
            dotColor: const Color.fromARGB(255, 136, 136, 136),
            dotHeight: 10,
            dotWidth: 8,
            spacing: 7,
          ),
        ),
      ]),
    );
  }
}
