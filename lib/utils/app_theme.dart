import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkGold = Color(0xFFB8860B);
  static const Color lightGold = Color(0xFFF5E6A3);
  static const Color deepBlue = Color(0xFF1A237E);
  static const Color silverGray = Color(0xFF9E9E9E);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGold,
        brightness: Brightness.light,
        primary: primaryGold,
        secondary: deepBlue,
        surface: cardBackground,
        background: backgroundLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGold,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: silverGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: primaryGold,
        unselectedItemColor: silverGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: deepBlue,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: deepBlue,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepBlue,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: deepBlue,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AppConstants {
  static const String appName = 'Jewelry Management';
  static const String currency = '₫';

  // API endpoints (mock)
  static const String baseUrl = 'https://api.jewelry-app.com';

  // Image paths
  static const String imagePath = 'assets/images/';
  static const String jewelryImagePath = 'assets/images/jewelry/';
  static const String iconPath = 'assets/images/icons/';

  // Jewelry categories
  static const List<String> categories = [
    'Tất cả',
    'Nhẫn',
    'Dây chuyền',
    'Bông tai',
    'Lắc tay',
    'Đồng hồ',
    'Bộ trang sức',
  ];

  // Material types
  static const List<String> materials = [
    'Vàng 18K',
    'Vàng 14K',
    'Bạc 925',
    'Bạch kim',
    'Kim cương',
    'Đá quý',
  ];
}

extension PriceFormat on double {
  String get formatted {
    return '${toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${AppConstants.currency}';
  }
}
