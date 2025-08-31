import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D47A1); // A deep blue
  static const Color accentColor = Color(0xFF1976D2);  // A lighter blue
  static const Color textColor = Color(0xFF333333);
  static const Color subtleTextColor = Color(0xFF757575);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: accentColor,
        // Use `surface` and `onSurface` as `background` and `onBackground` are deprecated
        surface: backgroundColor, // Mapped background to surface
        onSurface: textColor,    // Mapped onBackground to onSurface
        // Keep existing explicit surface and onSurface if they were different
        // For example, if cardColor was meant for general surfaces:
        // surface: cardColor, 
        // onSurface: textColor, 
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
        bodyLarge: GoogleFonts.poppins(fontSize: 14, color: textColor),
        bodyMedium: GoogleFonts.poppins(fontSize: 12, color: subtleTextColor),
        labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      // Changed CardTheme to CardThemeData
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: cardColor,
      ),
      chipTheme: ChipThemeData(
        // Updated withOpacity to withAlpha for more precise control if needed,
        // or keep withOpacity if the visual result is acceptable and warning is minor.
        backgroundColor: accentColor.withAlpha((255 * 0.1).round()), // Alternative to withOpacity(0.1)
        selectedColor: accentColor,
        labelStyle: GoogleFonts.poppins(color: textColor),
        secondaryLabelStyle: GoogleFonts.poppins(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: cardColor,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
