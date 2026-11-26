import 'package:flutter/material.dart';

final _profileCurve = CurveTween(curve: Curves.fastOutSlowIn);
final _profileSlide = Tween<Offset>(
  begin: const Offset(0.035, 0),
  end: Offset.zero,
);

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
      return SlideTransition(
        position: progress.drive(_profileSlide),
        textDirection: Directionality.of(context),
        child: FadeTransition(opacity: progress, child: child),
      );
    },
  );
}
