// Halaman Terapi Disleksia — menggunakan data & komponen yang sama
// dengan diskalkulia_treatment_screen.dart, hanya default gejala berbeda.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';

// ─── Reuse semua kode dari diskalkulia — cukup buat alias screen ──────────────
// (Data model dan list didefinisikan ulang di sini agar file mandiri)

enum _SesiStatus { selesai, lanjut, terkunci }

class _SesiTerapi {
  const _SesiTerapi({
    required this.judul,
    required this.jumlahSoal,
    required this.bintang,
    required this.imagePath,
    required this.status,
  });
  final String judul;
  final int jumlahSoal;
  final int bintang;
  final String imagePath;
  final _SesiStatus status;
}

class _ProgresData {
  const _ProgresData({
    required this.selesai,
    required this.total,
    required this.imagePath,
  });
  final int selesai;
  final int total;
  final String imagePath;
}

class _Gejala {
  const _Gejala({
    required this.label,
    required this.sublabel,
    required this.imagePath,
    required this.bgColor,
    required this.strokeColor,
    required this.textColor,
    required this.sesiList,
    required this.progres,
    required this.evaluasiImagePath,
    required this.skriningTombolLabel,
    required this.skriningSubtitle,
  });
  final String label;
  final String sublabel;
  final String imagePath;
  final Color bgColor;
  final Color strokeColor;
  final Color textColor;
  final List<_SesiTerapi> sesiList;
  final _ProgresData progres;
  final String evaluasiImagePath;
  final String skriningTombolLabel;
  final String skriningSubtitle;
}

// ─── Data sesi ────────────────────────────────────────────────────────────────
const _sesiDiskalkulia = [
  _SesiTerapi(
    judul: 'Sesi 1: Mengenal Angka',
    jumlahSoal: 5,
    bintang: 2,
    imagePath: AppAssets.sesi1DiskalkuliaAngka,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 2: Memahami Jumlah',
    jumlahSoal: 5,
    bintang: 0,
    imagePath: AppAssets.sesi2DiskalkuliaJumlah,
    status: _SesiStatus.lanjut,
  ),
  _SesiTerapi(
    judul: 'Sesi 3: Mengenal Pola Bilangan',
    jumlahSoal: 5,
    bintang: 0,
    imagePath: AppAssets.sesi3DiskalkuliaPola,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 4: Belajar Penjumlahan',
    jumlahSoal: 5,
    bintang: 0,
    imagePath: AppAssets.sesi4DiskalkuliaJumlah,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 5: Mengenal Bentuk dan Ukuran',
    jumlahSoal: 5,
    bintang: 0,
    imagePath: AppAssets.sesi5DiskalkuliaBentuk,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 6: Mengurutkan dan Membandingkan',
    jumlahSoal: 5,
    bintang: 0,
    imagePath: AppAssets.sesi6DiskalkuliaUrut,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 7: Tantangan Berhitung',
    jumlahSoal: 5,
    bintang: 0,
    imagePath: AppAssets.sesi7DiskalkuliaTantang,
    status: _SesiStatus.terkunci,
  ),
];

const _sesiDisleksia = [
  _SesiTerapi(
    judul: 'Sesi 1: Mengenal Huruf dan Bunyi',
    jumlahSoal: 5,
    bintang: 3,
    imagePath: AppAssets.sesi2BedakanHuruf,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 2: Membedakan Huruf',
    jumlahSoal: 5,
    bintang: 3,
    imagePath: AppAssets.sesi3SukuKata,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 3: Mengenal Suku Kata',
    jumlahSoal: 5,
    bintang: 3,
    imagePath: AppAssets.sesi4MembacaKata,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 4: Membaca Kata',
    jumlahSoal: 5,
    bintang: 3,
    imagePath: AppAssets.sesi5Mendengar,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 5: Mendengar & Menirukan',
    jumlahSoal: 5,
    bintang: 3,
    imagePath: AppAssets.sesi6KalimatPendek,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 6: Membaca Kalimat Pendek',
    jumlahSoal: 5,
    bintang: 3,
    imagePath: AppAssets.sesi7MembacaMemahami,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 7: Membaca dan Memahami',
    jumlahSoal: 5,
    bintang: 3,
    imagePath: AppAssets.treatmentBoyMagnifier,
    status: _SesiStatus.selesai,
  ),
];

