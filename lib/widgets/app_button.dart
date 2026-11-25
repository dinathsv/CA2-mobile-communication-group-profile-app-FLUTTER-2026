import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.loading = false,
    this.loadingLabel = 'Loading',
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final bool loading;
  final String loadingLabel;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: ButtonStyle(
        foregroundBuilder: (context, states, child) => AnimatedScale(
          scale: !reduceMotion && states.contains(WidgetState.pressed)
              ? 0.94
              : 1,
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: child,
        ),
      ),
      child: AnimatedSwitcher(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 160),
        child: loading
            ? Semantics(
                key: const ValueKey('loading'),
                liveRegion: true,
                label: loadingLabel,
                child: ExcludeSemantics(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!reduceMotion) ...[
                        SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(child: Text(loadingLabel)),
                    ],
                  ),
                ),
              )
            : Row(
                key: const ValueKey('label'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(label)),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, size: 19),
                  ],
                ],
              ),
      ),
    );
  }
}
