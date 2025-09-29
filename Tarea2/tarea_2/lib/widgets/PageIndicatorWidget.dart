import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicatorWidget extends StatelessWidget {
  final PageController pageController;
  final int totalPages;

  const PageIndicatorWidget({
    super.key,
    required this.pageController,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Color.fromARGB(0, 0, 0, 0), // Fondo negro semitransparente
      child: SmoothPageIndicator(
        controller: pageController,
        count: totalPages,
        effect: const SlideEffect(
          dotHeight: 12,
          dotWidth: 12,
          radius: 8,
          spacing: 10,
          dotColor: Color.fromARGB(255, 200, 200, 200),
          activeDotColor: Color.fromARGB(255, 175, 175, 175),
          type: SlideType.normal,
        ),
      ),
    );
  }
}


