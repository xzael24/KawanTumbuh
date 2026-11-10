import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/responsive.dart';
import '../models/artikel_model.dart';
import '../helpers/artikel_data.dart';
import 'artikel_detail_screen.dart';

class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  ArtikelKategori _selectedKategori = ArtikelKategori.semua;

  List<ArtikelModel> get _filteredArtikel {
    if (_selectedKategori == ArtikelKategori.semua) return dummyArtikel;
    return dummyArtikel
        .where((a) => a.kategori == _selectedKategori)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — Header area —
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.w(20),
                vertical: r.h(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol kembali
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: r.sp(20),
                          color: AppColors.textDark,
                        ),
                        SizedBox(width: r.w(6)),
                        Text(
                          'Kembali',
                          style: AppTextStyles.inter(
                            r.sp(14),
                            FontWeight.w500,
                            AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: r.h(12)),
                  // Judul halaman
                  Text(
                    'Artikel',
                    style: AppTextStyles.sora(
                      r.sp(28),
                      FontWeight.w700,
                      AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: r.h(16)),
                  // Banner
                  _ArtikelBanner(r: r),
                  SizedBox(height: r.h(20)),
                  // Filter kategori
                  _KategoriFilter(
                    selected: _selectedKategori,
                    onChanged: (k) => setState(() => _selectedKategori = k),
                    r: r,
                  ),
                ],
              ),
            ),

            // — Daftar artikel —
            Expanded(
              child: _filteredArtikel.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada artikel\ndi kategori ini.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.inter(
                          r.sp(14),
                          FontWeight.w400,
                          AppColors.textMuted,
                          height: 1.6,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.w(20),
                        vertical: r.h(8),
                      ),
                      itemCount: _filteredArtikel.length,
                      separatorBuilder: (context, index) => SizedBox(height: r.h(12)),
                      itemBuilder: (context, index) {
                        final artikel = _filteredArtikel[index];
                        return _ArtikelCard(
                          artikel: artikel,
                          r: r,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ArtikelDetailScreen(artikel: artikel),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // — Bottom navigation bar —
      bottomNavigationBar: _BottomNavBar(r: r, currentIndex: 2),
    );
  }
}

// ─────────────────────────────────────────────
// Banner hero
// ─────────────────────────────────────────────
class _ArtikelBanner extends StatelessWidget {
  const _ArtikelBanner({required this.r});
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r.r(16)),
      child: Container(
        height: r.h(130),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFD6D6F5),
        ),
        child: Stack(
          children: [
            // Ilustrasi banner
            Positioned.fill(
              child: Image.asset(
                AppAssets.artikelBanner,
                fit: BoxFit.cover,
              ),
            ),
            // Overlay teks
            Positioned(
              left: r.w(16),
              top: 0,
              bottom: 0,
              child: Center(
                child: SizedBox(
                  width: r.w(160),
                  child: Text(
                    'Tips & Informasi\nUntuk Tumbuh\nBersama Anak',
                    style: AppTextStyles.sora(
                      r.sp(16),
                      FontWeight.w700,
                      AppColors.textDark,
                      height: 1.4,
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

// ─────────────────────────────────────────────
// Filter kategori chip
// ─────────────────────────────────────────────
class _KategoriFilter extends StatelessWidget {
  const _KategoriFilter({
    required this.selected,
    required this.onChanged,
    required this.r,
  });

  final ArtikelKategori selected;
  final ValueChanged<ArtikelKategori> onChanged;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    final kategoriList = ArtikelKategori.values;

    return SizedBox(
      height: r.h(36),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kategoriList.length,
        separatorBuilder: (context, index) => SizedBox(width: r.w(8)),
        itemBuilder: (context, index) {
          final k = kategoriList[index];
          final isSelected = k == selected;
          return GestureDetector(
            onTap: () => onChanged(k),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: r.w(16),
                vertical: r.h(8),
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.teal
                    : Colors.white,
                borderRadius: BorderRadius.circular(r.r(20)),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.border),
              ),
              child: Text(
                k.label,
                style: AppTextStyles.inter(
                  r.sp(13),
                  isSelected ? FontWeight.w600 : FontWeight.w400,
                  isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card artikel
// ─────────────────────────────────────────────
class _ArtikelCard extends StatelessWidget {
  const _ArtikelCard({
    required this.artikel,
    required this.r,
    required this.onTap,
  });

  final ArtikelModel artikel;
  final Responsive r;
  final VoidCallback onTap;

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.r(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // — Thumbnail —
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(r.r(16)),
                bottomLeft: Radius.circular(r.r(16)),
              ),
              child: Image.asset(
                artikel.imagePath,
                width: r.w(90),
                height: r.h(100),
                fit: BoxFit.cover,
              ),
            ),
            // — Konten —
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.w(12),
                  vertical: r.h(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge kategori
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.w(10),
                        vertical: r.h(3),
                      ),
                      decoration: BoxDecoration(
                        color: _kategoriColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(r.r(20)),
                      ),
                      child: Text(
                        artikel.kategori.label,
                        style: AppTextStyles.inter(
                          r.sp(11),
                          FontWeight.w600,
                          _kategoriColor,
                        ),
                      ),
                    ),
                    SizedBox(height: r.h(6)),
                    // Judul
                    Text(
                      artikel.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.inter(
                        r.sp(13),
                        FontWeight.w600,
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
                          size: r.sp(12),
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: r.w(4)),
                        Text(
                          DateFormat('d MMMM yyyy', 'id').format(artikel.tanggal),
                          style: AppTextStyles.inter(
                            r.sp(11),
                            FontWeight.w400,
                            AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // — Arrow icon —
            Padding(
              padding: EdgeInsets.only(right: r.w(12)),
              child: Icon(
                Icons.chevron_right,
                size: r.sp(22),
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom navigation bar
// ─────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.r, required this.currentIndex});
  final Responsive r;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
      _NavItem(icon: Icons.medical_services_outlined, activeIcon: Icons.medical_services, label: 'Treatment'),
      _NavItem(icon: Icons.article_outlined, activeIcon: Icons.article, label: 'Artikel'),
      _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(r.r(24)),
          topRight: Radius.circular(r.r(24)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: r.w(16),
            vertical: r.h(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;
              return GestureDetector(
                onTap: () {
                  // navigasi tab — sambungkan nanti
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      size: r.sp(24),
                      color: isActive ? AppColors.pink : AppColors.textMuted,
                    ),
                    SizedBox(height: r.h(4)),
                    Text(
                      item.label,
                      style: AppTextStyles.inter(
                        r.sp(11),
                        isActive ? FontWeight.w600 : FontWeight.w400,
                        isActive ? AppColors.textDark : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
