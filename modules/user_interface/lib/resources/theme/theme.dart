import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';

class Themes {
  static final ThemeData materialLightTheme = ThemeData(
    primaryColor: AppColors.primarySwatch,
    brightness: Brightness.light,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      surfaceTintColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 10.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: AppColors.primarySwatch,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
    ).copyWith(
      secondary: AppColors.secondaryColor,
      error: AppColors.errorToast,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textBodyDark,
      surface: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4.0,
      shadowColor: AppColors.dotIndicator,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primarySwatch,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: AppColors.primarySwatch, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: AppColors.primarySwatch, width: 2.0),
      ),
      labelStyle: TextStyle(color: AppColors.textBodyDark),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primarySwatch,
      foregroundColor: Colors.white,
      elevation: 4.0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primarySwatch,
      unselectedItemColor: AppColors.textBodyDark,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textTitleDark,
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.textTitleDark,
        fontSize: 28.0,
      ),
      displaySmall: TextStyle(
        color: AppColors.textTitleDark,
        fontSize: 22.0,
      ),
      headlineLarge: TextStyle(
        color: AppColors.textTitleDark,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textBodyDark,
        fontSize: 18.0,
      ),
      headlineSmall: TextStyle(
        color: AppColors.textBodyDark,
        fontSize: 16.0,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textBodyDark,
        fontSize: 16.0,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textBodyDark,
        fontSize: 14.0,
      ),
      bodySmall: TextStyle(
        color: AppColors.textBodyDark,
        fontSize: 12.0,
      ),
    ),
  );
}
