import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const inkDeep = Color(0xFF0A0F1C);
  static const inkCard = Color(0xFF111A2C);
  static const inkLine = Color(0x29CFA15A);
  static const gold = Color(0xFFCFA15A);
  static const goldLight = Color(0xFFE8CAA0);
  static const parchment = Color(0xFFF2EAD9);
  static const parchmentDim = Color(0xFFA8A191);
  static const sage = Color(0xFF7BA384);
  static const dim = Color(0xFF6B7690);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.inkDeep,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.sage,
        surface: AppColors.inkCard,
        onSurface: AppColors.parchment,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.parchment,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.inkDeep,
        foregroundColor: AppColors.parchment,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.inkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.inkLine),
        ),
      ),
    );
  }
}
