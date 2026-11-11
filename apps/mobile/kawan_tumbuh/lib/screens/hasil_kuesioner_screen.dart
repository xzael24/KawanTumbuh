import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';

class HasilKuesionerScreen extends StatelessWidget {
  const HasilKuesionerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final int jumlahYa =
        (ModalRoute.of(context)?.settings.arguments as int?) ?? 0;

    // Hitung tingkat risiko dari jumlah jawaban Ya (dari 26)
    final String tingkat;
    final String deskripsi;
    final Color warnaTingkat;

    if (jumlahYa >= 18) {
      tingkat = 'Risiko Tinggi';
      deskripsi =
          'Hasil kuesioner menunjukkan indikasi kuat adanya kesulitan belajar. Sebaiknya segera konsultasikan dengan profesional untuk evaluasi lebih lanjut.';
      warnaTingkat = const Color(0xFFF57568);
    } else if (jumlahYa >= 10) {
      tingkat = 'Risiko Sedang';
      deskripsi =
          'Hasil kuesioner menunjukkan beberapa indikasi kesulitan belajar. Disarankan untuk melakukan observasi lebih lanjut dan konsultasi dengan guru atau spesialis.';
      warnaTingkat = const Color(0xFFF28B6E);
    } else {
      tingkat = 'Risiko Rendah';
      deskripsi =
          'Hasil kuesioner tidak menunjukkan indikasi signifikan. Tetap pantau perkembangan anak secara berkala.';
      warnaTingkat = const Color(0xFF769995);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: r.w(24), vertical: r.h(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.logo,
                          height: r.h(32),
                          errorBuilder: (ctx, e, s) => Icon(
                            Icons.eco,
                            color: AppColors.teal,
                            size: r.sp(32),
                          ),
                        ),
                        SizedBox(width: r.w(8)),
                        Text(
                          'KawanTumbuh',
                          style: GoogleFonts.quicksand(
                            fontSize: r.sp(16),
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: r.h(28)),

                    // Ilustrasi
                    Image.asset(
                      AppAssets.assessmentIllustration,
                      height: r.h(160),
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, e, s) => Icon(
                        Icons.assignment_turned_in_rounded,
                        size: r.sp(100),
                        color: AppColors.teal,
                      ),
                    ),

                    SizedBox(height: r.h(24)),

                    // Judul
                    Text(
                      'Hasil Kuesioner',
                      style: GoogleFonts.quicksand(
                        fontSize: r.sp(22),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),

                    SizedBox(height: r.h(20)),

                    // Card hasil
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(r.w(20)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.r(16)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Skor
                          Text(
                            '$jumlahYa / 26',
                            style: GoogleFonts.quicksand(
                              fontSize: r.sp(40),
                              fontWeight: FontWeight.w700,
                              color: warnaTingkat,
                            ),
                          ),
                          Text(
                            'Jawaban Ya',
                            style: GoogleFonts.quicksand(
                              fontSize: r.sp(13),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                            ),
                          ),

                          SizedBox(height: r.h(16)),
                          Divider(color: AppColors.border, height: 1),
                          SizedBox(height: r.h(16)),

                          // Badge tingkat
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: r.w(20),
                                vertical: r.h(8)),
                            decoration: BoxDecoration(
                              color: warnaTingkat
                                  .withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(r.r(20)),
                            ),
                            child: Text(
                              tingkat,
                              style: GoogleFonts.quicksand(
                                fontSize: r.sp(14),
                                fontWeight: FontWeight.w700,
                                color: warnaTingkat,
                              ),
                            ),
                          ),

                          SizedBox(height: r.h(16)),

                          // Deskripsi
                          Text(
                            deskripsi,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: r.sp(13),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: r.h(32)),
                  ],
                ),
              ),
            ),

            // ── Tombol kembali ke home ───────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  r.w(24), r.h(8), r.w(24), r.h(24)),
              child: SizedBox(
                width: double.infinity,
                height: r.h(52),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.r(12)),
                    ),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.quicksand(
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w700,
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
}
