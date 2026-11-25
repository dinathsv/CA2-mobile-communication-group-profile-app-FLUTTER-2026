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

  static ThemeData portal(ThemeData theme) {
    final dark = theme.brightness == Brightness.dark;
    final accent = dark ? const Color(0xffc2b7ff) : const Color(0xff4e3ca5);
    final scheme = theme.colorScheme.copyWith(
      primary: accent,
      surface: dark ? const Color(0xff111017) : const Color(0xfffbf9fd),
      surfaceContainerLow: dark ? const Color(0xff222033) : Colors.white,
      surfaceContainerHighest: dark
          ? const Color(0xff302a46)
          : const Color(0xffeae3f7),
      outlineVariant: dark ? const Color(0xff433957) : const Color(0xffdfdaeb),
      onPrimary: dark ? const Color(0xff1b1039) : Colors.white,
      onSurface: dark ? const Color(0xfff8f6ff) : const Color(0xff201a32),
      onSurfaceVariant: dark
          ? const Color(0xffb9b3cc)
          : const Color(0xff625a77),
    );
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: dark ? const Color(0xff3a354d) : const Color(0xffdfdaeb),
      ),
    );

    return theme.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        fillColor: dark ? const Color(0xff222033) : const Color(0xfff8f6fc),
        prefixIconColor: scheme.onSurfaceVariant,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: accent),
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: accent, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static RadialGradient portalBackdrop(Brightness brightness) {
    return RadialGradient(
      center: const Alignment(0, -0.31),
      radius: 0.94,
      colors: brightness == Brightness.dark
          ? const [Color(0xff231e35), Color(0xff111017)]
          : const [Color(0xffeee8fb), Color(0xfffbf9fd)],
    );
  }

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
