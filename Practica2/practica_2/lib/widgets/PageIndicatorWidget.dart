import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

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
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        final colors = themeService.currentColors;
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: const Color.fromARGB(0, 0, 0, 0), // Fondo transparente
          child: SmoothPageIndicator(
            controller: pageController,
            count: totalPages,
            effect: SlideEffect(
              dotHeight: 12,
              dotWidth: 12,
              radius: 8,
              spacing: 10,
              dotColor: colors.pageIndicatorDotColor,
              activeDotColor: colors.pageIndicatorActiveDotColor,
              type: SlideType.normal,
            ),
          ),
        );
      },
    );
  }
}


