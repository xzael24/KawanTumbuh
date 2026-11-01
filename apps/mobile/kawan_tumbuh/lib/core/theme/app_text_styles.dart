import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Helper text style terpusat.
/// Gunakan method statis ini di seluruh aplikasi.
class AppTextStyles {
  AppTextStyles._();

  /// Sora — dipakai untuk judul / heading besar.
  static TextStyle sora(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
  }) {
    return GoogleFonts.sora(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  /// Inter — dipakai untuk body, label, dan sub-judul.
  static TextStyle inter(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // — Shortcut style yang sering dipakai —
  static TextStyle get headingLarge =>
      sora(24, FontWeight.w700, AppColors.textDark, height: 1.35);

  static TextStyle get bodyMuted =>
      inter(13, FontWeight.w400, AppColors.textMuted, height: 1.6);

  static TextStyle get labelDark =>
      inter(14, FontWeight.w600, AppColors.textDark);
}
