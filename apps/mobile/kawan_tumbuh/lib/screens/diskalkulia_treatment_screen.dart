import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';

// ─── Data model sesi terapi ───────────────────────────────────────────────────
class _SesiTerapi {
  const _SesiTerapi({
    required this.judul,
    required this.jumlahSoal,
    required this.bintang,
    required this.imagePath,
  });
  final String judul;
  final int jumlahSoal;
  final int bintang; // 0–3
  final String imagePath;
}

// ─── Data model gejala ───────────────────────────────────────────────────────
class _Gejala {
  const _Gejala({
    required this.label,
    required this.sublabel,
    required this.imagePath,
    required this.bgColor,
    required this.strokeColor,
    required this.textColor,
  });
  final String label;
  final String sublabel;
  final String imagePath;
  final Color bgColor;
  final Color strokeColor;
  final Color textColor;
}

class DiskalkuliaTreatmentScreen extends StatefulWidget {
  const DiskalkuliaTreatmentScreen({super.key});

  @override
  State<DiskalkuliaTreatmentScreen> createState() =>
      _DiskalkuliaTreatmentScreenState();
}

class _DiskalkuliaTreatmentScreenState extends State<DiskalkuliaTreatmentScreen> {
  int _selectedGejala = 0; // 0=Diskalkulia, 1=Disleksia, 2=Disgrafia

  static const _gejalaList = [
    _Gejala(
      label: 'Diskalkulia',
      sublabel: '',
      imagePath: AppAssets.therapyDyscalculia,
      bgColor: Color(0xFFF57568),
      strokeColor: Color(0xFFD83B2B),
      textColor: Colors.white,
    ),
    _Gejala(
      label: 'Disleksia',
      sublabel: '',
      imagePath: AppAssets.therapyDyslexia,
      bgColor: Color(0xFF678E8B),
      strokeColor: Colors.transparent,
      textColor: Colors.white,
    ),
    _Gejala(
      label: 'Disgrafia',
      sublabel: '',
      imagePath: AppAssets.therapyDysgraphia,
      bgColor: Color(0xFFFFECC1),
      strokeColor: Colors.transparent,
      textColor: Color(0xFF2B2F3C),
    ),
  ];

