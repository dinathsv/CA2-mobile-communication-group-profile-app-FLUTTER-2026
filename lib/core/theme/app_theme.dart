import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const wordmark = TextStyle(
    fontSize: 84,
    height: 0.93,
    fontWeight: FontWeight.w900,
    letterSpacing: -7,
  );

  static final light = _build(
    brightness: Brightness.light,
    surface: const Color(0xfffafaf8),
    panel: const Color(0xffffffff),
    foreground: const Color(0xff171716),
    secondaryText: const Color(0xff585854),
    border: const Color(0xffdeded9),
  );

  static final dark = _build(
    brightness: Brightness.dark,
    surface: const Color(0xff141413),
    panel: const Color(0xff1e1e1d),
    foreground: const Color(0xfff6f6f3),
    secondaryText: const Color(0xffb8b8b2),
    border: const Color(0xff3d3d39),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color surface,
    required Color panel,
    required Color foreground,
    required Color secondaryText,
    required Color border,
  }) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: foreground,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
        ).copyWith(
          surface: surface,
          surfaceContainerLow: panel,
          onSurface: foreground,
          onSurfaceVariant: secondaryText,
          primary: foreground,
          onPrimary: surface,
          outline: secondaryText,
          outlineVariant: border,
        );

    final theme = ThemeData(useMaterial3: true, colorScheme: scheme);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: border),
    );

    return theme.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme: theme.textTheme.copyWith(
        headlineLarge: theme.textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -1.3,
        ),
        headlineSmall: theme.textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
        ),
        titleMedium: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.23,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: panel,
        errorMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: foreground, width: 1.4),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
