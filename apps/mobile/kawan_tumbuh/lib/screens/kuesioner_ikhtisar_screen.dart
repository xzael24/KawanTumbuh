import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/responsive.dart';

class KuesionerIkhtisarScreen extends StatefulWidget {
  const KuesionerIkhtisarScreen({super.key});

  @override
  State<KuesionerIkhtisarScreen> createState() =>
      _KuesionerIkhtisarScreenState();
}

class _KuesionerIkhtisarScreenState
    extends State<KuesionerIkhtisarScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            // ── Konten scrollable ────────────────────────────────
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
                        Icons.assignment_rounded,
                        size: r.sp(100),
                        color: AppColors.teal,
                      ),
                    ),

                    SizedBox(height: r.h(24)),

                    // Judul
                    Text(
                      'Ikhtisar Kuisoner',
                      style: GoogleFonts.quicksand(
                        fontSize: r.sp(22),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),

                    SizedBox(height: r.h(10)),

                    // Deskripsi
                    Text(
                      'Sesi asesmen interaktif anak sudah selesai. Kini giliran anda mengisi kuisoner observasi untuk melengkapi datanya',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: r.sp(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: r.h(24)),

                    // Card info
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(r.w(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.r(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.edit_note_rounded,
                            title: 'Jumlah Pertanyaan',
                            subtitle: 'Terdiri dari 26 pertanyaan singkat',
                            showDivider: true,
                            r: r,
                          ),
                          _InfoRow(
                            icon: Icons.edit_note_rounded,
                            title: 'Fokus Pengamatan',
                            subtitle: 'Kebiasaan dan perilaku anak sehari-hari',
                            showDivider: false,
                            r: r,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: r.h(24)),

                    // Persetujuan
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Persetujuan Orang Tua',
                        style: GoogleFonts.quicksand(
                          fontSize: r.sp(14),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),

                    SizedBox(height: r.h(12)),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              setState(() => _agreed = !_agreed),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: r.r(20),
                            height: r.r(20),
                            margin: EdgeInsets.only(top: r.h(2)),
                            decoration: BoxDecoration(
                              color: _agreed
                                  ? AppColors.teal
                                  : Colors.white,
                              border: Border.all(
                                color: _agreed
                                    ? AppColors.teal
                                    : AppColors.border,
                                width: 1.5,
                              ),
                              borderRadius:
                                  BorderRadius.circular(r.r(4)),
                            ),
                            child: _agreed
                                ? Icon(Icons.check,
                                    color: Colors.white,
                                    size: r.sp(13))
                                : null,
                          ),
                        ),
                        SizedBox(width: r.w(10)),
                        Expanded(
                          child: Text(
                            'Saya menjawab pertanyaan ini berdasarkan pengamatan jujur terhadap kondisi anak',
                            style: GoogleFonts.quicksand(
                              fontSize: r.sp(13),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: r.h(32)),
                  ],
                ),
              ),
            ),

            // ── Tombol Mulai sticky bawah ────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  r.w(24), r.h(8), r.w(24), r.h(24)),
              child: SizedBox(
                width: double.infinity,
                height: r.h(52),
                child: ElevatedButton(
                  onPressed: _agreed
                      ? () => Navigator.pushNamed(
                          context, AppConstants.routeKuesioner)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    disabledBackgroundColor:
                        AppColors.teal.withValues(alpha: 0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.r(12)),
                    ),
                  ),
                  child: Text(
                    'Mulai',
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.showDivider,
    required this.r,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showDivider;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: r.h(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: r.r(36),
                height: r.r(36),
                decoration: BoxDecoration(
                  color: AppColors.tealLight,
                  borderRadius: BorderRadius.circular(r.r(8)),
                ),
                child: Icon(icon,
                    color: AppColors.teal, size: r.sp(20)),
              ),
              SizedBox(width: r.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontSize: r.sp(13),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.h(2)),
                    Text(
                      subtitle,
                      style: GoogleFonts.quicksand(
                        fontSize: r.sp(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border),
      ],
    );
  }
}
