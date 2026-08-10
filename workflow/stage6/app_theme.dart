import 'package:flutter/material.dart';

class AppPalette {
  static const Color black = Color(0xFF050806);
  static const Color panel = Color(0xFF0D1410);
  static const Color panelAlt = Color(0xFF101A14);
  static const Color green = Color(0xFF38D27D);
  static const Color greenStrong = Color(0xFF20C067);
  static const Color greenSoft = Color(0xFF183B27);
  static const Color neon = Color(0xFF7CFFB2);
  static const Color text = Color(0xFFEAF8EF);
  static const Color muted = Color(0xFF9DB7A8);
  static const Color border = Color(0xFF1C2B22);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFC857);
}

class AppTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.green,
      brightness: Brightness.dark,
      surface: AppPalette.black,
    ).copyWith(
      primary: AppPalette.green,
      onPrimary: const Color(0xFF04110A),
      secondary: const Color(0xFF6AF2A5),
      onSecondary: const Color(0xFF04110A),
      primaryContainer: AppPalette.greenSoft,
      secondaryContainer: AppPalette.panelAlt,
      surface: AppPalette.black,
      onSurface: AppPalette.text,
      onSurfaceVariant: AppPalette.muted,
      outline: const Color(0xFF2A3C31),
      outlineVariant: AppPalette.border,
      error: AppPalette.danger,
      tertiary: AppPalette.warning,
      surfaceTint: AppPalette.green,
    );

    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppPalette.black,
      canvasColor: AppPalette.black,
      dividerColor: AppPalette.border,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppPalette.text,
        displayColor: AppPalette.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.black,
        foregroundColor: AppPalette.text,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppPalette.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppPalette.border),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppPalette.panelAlt,
        selectedColor: AppPalette.greenSoft,
        side: const BorderSide(color: AppPalette.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(color: AppPalette.text, fontWeight: FontWeight.w600),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppPalette.panel,
        indicatorColor: AppPalette.greenSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppPalette.text : AppPalette.muted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? AppPalette.green : AppPalette.muted);
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppPalette.green,
        linearTrackColor: AppPalette.border,
      ),
      dividerTheme: const DividerThemeData(color: AppPalette.border, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.panel,
        labelStyle: const TextStyle(color: AppPalette.muted),
        hintStyle: const TextStyle(color: AppPalette.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppPalette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppPalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppPalette.green),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppPalette.green,
        textColor: AppPalette.text,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppPalette.panelAlt,
        contentTextStyle: const TextStyle(color: AppPalette.text),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
