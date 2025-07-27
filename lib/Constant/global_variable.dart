import 'package:flutter/material.dart';

String uri = 'https://event-grid-2-0-server.onrender.com';

class GlobalVariables {
  // COLORS - Updated to match web app violet/purple/indigo theme

  // Primary gradient matching the web app's violet-to-indigo theme
  static const appBarGradient = LinearGradient(
    colors: [
      Color(0xFF8B5CF6), // violet-500
      Color(0xFF7C3AED), // violet-600
      Color(0xFF6366F1), // indigo-500
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Alternative gradient for cards and sections
  static const cardGradient = LinearGradient(
    colors: [
      Color(0xFFF3F4F6), // gray-100
      Color(0xFFEDE9FE), // violet-100
      Color(0xFFE0E7FF), // indigo-100
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Primary colors
  static const primaryColor = Color(0xFF8B5CF6); // violet-500
  static const primaryDarkColor = Color(0xFF7C3AED); // violet-600
  static const primaryLightColor = Color(0xFFEDE9FE); // violet-100

  // Secondary colors
  static const secondaryColor = Color(0xFF6366F1); // indigo-500
  static const secondaryDarkColor = Color(0xFF4F46E5); // indigo-600
  static const secondaryLightColor = Color(0xFFE0E7FF); // indigo-100

  // Accent colors
  static const accentColor = Color(0xFF8B5CF6); // violet-500
  static const accentLightColor = Color(0xFFC4B5FD); // violet-300

  // Background colors
  static const backgroundColor = Colors.white;
  static const backgroundSecondaryColor = Color(0xFFF9FAFB); // gray-50
  static const greyBackgroundColor = Color(0xFFF3F4F6); // gray-100

  // Text colors
  static const textPrimaryColor = Color(0xFF111827); // gray-900
  static const textSecondaryColor = Color(0xFF6B7280); // gray-500
  static const textTertiaryColor = Color(0xFF9CA3AF); // gray-400

  // Navigation colors
  static const selectedNavBarColor = Color(0xFF8B5CF6); // violet-500
  static const unselectedNavBarColor = Color(0xFF6B7280); // gray-500

  // Button colors
  static const buttonPrimaryColor = Color(0xFF8B5CF6); // violet-500
  static const buttonSecondaryColor = Color(0xFF6366F1); // indigo-500
  static const buttonTextColor = Colors.white;

  // Status colors
  static const successColor = Color(0xFF10B981); // emerald-500
  static const warningColor = Color(0xFFF59E0B); // amber-500
  static const errorColor = Color(0xFFEF4444); // red-500
  static const infoColor = Color(0xFF3B82F6); // blue-500

  // Border and divider colors
  static const borderColor = Color(0xFFE5E7EB); // gray-200
  static const dividerColor = Color(0xFFE5E7EB); // gray-200

  // Shadow colors
  static const shadowColor = Color(0x1A000000); // black with 10% opacity
  static const shadowLightColor = Color(0x0D000000); // black with 5% opacity

  // Gradient combinations for different UI elements
  static const heroGradient = LinearGradient(
    colors: [
      Color(0xFF8B5CF6), // violet-500
      Color(0xFF7C3AED), // violet-600
      Color(0xFF6366F1), // indigo-500
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const subtleGradient = LinearGradient(
    colors: [
      Color(0xFFF9FAFB), // gray-50
      Color(0xFFEDE9FE), // violet-100
    ],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Material Color Swatch for ThemeData
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF8B5CF6, // violet-500
    <int, Color>{
      50: Color(0xFFF5F3FF), // violet-50
      100: Color(0xFFEDE9FE), // violet-100
      200: Color(0xFFDDD6FE), // violet-200
      300: Color(0xFFC4B5FD), // violet-300
      400: Color(0xFFA78BFA), // violet-400
      500: Color(0xFF8B5CF6), // violet-500
      600: Color(0xFF7C3AED), // violet-600
      700: Color(0xFF6D28D9), // violet-700
      800: Color(0xFF5B21B6), // violet-800
      900: Color(0xFF4C1D95), // violet-900
    },
  );
}

// Theme Data configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: GlobalVariables.primaryColor,
      scaffoldBackgroundColor: GlobalVariables.backgroundColor,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: GlobalVariables.textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: GlobalVariables.textPrimaryColor),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: GlobalVariables.backgroundColor,
        elevation: 2,
        shadowColor: GlobalVariables.shadowLightColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GlobalVariables.primaryColor,
          foregroundColor: GlobalVariables.buttonTextColor,
          elevation: 2,
          shadowColor: GlobalVariables.shadowColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: GlobalVariables.textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: GlobalVariables.textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: GlobalVariables.textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: GlobalVariables.textSecondaryColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: GlobalVariables.backgroundColor,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      colorScheme: const ColorScheme.light(
        primary: GlobalVariables.primaryColor,
        secondary: GlobalVariables.secondaryColor,
        surface: GlobalVariables.backgroundColor,
        background: GlobalVariables.backgroundColor,
        error: GlobalVariables.errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: GlobalVariables.textPrimaryColor,
        onBackground: GlobalVariables.textPrimaryColor,
        onError: Colors.white,
      ).copyWith(background: GlobalVariables.backgroundColor),
      primarySwatch: GlobalVariables.primarySwatch,
    );
  }
}
