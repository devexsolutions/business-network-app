import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Color constants for easy access
  static const Color primaryGreen = Color(AppConstants.primaryColorValue);
  static const Color secondaryGreen = Color(AppConstants.secondaryColorValue);
  static const Color accentGreen = Color(AppConstants.accentColorValue);
  static const Color accentOrange = Color(AppConstants.warningColorValue);
  static const Color backgroundColor = Color(AppConstants.backgroundColorValue);
  static const Color surfaceColor = Color(AppConstants.surfaceColorValue);
  static const Color cardColor = Color(AppConstants.cardColorValue);
  static const Color textPrimary = Color(AppConstants.textPrimaryValue);
  static const Color textSecondary = Color(AppConstants.textSecondaryValue);
  static const Color textLight = Color(AppConstants.textLightValue);
  static const Color successColor = Color(AppConstants.successColorValue);
  static const Color warningColor = Color(AppConstants.warningColorValue);
  static const Color errorColor = Color(AppConstants.errorColorValue);
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppConstants.primaryColorValue),
        brightness: Brightness.light,
        surface: const Color(AppConstants.surfaceColorValue),
        background: const Color(AppConstants.backgroundColorValue),
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(AppConstants.primaryColorValue),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: const Color(AppConstants.surfaceColorValue),
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing,
          vertical: AppConstants.spacing / 2,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppConstants.primaryColorValue),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(AppConstants.cardColorValue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(
            color: Color(AppConstants.primaryColorValue),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing,
          vertical: AppConstants.spacing,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(AppConstants.surfaceColorValue),
        selectedItemColor: Color(AppConstants.primaryColorValue),
        unselectedItemColor: Color(AppConstants.textSecondaryValue),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(AppConstants.textPrimaryValue),
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(AppConstants.textPrimaryValue),
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textPrimaryValue),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textPrimaryValue),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.textPrimaryValue),
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.textPrimaryValue),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(AppConstants.textPrimaryValue),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(AppConstants.textSecondaryValue),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(AppConstants.textLightValue),
        ),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: const Color(AppConstants.backgroundColorValue),
    );
  }

  // Gradientes personalizados
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, secondaryGreen],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceColor, cardColor],
  );

  // Sombras personalizadas
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];
}