const _sesiDisgrafia = [
  _SesiTerapi(
    judul: 'Sesi 1: Melatih Gerakan Tangan',
    jumlahSoal: 10,
    bintang: 3,
    imagePath: AppAssets.sesi1Disgrafia,
    status: _SesiStatus.selesai,
  ),
  _SesiTerapi(
    judul: 'Sesi 2: Menghubungkan Titik',
    jumlahSoal: 10,
    bintang: 0,
    imagePath: AppAssets.sesi2Disgrafia,
    status: _SesiStatus.lanjut,
  ),
  _SesiTerapi(
    judul: 'Sesi 3: Membentuk Pola & Bentuk',
    jumlahSoal: 10,
    bintang: 0,
    imagePath: AppAssets.sesi3SukuKata,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 4: Mengenal Bentuk Huruf',
    jumlahSoal: 10,
    bintang: 0,
    imagePath: AppAssets.sesi4MembacaKata,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 5: Menulis Huruf',
    jumlahSoal: 10,
    bintang: 0,
    imagePath: AppAssets.sesi5Mendengar,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 6: Menulis Kata Sederhana',
    jumlahSoal: 10,
    bintang: 0,
    imagePath: AppAssets.sesi6KalimatPendek,
    status: _SesiStatus.terkunci,
  ),
  _SesiTerapi(
    judul: 'Sesi 7: Tantangan Menulis',
    jumlahSoal: 10,
    bintang: 0,
    imagePath: AppAssets.sesi7MembacaMemahami,
    status: _SesiStatus.terkunci,
  ),
];

const _gejalaList = [
  _Gejala(
    label: 'Diskalkulia',
    sublabel: 'Resiko Tinggi',
    imagePath: AppAssets.therapyDyscalculia,
    bgColor: Color(0xFFF57568),
    strokeColor: Color(0xFFD83B2B),
    textColor: Colors.white,
    sesiList: _sesiDiskalkulia,
    progres: _ProgresData(
      selesai: 2,
      total: 7,
      imagePath: AppAssets.progresDiskalkulia,
    ),
    evaluasiImagePath: AppAssets.evaluasiDiskalkulia,
    skriningTombolLabel: 'Selesaikan 7 Sesi',
    skriningSubtitle: 'Selesaikan Semua Sesi Untuk\nMembuka Skrining Evaluasi',
  ),
  _Gejala(
    label: 'Disleksia',
    sublabel: '',
    imagePath: AppAssets.therapyDyslexia,
    bgColor: Color(0xFF678E8B),
    strokeColor: Colors.transparent,
    textColor: Colors.white,
    sesiList: _sesiDisleksia,
    progres: _ProgresData(
      selesai: 7,
      total: 7,
      imagePath: AppAssets.treatmentGirlReading,
    ),
    evaluasiImagePath: AppAssets.treatmentBoyMagnifier2,
    skriningTombolLabel: 'Selesaikan Treatment',
    skriningSubtitle: 'Hebat! Semua Sesi Telah Selesai\nYuk, Selesaikan Treatment Yang Lain',
  ),
  _Gejala(
    label: 'Disgrafia',
    sublabel: '',
    imagePath: AppAssets.therapyDysgraphia,
    bgColor: Color(0xFFFFECC1),
    strokeColor: Colors.transparent,
    textColor: Color(0xFF2B2F3C),
    sesiList: _sesiDisgrafia,
    progres: _ProgresData(
      selesai: 2,
      total: 7,
      imagePath: AppAssets.treatmentGirlReading,
    ),
    evaluasiImagePath: AppAssets.treatmentBoyMagnifier2,
    skriningTombolLabel: 'Selesaikan 7 Sesi',
    skriningSubtitle: 'Selesaikan Semua Sesi Untuk\nMembuka Skrining Evaluasi',
  ),
];

// ─── Screen Disleksia (default index = 1) ────────────────────────────────────
class DisleksiaTreatmentScreen extends StatefulWidget {
  const DisleksiaTreatmentScreen({super.key});

  @override
  State<DisleksiaTreatmentScreen> createState() =>
      _DisleksiaTreatmentScreenState();
}

