import 'package:flutter/material.dart';
import 'package:rick_morty_flutter_app/theme/theme.dart';

abstract class AppTheme {
  static ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: _colorScheme,
        inputDecorationTheme: _inputDecorationTheme,
      );
  static ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: _colorScheme.copyWith(
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: _inputDecorationTheme,
      );

  static ColorScheme get _colorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColors.hawkesBlue,
      background: AppColors.white,
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }
}