  static const _sesiList = [
    _SesiTerapi(
      judul: 'Sesi 1: Mengenal Angka dan Bilangan',
      jumlahSoal: 10,
      bintang: 3,
      imagePath: AppAssets.sesi1DiskalkuliaAngka,
    ),
    _SesiTerapi(
      judul: 'Sesi 2: Memahami Jumlah Benda',
      jumlahSoal: 10,
      bintang: 3,
      imagePath: AppAssets.sesi2DiskalkuliaJumlah,
    ),
    _SesiTerapi(
      judul: 'Sesi 3: Mengenal Pola Bilangan',
      jumlahSoal: 10,
      bintang: 3,
      imagePath: AppAssets.sesi3DiskalkuliaPola,
    ),
    _SesiTerapi(
      judul: 'Sesi 4: Belajar Penjumlahan Dasar',
      jumlahSoal: 10,
      bintang: 3,
      imagePath: AppAssets.sesi4DiskalkuliaJumlah,
    ),
    _SesiTerapi(
      judul: 'Sesi 5: Mengenal Bentuk dan Ukuran',
      jumlahSoal: 10,
      bintang: 3,
      imagePath: AppAssets.sesi5DiskalkuliaBentuk,
    ),
    _SesiTerapi(
      judul: 'Sesi 6: Mengurutkan dan Membandingkan',
      jumlahSoal: 10,
      bintang: 3,
      imagePath: AppAssets.sesi6DiskalkuliaUrut,
    ),
    _SesiTerapi(
      judul: 'Sesi 7: Tantangan Berhitung',
      jumlahSoal: 10,
      bintang: 3,
      imagePath: AppAssets.sesi7DiskalkuliaTantang,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: r.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.h(16)),

                    // ── Tombol kembali ──────────────────────────────
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

                    SizedBox(height: r.h(12)),

                    // ── Judul + Tombol Laporan ──────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Terapi Aca',
                          style: GoogleFonts.inter(
                            fontSize: r.sp(26),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        _OrangeButton(
                          label: 'Laporan',
                          r: r,
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: r.h(20)),

                    // ── Pilih Gejala ────────────────────────────────
                    Text(
                      'Pilih Gejala',
                      style: GoogleFonts.inter(
                        fontSize: r.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.h(12)),
                    _GejalaSelector(
                      gejalaList: _gejalaList,
                      selected: _selectedGejala,
                      onSelect: (i) => setState(() => _selectedGejala = i),
                      r: r,
                    ),

                    SizedBox(height: r.h(24)),

                    // ── Progres Terapi ──────────────────────────────
                    Text(
                      'Progres Terapi ${_gejalaList[_selectedGejala].label}',
                      style: GoogleFonts.inter(
                        fontSize: r.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.h(12)),

                    // Card progres pink
                    _ProgresCard(r: r),
                    SizedBox(height: r.h(12)),

                    // Card skrining evaluasi
                    _SkriningCard(r: r),

                    SizedBox(height: r.h(24)),

                    // ── Sesi Terapi ─────────────────────────────────
                    Text(
                      'Sesi Terapi',
                      style: GoogleFonts.inter(
                        fontSize: r.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.h(12)),

                    ..._sesiList.map(
                      (sesi) => Padding(
                        padding: EdgeInsets.only(bottom: r.h(10)),
                        child: _SesiCard(sesi: sesi, r: r),
                      ),
                    ),

                    SizedBox(height: r.h(16)),

                    // ── Tombol Unduh Laporan ────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: r.h(52),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF28B6E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(r.r(32)),
                          ),
                        ),
                        child: Text(
                          'Unduh Laporan',
                          style: GoogleFonts.inter(
                            fontSize: r.sp(15),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: r.h(24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom nav bar ────────────────────────────────────────────
      bottomNavigationBar: _BottomNavBar(currentIndex: 1),

      // ── FAB chatbot ───────────────────────────────────────────────
      floatingActionButton: _ChatbotFAB(r: r),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Tombol oranye kecil (Laporan)
class _OrangeButton extends StatelessWidget {
  const _OrangeButton({
    required this.label,
    required this.r,
    required this.onTap,
  });
  final String label;
  final Responsive r;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: r.w(20), vertical: r.h(10)),
        decoration: BoxDecoration(
          color: const Color(0xFFF28B6E),
          borderRadius: BorderRadius.circular(r.r(24)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: r.sp(13),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Selector gejala (3 card horizontal) — selected: lebih besar + shadow
class _GejalaSelector extends StatelessWidget {
  const _GejalaSelector({
    required this.gejalaList,
    required this.selected,
    required this.onSelect,
    required this.r,
  });
  final List<_Gejala> gejalaList;
  final int selected;
  final ValueChanged<int> onSelect;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(gejalaList.length, (i) {
        final g = gejalaList[i];
        final isSelected = i == selected;

        // Yang dipilih lebih tinggi, yang tidak dipilih lebih kecil
        final double cardHeight = isSelected ? r.h(115) : r.h(90);
        final double imgSize   = isSelected ? r.h(56)  : r.h(46);

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.only(
                right: i < gejalaList.length - 1 ? r.w(10) : 0,
              ),
              height: cardHeight,
              decoration: BoxDecoration(
                color: g.bgColor,
                borderRadius: BorderRadius.circular(r.r(14)),
                border: g.strokeColor != Colors.transparent
                    ? Border.all(color: g.strokeColor, width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: g.bgColor.withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              // ClipRRect agar gambar tidak overflow keluar card
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: imgSize,
                      width: imgSize,
                      child: Image.asset(
                        g.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, e, s) => Icon(
                          Icons.image_outlined,
                          size: imgSize * 0.7,
                          color: isSelected ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                    SizedBox(height: r.h(6)),
                    Text(
                      g.label,
                      style: GoogleFonts.inter(
                        fontSize: r.sp(12),
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? g.textColor
                            : const Color(0xFF1A1A1A),
                      ),
                    ),
                    if (g.sublabel.isNotEmpty) ...[
                      SizedBox(height: r.h(2)),
                      Text(
                        g.sublabel,
                        style: GoogleFonts.inter(
                          fontSize: r.sp(9),
                          fontWeight: FontWeight.w400,
                          color: isSelected
                              ? g.textColor.withValues(alpha: 0.85)
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
            ),
          ),
        );
      }),
    );
  }
}

// Card progres pink
class _ProgresCard extends StatelessWidget {
  const _ProgresCard({required this.r});
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(r.r(16)),
        border: Border.all(color: const Color(0xFFF5C0C0), width: 1),
      ),
      child: Row(
        children: [
          // Ilustrasi anak berhitung — placeholder, ganti gambar sesungguhnya
          Image.asset(
            AppAssets.progresDiskalkulia,
            height: r.h(80),
            width: r.w(80),
            fit: BoxFit.contain,
            errorBuilder: (ctx, e, s) => Container(
              height: r.h(80),
              width: r.w(80),
              decoration: BoxDecoration(
                color: const Color(0xFFF5C0C0),
                borderRadius: BorderRadius.circular(r.r(12)),
              ),
              child: Icon(Icons.calculate_rounded,
                  size: r.sp(40), color: const Color(0xFFE87070)),
            ),
          ),
          SizedBox(width: r.w(16)),
          // Teks progres
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: r.w(14), vertical: r.h(12)),
              decoration: BoxDecoration(
                color: const Color(0xFFF88D96),
                borderRadius: BorderRadius.circular(r.r(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hebat!',
                    style: GoogleFonts.inter(
                      fontSize: r.sp(14),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: r.h(4)),
                  Text(
                    'Aca Berhasil Menyelesaikan\n7 Dari 7 Sesi Minggu Ini',
                    style: GoogleFonts.inter(
                      fontSize: r.sp(12),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Card skrining evaluasi akhir
class _SkriningCard extends StatelessWidget {
  const _SkriningCard({required this.r});
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(r.r(16)),
        border: Border.all(color: const Color(0xFFF5C0C0), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Konten kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skrining Evaluasi Akhir',
                  style: GoogleFonts.inter(
                    fontSize: r.sp(14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: r.h(4)),
                Text(
                  'Hebat! Semua Sesi Telah Selesai\nYuk, Mulai Treatment Yang Lain',
                  style: GoogleFonts.inter(
                    fontSize: r.sp(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: r.h(12)),
                // Tombol mulai treatment — hijau dengan shadow
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.w(16), vertical: r.h(8)),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5CB85C),
                      borderRadius: BorderRadius.circular(r.r(20)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5CB85C).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white, size: 16),
                        SizedBox(width: r.w(6)),
                        Text(
                          'Mulai Treatment',
                          style: GoogleFonts.inter(
                            fontSize: r.sp(12),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: r.w(12)),
          // Ilustrasi evaluasi — placeholder, ganti gambar sesungguhnya
          Image.asset(
            AppAssets.evaluasiDiskalkulia,
            height: r.h(90),
            width: r.w(80),
            fit: BoxFit.contain,
            errorBuilder: (ctx, e, s) => Container(
              height: r.h(90),
              width: r.w(80),
              decoration: BoxDecoration(
                color: const Color(0xFFF5C0C0),
                borderRadius: BorderRadius.circular(r.r(12)),
              ),
              child: Icon(Icons.assignment_rounded,
                  size: r.sp(40), color: const Color(0xFFE87070)),
            ),
          ),
        ],
      ),
    );
  }
}

// Card sesi terapi
class _SesiCard extends StatelessWidget {
  const _SesiCard({required this.sesi, required this.r});
  final _SesiTerapi sesi;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r.r(14)),
      shadowColor: Colors.black.withValues(alpha: 0.08),
      elevation: 3,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(r.r(14)),
        splashColor: const Color(0xFFFFF3DC),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.w(12), vertical: r.h(12)),
          child: Row(
            children: [
              Container(
                width: r.r(52),
                height: r.r(52),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3DC),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(r.w(10)),
                  child: Image.asset(
                    sesi.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, e, s) => Icon(
                      Icons.calculate_rounded,
                      size: r.sp(24),
                      color: const Color(0xFFE8A838),
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sesi.judul,
                      style: GoogleFonts.inter(
                        fontSize: r.sp(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: r.h(3)),
                    Text(
                      '${sesi.jumlahSoal} Soal',
                      style: GoogleFonts.inter(
                        fontSize: r.sp(11),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return Icon(
                    i < sesi.bintang ? Icons.star : Icons.star_border,
                    color: i < sesi.bintang
                        ? const Color(0xFFFFB800)
                        : AppColors.border,
                    size: r.sp(18),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatbotFAB extends StatelessWidget {
  const _ChatbotFAB({required this.r});
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Chatbot segera hadir!',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFF5F8F8A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: r.r(52),
        height: r.r(52),
        decoration: BoxDecoration(
          color: const Color(0xFFF28B6E),
          borderRadius: BorderRadius.circular(r.r(14)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF28B6E).withValues(alpha: 0.45),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(Icons.chat_rounded, color: Colors.white, size: r.sp(26)),
      ),
    );
  }
}

// Bottom navigation bar
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex});
  final int currentIndex;

  static const _activeColor   = Color(0xFFF88D95);
  static const _inactiveColor = Color(0xFFAAAAAA);

  static const _items = [
    _NavItem(icon: 'assets/images/ic_home.png',      label: 'Home'),
    _NavItem(icon: 'assets/images/ic_treatment.png', label: 'Treatment'),
    _NavItem(icon: 'assets/images/ic_artikel.png',   label: 'Artikel'),
    _NavItem(icon: 'assets/images/ic_profile.png',   label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
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
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final isActive = index == currentIndex;
              final item = _items[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (index == 2) {
                    Navigator.pushReplacementNamed(context, '/artikel');
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
                          color:
                              isActive ? _activeColor : _inactiveColor,
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
                          color:
                              isActive ? _activeColor : _inactiveColor,
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
      case 0:  return Icons.home_rounded;
      case 1:  return Icons.medical_services_rounded;
      case 2:  return Icons.article_rounded;
      case 3:  return Icons.person_rounded;
      default: return Icons.circle;
    }
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final String icon;
  final String label;
}
