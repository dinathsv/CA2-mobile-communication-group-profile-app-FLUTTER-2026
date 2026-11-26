import 'package:flutter/material.dart';

final _profileCurve = CurveTween(curve: Curves.fastOutSlowIn);
final _profileScale = Tween<double>(begin: 0.96, end: 1);

PageRoute<void> memberProfileRoute(
  BuildContext context,
  WidgetBuilder builder,
) {
  final reducedMotion = MediaQuery.disableAnimationsOf(context);
  return PageRouteBuilder<void>(
    transitionDuration: reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 340),
    reverseTransitionDuration: reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 280),
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (context, animation, _, child) {
      if (reducedMotion || MediaQuery.disableAnimationsOf(context)) {
        return child;
      }

      final progress = animation.drive(_profileCurve);
      return FadeTransition(
        opacity: progress,
        child: ScaleTransition(
          scale: progress.drive(_profileScale),
          child: child,
        ),
      );
    },
  );
}
