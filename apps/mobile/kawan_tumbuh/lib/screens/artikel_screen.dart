import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  SizedBox(height: r.h(16)),
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
                      padding: EdgeInsets.fromLTRB(
                        r.w(20),
                        r.h(8),
                        r.w(20),
                        r.h(16),
                      ),
                      itemCount: _filteredArtikel.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: r.h(12)),
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
      bottomNavigationBar: _BottomNavBar(currentIndex: 2),
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
      child: SizedBox(
        height: r.h(130),
        width: double.infinity,
        child: Stack(
          children: [
            // Background + gambar anak di kanan
            Positioned.fill(
              child: Image.asset(
                AppAssets.artikelBanner,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
            // Overlay gradient agar teks terbaca
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFFCFCFF5).withValues(alpha: 0.95),
                      const Color(0xFFCFCFF5).withValues(alpha: 0.0),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
            ),
            // Teks di kiri
            Positioned(
              left: r.w(16),
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tips & Informasi\nUntuk Tumbuh\nBersama Anak',
                  style: AppTextStyles.sora(
                    r.sp(15),
                    FontWeight.w700,
                    AppColors.textDark,
                    height: 1.4,
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
                    ? const Color(0xFF657ADF)
                    : const Color(0xFFD2D4FB),
                borderRadius: BorderRadius.circular(r.r(20)),
              ),
              child: Text(
                k.label,
                style: AppTextStyles.inter(
                  r.sp(13),
                  isSelected ? FontWeight.w600 : FontWeight.w500,
                  isSelected
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF1D238A),
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

  // Warna badge — teal solid semua kategori, teks putih (sesuai screenshot)
  Color get _badgeBg {
    switch (artikel.kategori) {
      case ArtikelKategori.disleksia:
        return const Color(0xFF5F8F8A); // teal
      case ArtikelKategori.disgrafia:
        return const Color(0xFFE8A838); // kuning
      case ArtikelKategori.diskalkulia:
        return const Color(0xFFF57568); // merah-oranye
      case ArtikelKategori.polaAsuh:
        return const Color(0xFFF88D96); // pink
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // — Thumbnail — rounded semua sisi + margin
            Padding(
              padding: EdgeInsets.all(r.w(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(r.r(12)),
                child: Image.asset(
                  artikel.imagePath,
                  width: r.w(80),
                  height: r.h(80),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // — Konten —
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: r.w(4),
                  top: r.h(12),
                  bottom: r.h(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge kategori — solid color + teks putih
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.w(10),
                        vertical: r.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: _badgeBg,
                        borderRadius: BorderRadius.circular(r.r(20)),
                      ),
                      child: Text(
                        artikel.kategori.label,
                        style: AppTextStyles.inter(
                          r.sp(11),
                          FontWeight.w600,
                          Colors.white,
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
                        r.sp(14),
                        FontWeight.w700,
                        AppColors.textDark,
                        height: 1.35,
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
                          artikel.tanggalFormatted,
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
// Bottom navigation bar — konsisten dgn home_screen
// ─────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex});
  final int currentIndex;

  static const _activeColor = Color(0xFFF88D95);
  static const _inactiveColor = Color(0xFFAAAAAA);

  static const _items = [
    _NavItem(icon: 'assets/images/ic_home.png', label: 'Home'),
    _NavItem(icon: 'assets/images/ic_treatment.png', label: 'Treatment'),
    _NavItem(icon: 'assets/images/ic_artikel.png', label: 'Artikel'),
    _NavItem(icon: 'assets/images/ic_profile.png', label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final isActive = index == currentIndex;
              final item = _items[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        item.icon,
                        width: 24,
                        height: 24,
                        color: isActive ? _activeColor : _inactiveColor,
                        errorBuilder: (ctx, err, stack) => Icon(
                          _fallbackIcon(index),
                          size: 24,
                          color: isActive ? _activeColor : _inactiveColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isActive ? _activeColor : _inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _fallbackIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.medical_services_rounded;
      case 2:
        return Icons.article_rounded;
      case 3:
        return Icons.person_rounded;
      default:
        return Icons.circle;
    }
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final String icon;
  final String label;
}
