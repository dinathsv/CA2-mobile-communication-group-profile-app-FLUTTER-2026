import 'package:flutter/cupertino.dart' show CupertinoPageTransition;
import 'package:flutter/material.dart';

PageRoute<void> memberProfileRoute(
  BuildContext context,
  WidgetBuilder builder,
) {
  final reducedMotion = MediaQuery.disableAnimationsOf(context);
  return PageRouteBuilder<void>(
    transitionDuration: reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 540),
    reverseTransitionDuration: reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 440),
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (reducedMotion || MediaQuery.disableAnimationsOf(context)) {
        return child;
      }

      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false,
        child: child,
      );
    },
  );
}
