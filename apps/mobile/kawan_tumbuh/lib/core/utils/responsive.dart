import 'package:flutter/material.dart';

/// Responsive helper — scale ukuran berdasarkan lebar layar device.
///
/// Baseline desain: 390px (iPhone 14 / Pixel 7).
/// Semua nilai di-scale proporsional terhadap layar aktual.
///
/// Cara pakai:
///   final r = Responsive.of(context);
///   r.w(24)   // scale horizontal (padding, width)
///   r.h(36)   // scale vertikal (padding, height, spacing)
///   r.sp(14)  // scale font size
///   r.r(12)   // scale radius / circle size
class Responsive {
  Responsive._(this._width, this._height);

  factory Responsive.of(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Responsive._(size.width, size.height);
  }

  final double _width;
  final double _height;

  static const double _baseWidth  = 390.0;
  static const double _baseHeight = 844.0;

  // Skala sumbu X (padding, margin, lebar elemen)
  double get _scaleX => (_width / _baseWidth).clamp(0.75, 1.3);

  // Skala sumbu Y (tinggi elemen, vertical spacing)
  double get _scaleY => (_height / _baseHeight).clamp(0.75, 1.3);

  // Skala font — rata-rata X & Y supaya tidak terlalu ekstrem
  double get _scaleFont => ((_scaleX + _scaleY) / 2).clamp(0.8, 1.2);

  /// Scale lebar / horizontal spacing
  double w(double value) => value * _scaleX;

  /// Scale tinggi / vertical spacing
  double h(double value) => value * _scaleY;

  /// Scale font size
  double sp(double value) => value * _scaleFont;

  /// Scale radius / dimensi bulat (rata-rata X & Y)
  double r(double value) => value * ((_scaleX + _scaleY) / 2).clamp(0.75, 1.3);
}