class _DisleksiaTreatmentScreenState extends State<DisleksiaTreatmentScreen> {
  int _selectedGejala = 1; // default: Disleksia

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final gejala = _gejalaList[_selectedGejala];

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
                            label: 'Laporan', r: r, onTap: () {}),
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
                      'Progres Terapi ${gejala.label}',
                      style: GoogleFonts.inter(
                        fontSize: r.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: r.h(12)),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _ProgresCard(
                        key: ValueKey(_selectedGejala),
                        progres: gejala.progres,
                        r: r,
                      ),
                    ),
                    SizedBox(height: r.h(12)),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _SkriningCard(
                        key: ValueKey('skrining_$_selectedGejala'),
                        gejala: gejala,
                        r: r,
                      ),
                    ),

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

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey('sesi_$_selectedGejala'),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(r.r(16)),
                          border: Border.all(
                            color: const Color(0xFFFFB800),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: List.generate(
                              gejala.sesiList.length, (index) {
                            final sesi = gejala.sesiList[index];
                            final isLast =
                                index == gejala.sesiList.length - 1;
                            return Column(
                              children: [
                                _SesiCard(
                                  sesi: sesi,
                                  r: r,
                                  showSoal: _selectedGejala != 2,
                                ),
                                if (!isLast)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: const Color(0xFFF0F0F0),
                                    indent: r.w(16),
                                    endIndent: r.w(16),
                                  ),
                              ],
                            );
                          }),
                        ),
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

      bottomNavigationBar: _BottomNavBar(currentIndex: 1),
      floatingActionButton: _ChatbotFAB(r: r),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _OrangeButton extends StatelessWidget {
  const _OrangeButton(
      {required this.label, required this.r, required this.onTap});
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
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: r.sp(13),
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ),
    );
  }
}

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
        final double cardHeight = isSelected ? r.h(115) : r.h(90);
        final double imgSize = isSelected ? r.h(56) : r.h(46);

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.only(
                  right: i < gejalaList.length - 1 ? r.w(10) : 0),
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
                            offset: const Offset(0, 6))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: imgSize,
                    width: imgSize,
                    child: Image.asset(g.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, e, s) => Icon(
                            Icons.image_outlined,
                            size: imgSize * 0.7,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textMuted)),
                  ),
                  SizedBox(height: r.h(6)),
                  Text(g.label,
                      style: GoogleFonts.inter(
                          fontSize: r.sp(12),
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? g.textColor
                              : const Color(0xFF1A1A1A))),
                  if (g.sublabel.isNotEmpty) ...[
                    SizedBox(height: r.h(2)),
                    Text(g.sublabel,
                        style: GoogleFonts.inter(
                            fontSize: r.sp(9),
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? g.textColor.withValues(alpha: 0.85)
                                : AppColors.textMuted)),
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

class _ProgresCard extends StatelessWidget {
  const _ProgresCard(
      {super.key, required this.progres, required this.r});
  final _ProgresData progres;
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
          Image.asset(progres.imagePath,
              height: r.h(80),
              width: r.w(80),
              fit: BoxFit.contain,
              errorBuilder: (ctx, e, s) => Container(
                height: r.h(80),
                width: r.w(80),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5C0C0),
                    borderRadius: BorderRadius.circular(r.r(12))),
                child: Icon(Icons.child_care,
                    size: r.sp(40), color: const Color(0xFFE87070)),
              )),
          SizedBox(width: r.w(16)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: r.w(14), vertical: r.h(12)),
              decoration: BoxDecoration(
                  color: const Color(0xFFF88D96),
                  borderRadius: BorderRadius.circular(r.r(12))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hebat!',
                      style: GoogleFonts.inter(
                          fontSize: r.sp(14),
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(height: r.h(4)),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          fontSize: r.sp(12),
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.4),
                      children: [
                        const TextSpan(
                            text: 'Aca Berhasil Menyelesaikan\n'),
                        TextSpan(
                            text: '${progres.selesai} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                        const TextSpan(text: 'Dari '),
                        TextSpan(
                            text: '${progres.total} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                        const TextSpan(text: 'Sesi Minggu Ini'),
                      ],
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

class _SkriningCard extends StatelessWidget {
  const _SkriningCard(
      {super.key, required this.gejala, required this.r});
  final _Gejala gejala;
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Skrining Evaluasi Akhir',
                    style: GoogleFonts.inter(
                        fontSize: r.sp(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                SizedBox(height: r.h(4)),
                Text(gejala.skriningSubtitle,
                    style: GoogleFonts.inter(
                        fontSize: r.sp(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                        height: 1.4)),
                SizedBox(height: r.h(12)),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.w(16), vertical: r.h(8)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28B6E),
                      borderRadius: BorderRadius.circular(r.r(20)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFFF28B6E)
                                .withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock,
                            color: Colors.white, size: 14),
                        SizedBox(width: r.w(6)),
                        Text(gejala.skriningTombolLabel,
                            style: GoogleFonts.inter(
                                fontSize: r.sp(12),
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: r.w(12)),
          Image.asset(gejala.evaluasiImagePath,
              height: r.h(90),
              width: r.w(80),
              fit: BoxFit.contain,
              errorBuilder: (ctx, e, s) => Container(
                height: r.h(90),
                width: r.w(80),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5C0C0),
                    borderRadius: BorderRadius.circular(r.r(12))),
                child: Icon(Icons.assignment_rounded,
                    size: r.sp(40), color: const Color(0xFFE87070)),
              )),
        ],
      ),
    );
  }
}

