import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';
import '../models/artikel_model.dart';

class ArtikelDetailScreen extends StatelessWidget {
  const ArtikelDetailScreen({super.key, required this.artikel});

  final ArtikelModel artikel;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: Kembali + Badge kategori ──────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.w(20), vertical: r.h(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol kembali
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back,
                            size: r.sp(20), color: AppColors.textDark),
                        SizedBox(width: r.w(6)),
                        Text(
                          'Kembali',
                          style: GoogleFonts.inter(
                            fontSize: r.sp(14),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge kategori
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.w(14), vertical: r.h(6)),
                    decoration: BoxDecoration(
                      color: artikel.badgeColor,
                      borderRadius: BorderRadius.circular(r.r(20)),
                    ),
                    child: Text(
                      artikel.kategori.label,
                      style: GoogleFonts.inter(
                        fontSize: r.sp(12),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Konten scrollable ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Ilustrasi artikel
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.w(20)),
                      child: Image.asset(
                        artikel.detailImagePath,
                        width: double.infinity,
                        height: r.h(220),
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) => Container(
                          height: r.h(220),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E8F5),
                            borderRadius: BorderRadius.circular(r.r(16)),
                          ),
                          child: Icon(Icons.image_outlined,
                              size: r.sp(60), color: AppColors.textMuted),
                        ),
                      ),
                    ),

                    SizedBox(height: r.h(16)),

                    // Card konten utama
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: r.w(16)),
                      padding: EdgeInsets.all(r.w(20)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.r(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul
                          Text(
                            artikel.judul,
                            style: GoogleFonts.inter(
                              fontSize: r.sp(18),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                              height: 1.35,
                            ),
                          ),
                          SizedBox(height: r.h(8)),

                          // Tanggal
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: r.sp(13),
                                color: AppColors.textMuted,
                              ),
                              SizedBox(width: r.w(6)),
                              Text(
                                artikel.tanggalFormatted,
                                style: GoogleFonts.inter(
                                  fontSize: r.sp(12),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: r.h(16)),
                          Divider(color: AppColors.border, height: 1),
                          SizedBox(height: r.h(16)),

                          // Paragraf intro
                          Text(
                            artikel.intro,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              fontSize: r.sp(13),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textDark,
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: r.h(16)),

                          // Poin-poin bernomor
                          ...List.generate(artikel.poinPoin.length, (i) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: r.h(12)),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // Nomor bulat oranye
                                  Container(
                                    width: r.r(28),
                                    height: r.r(28),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF28B6E),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${i + 1}',
                                      style: GoogleFonts.inter(
                                        fontSize: r.sp(12),
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: r.w(12)),
                                  // Teks poin
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: r.h(4)),
                                      child: Text(
                                        artikel.poinPoin[i],
                                        style: GoogleFonts.inter(
                                          fontSize: r.sp(13),
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textDark,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          SizedBox(height: r.h(4)),
                        ],
                      ),
                    ),

                    SizedBox(height: r.h(24)),
                  ],
                ),
              ),
            ),

            // ── Tombol Selengkapnya (sticky bawah) ─────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  r.w(20), r.h(8), r.w(20), r.h(20)),
              child: SizedBox(
                width: double.infinity,
                height: r.h(52),
                child: ElevatedButton(
                  onPressed: () {
                    _showFullArtikel(context, r);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28B6E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.r(32)),
                    ),
                  ),
                  child: Text(
                    'Selengkapnya',
                    style: GoogleFonts.inter(
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Modal / sheet isi lengkap ─────────────────────────────────────
  void _showFullArtikel(BuildContext context, Responsive r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(r.r(24))),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: EdgeInsets.only(top: r.h(12), bottom: r.h(8)),
                child: Container(
                  width: r.w(40),
                  height: r.h(4),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: EdgeInsets.symmetric(
                      horizontal: r.w(20), vertical: r.h(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artikel.judul,
                        style: GoogleFonts.inter(
                          fontSize: r.sp(18),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: r.h(16)),
                      Text(
                        artikel.isi,
                        style: GoogleFonts.inter(
                          fontSize: r.sp(14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textDark,
                          height: 1.8,
                        ),
                      ),
                      SizedBox(height: r.h(40)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
