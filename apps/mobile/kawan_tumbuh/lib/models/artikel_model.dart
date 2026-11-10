import 'package:flutter/material.dart';

/// Kategori artikel yang tersedia.
enum ArtikelKategori { semua, polaAsuh, disgrafia, disleksia, diskalkulia }

extension ArtikelKategoriExt on ArtikelKategori {
  String get label {
    switch (this) {
      case ArtikelKategori.semua:
        return 'Semua';
      case ArtikelKategori.polaAsuh:
        return 'Pola Asuh';
      case ArtikelKategori.disgrafia:
        return 'Disgrafia';
      case ArtikelKategori.disleksia:
        return 'Disleksia';
      case ArtikelKategori.diskalkulia:
        return 'Diskalkulia';
    }
  }
}

/// Model data satu artikel.
class ArtikelModel {
  const ArtikelModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tanggal,
    required this.imagePath,
    required this.detailImagePath,
    required this.intro,
    required this.poinPoin,
    required this.isi,
  });

  final String id;
  final String judul;
  final ArtikelKategori kategori;
  final DateTime tanggal;

  /// Gambar thumbnail di list
  final String imagePath;

  /// Gambar ilustrasi besar di halaman detail
  final String detailImagePath;

  /// Paragraf pembuka di halaman detail
  final String intro;

  /// Poin-poin bernomor di halaman detail
  final List<String> poinPoin;

  /// Isi lengkap artikel (halaman selengkapnya)
  final String isi;

  /// Format tanggal ke "12 November 2026" tanpa intl locale
  String get tanggalFormatted {
    const bulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${tanggal.day} ${bulan[tanggal.month]} ${tanggal.year}';
  }

  /// Warna badge kategori
  Color get badgeColor {
    switch (kategori) {
      case ArtikelKategori.disleksia:
        return const Color(0xFF5F8F8A);
      case ArtikelKategori.disgrafia:
        return const Color(0xFFE8A838);
      case ArtikelKategori.diskalkulia:
        return const Color(0xFFF57568);
      case ArtikelKategori.polaAsuh:
        return const Color(0xFFF88D96);
      case ArtikelKategori.semua:
        return const Color(0xFF5F8F8A);
    }
  }
}