class _SesiCard extends StatelessWidget {
  const _SesiCard({required this.sesi, required this.r, this.showSoal = true});
  final _SesiTerapi sesi;
  final Responsive r;
  final bool showSoal;

  @override
  Widget build(BuildContext context) {
    final isLocked = sesi.status == _SesiStatus.terkunci;
    final isLanjut = sesi.status == _SesiStatus.lanjut;
    final isSelesai = sesi.status == _SesiStatus.selesai;

    return InkWell(
      onTap: isLocked ? null : () {},
      borderRadius: BorderRadius.circular(r.r(14)),
      splashColor: const Color(0xFFFFF3DC),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: r.w(14), vertical: r.h(14)),
        child: Row(
          children: [
            Container(
              width: r.r(50),
              height: r.r(50),
              decoration: BoxDecoration(
                color: isLocked
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFFFFF3DC),
                shape: BoxShape.circle,
              ),
              child: isLocked
                  ? Icon(Icons.lock,
                      size: r.sp(22), color: const Color(0xFF9E9E9E))
                  : Padding(
                      padding: EdgeInsets.all(r.w(10)),
                      child: Image.asset(sesi.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, e, s) => Icon(
                              Icons.auto_stories_rounded,
                              size: r.sp(22),
                              color: const Color(0xFFE8A838)))),
            ),
            SizedBox(width: r.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sesi.judul,
                      style: GoogleFonts.inter(
                          fontSize: r.sp(13),
                          fontWeight: FontWeight.w600,
                          color: isLocked
                              ? AppColors.textMuted
                              : AppColors.textDark,
                          height: 1.3)),
                  if (showSoal) ...[
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
                ],
              ),
            ),
            SizedBox(width: r.w(8)),
            if (isSelesai)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) => Icon(
                  i < sesi.bintang ? Icons.star : Icons.star_border,
                  color: i < sesi.bintang
                      ? const Color(0xFFFFB800)
                      : AppColors.border,
                  size: r.sp(18),
                )),
              )
            else if (isLanjut)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: r.w(12), vertical: r.h(6)),
                decoration: BoxDecoration(
                    color: const Color(0xFFF28B6E),
                    borderRadius: BorderRadius.circular(r.r(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow,
                        color: Colors.white, size: r.sp(14)),
                    SizedBox(width: r.w(4)),
                    Text('Lanjut',
                        style: GoogleFonts.inter(
                            fontSize: r.sp(12),
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock,
                      size: r.sp(13), color: AppColors.textMuted),
                  SizedBox(width: r.w(4)),
                  Text('Terkunci',
                      style: GoogleFonts.inter(
                          fontSize: r.sp(11),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted)),
                ],
              ),
          ],
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Chatbot segera hadir!',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF5F8F8A),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ));
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
                offset: const Offset(0, 6))
          ],
        ),
        child:
            Icon(Icons.chat_rounded, color: Colors.white, size: r.sp(26)),
      ),
    );
  }
}

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
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -3))
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
                      Image.asset(item.icon,
                          width: 24,
                          height: 24,
                          color: isActive ? _activeColor : _inactiveColor,
                          errorBuilder: (ctx, err, stack) => Icon(
                              _fallbackIcon(index),
                              size: 24,
                              color: isActive
                                  ? _activeColor
                                  : _inactiveColor)),
                      const SizedBox(height: 4),
                      Text(item.label,
                          style: GoogleFonts.quicksand(
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isActive
                                  ? _activeColor
                                  : _inactiveColor)),
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
