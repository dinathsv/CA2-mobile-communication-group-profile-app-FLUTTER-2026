import 'package:flutter/material.dart';

Route<void> memberProfileRoute(BuildContext context, WidgetBuilder builder) {
  final reducedMotion = MediaQuery.disableAnimationsOf(context);
  final duration = reducedMotion
      ? Duration.zero
      : const Duration(milliseconds: 300);

  return PageRouteBuilder<void>(
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (reducedMotion || MediaQuery.disableAnimationsOf(context)) {
        return child;
      }

      final backgroundFade = animation.drive(
        CurveTween(curve: const Interval(0, 0.28, curve: Curves.easeOut)),
      );
      final contentFade = animation.drive(
        CurveTween(curve: const Interval(0.28, 1, curve: Curves.easeOut)),
      );
      final slide = animation
          .drive(CurveTween(curve: Curves.easeOutCubic))
          .drive(
            Tween<Offset>(begin: const Offset(0, 0.044), end: Offset.zero),
          );
      return Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: backgroundFade,
            child: IgnorePointer(
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          FadeTransition(
            opacity: contentFade,
            child: SlideTransition(position: slide, child: child),
          ),
        ],
      );
    },
  );
}
