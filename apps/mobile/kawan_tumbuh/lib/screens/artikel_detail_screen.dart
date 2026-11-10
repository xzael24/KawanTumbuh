import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/responsive.dart';
import '../models/artikel_model.dart';

class ArtikelDetailScreen extends StatelessWidget {
  const ArtikelDetailScreen({super.key, required this.artikel});

  final ArtikelModel artikel;

  Color get _kategoriColor {
    switch (artikel.kategori) {
      case ArtikelKategori.disleksia:
        return const Color(0xFF4A90D9);
      case ArtikelKategori.disgrafia:
        return const Color(0xFFE8A838);
      case ArtikelKategori.diskalkulia:
        return const Color(0xFF7BC47F);
      case ArtikelKategori.polaAsuh:
        return const Color(0xFFE87070);
      case ArtikelKategori.semua:
        return AppColors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: CustomScrollView(
        slivers: [
          // — App bar dengan gambar —
          SliverAppBar(
            expandedHeight: r.h(240),
            pinned: true,
            backgroundColor: const Color(0xFFF5F0E8),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(r.w(8)),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textDark,
                  size: r.sp(20),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(r.r(24)),
                  bottomRight: Radius.circular(r.r(24)),
                ),
                child: Image.asset(
                  artikel.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // — Konten artikel —
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(r.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.h(8)),
                  // Badge kategori
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.w(12),
                      vertical: r.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: _kategoriColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(r.r(20)),
                    ),
                    child: Text(
                      artikel.kategori.label,
                      style: AppTextStyles.inter(
                        r.sp(12),
                        FontWeight.w600,
                        _kategoriColor,
                      ),
                    ),
                  ),
                  SizedBox(height: r.h(12)),
                  // Judul
                  Text(
                    artikel.judul,
                    style: AppTextStyles.sora(
                      r.sp(20),
                      FontWeight.w700,
                      AppColors.textDark,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: r.h(8)),
                  // Tanggal
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: r.sp(14),
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: r.w(6)),
                      Text(
                        DateFormat('d MMMM yyyy', 'id').format(artikel.tanggal),
                        style: AppTextStyles.inter(
                          r.sp(13),
                          FontWeight.w400,
                          AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.h(20)),
                  // Divider
                  Divider(color: AppColors.border, height: 1),
                  SizedBox(height: r.h(20)),
                  // Isi artikel
                  Text(
                    artikel.isi,
                    style: AppTextStyles.inter(
                      r.sp(14),
                      FontWeight.w400,
                      AppColors.textDark,
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
    );
  }
}
