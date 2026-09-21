import 'package:flutter/material.dart';

class AppTheme {
  static const _ink = Color(0xFF17212B);
  static const _teal = Color(0xFF007C83);
  static const _coral = Color(0xFFE66B4D);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _teal,
      brightness: brightness,
      primary: _teal,
      secondary: _coral,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF7F8F5)
          : const Color(0xFF101719),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(height: 1.45),
      ).apply(bodyColor: brightness == Brightness.light ? _ink : null),
    );
  }
}
