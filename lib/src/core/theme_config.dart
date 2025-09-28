import 'package:flutter/material.dart';

class ThemeConfig {
  static final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF3A3A98),
    ),
    useMaterial3: true,
  );
  static final ThemeData lightTheme = base.copyWith(
    brightness: Brightness.light,
    primaryColor: Color(0xFF3A3A98),
    scaffoldBackgroundColor: Color(0xFF1D2671),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1D2671),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.grey,
      elevation: 0.8,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: base.textTheme.bodyLarge!.copyWith(
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xFF3A3A98)),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF1D2671),
      surfaceTintColor: Colors.white,
      titleTextStyle: base.textTheme.headlineSmall!.copyWith(
        color: Colors.white,
      ),
      contentTextStyle: base.textTheme.bodyLarge!.copyWith(
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: base.textTheme.bodyLarge!.copyWith(
        color: Colors.white,
      ),
      headlineMedium: base.textTheme.headlineMedium!.copyWith(
        color: Colors.white,
      ),
      headlineSmall: base.textTheme.headlineSmall!.copyWith(
        color: Colors.white,
      ),
    ),
  );

  static final ThemeData darkTheme = base.copyWith(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.grey,
      elevation: 0.8,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF1D2671),
      surfaceTintColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyMedium: base.textTheme.bodyLarge!.copyWith(
        color: Colors.white,
      ),
      headlineMedium: base.textTheme.headlineMedium!.copyWith(
        color: Colors.white,
      ),
      headlineSmall: base.textTheme.headlineSmall!.copyWith(
        color: Colors.white,
      ),
    ),
  );
}
