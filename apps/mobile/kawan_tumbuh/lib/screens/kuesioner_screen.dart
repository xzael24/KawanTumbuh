import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';

// ─── Data pertanyaan (26 soal disgrafia) ─────────────────────────────────────
const List<String> _pertanyaan = [
  'Apakah anak tampak kesulitan memahami apa yang dibicarakan orang lain kepadanya?',
  'Apakah anak kesulitan menyusun kata-kata dengan teratur saat berbicara atau menulis?',
  'Apakah anak memiliki riwayat terlambat bicara (speech delay) dibandingkan teman sebayanya?',
  'Apakah anak sering salah mengucapkan kata atau membalik urutan suku kata?',
  'Apakah anak kesulitan mengingat nama benda sehari-hari meskipun sudah sering dilihat?',
  'Apakah anak kesulitan mengikuti instruksi yang terdiri dari lebih dari dua langkah?',
  'Apakah anak tampak lambat dalam belajar mengenal huruf dibandingkan teman sebayanya?',
  'Apakah anak sering membalik atau menukar huruf saat membaca atau menulis (misal b/d, p/q)?',
  'Apakah anak kesulitan membaca dengan lancar meskipun sudah berlatih?',
  'Apakah anak menghindari aktivitas membaca atau menulis?',
  'Apakah anak kesulitan menyalin tulisan dari papan tulis atau buku?',
  'Apakah tulisan tangan anak sulit dibaca atau tidak konsisten ukurannya?',
  'Apakah anak memegang pensil dengan cara yang tidak lazim atau tampak kaku?',
  'Apakah anak mengeluh tangan atau lengan cepat lelah saat menulis?',
  'Apakah anak kesulitan menulis dalam garis lurus meskipun ada panduan garis?',
  'Apakah anak sering melewatkan huruf atau kata saat menulis?',
  'Apakah anak kesulitan mengekspresikan pikiran secara tertulis meskipun bisa bicara lancar?',
  'Apakah anak tampak lambat dalam menyelesaikan tugas menulis dibanding teman sebayanya?',
  'Apakah anak memiliki koordinasi tangan yang kurang baik dalam aktivitas sehari-hari?',
  'Apakah anak kesulitan mengancingkan baju, mengikat tali sepatu, atau aktivitas motorik halus lainnya?',
  'Apakah anak sering mengalami kesulitan mengatur waktu dan merencanakan kegiatan?',
  'Apakah anak mudah frustrasi atau marah saat mengerjakan tugas sekolah?',
  'Apakah anak pernah didiagnosis atau dicurigai memiliki keterlambatan perkembangan?',
  'Apakah ada anggota keluarga lain yang memiliki kesulitan belajar serupa?',
  'Apakah anak mendapat nilai rendah secara konsisten di mata pelajaran Bahasa Indonesia?',
  'Apakah guru pernah menyampaikan kekhawatiran tentang kemampuan menulis atau membaca anak?',
];

const int _perHalaman = 5;

// ─────────────────────────────────────────────────────────────────────────────
class KuesionerScreen extends StatefulWidget {
  const KuesionerScreen({super.key});

  @override
  State<KuesionerScreen> createState() => _KuesionerScreenState();
}

class _KuesionerScreenState extends State<KuesionerScreen> {
  // null = belum dijawab, true = Ya, false = Tidak
  final List<bool?> _jawaban = List.filled(_pertanyaan.length, null);
  int _halaman = 0;

  int get _totalHalaman => (_pertanyaan.length / _perHalaman).ceil();
  bool get _isHalamanTerakhir => _halaman == _totalHalaman - 1;

  List<int> get _indeksHalamanIni {
    final start = _halaman * _perHalaman;
    final end = (start + _perHalaman).clamp(0, _pertanyaan.length);
    return List.generate(end - start, (i) => start + i);
  }

  bool get _halamanIniSelesai =>
      _indeksHalamanIni.every((i) => _jawaban[i] != null);

  double get _progress =>
      (_halaman * _perHalaman + _indeksHalamanIni.where((i) => _jawaban[i] != null).length) /
      _pertanyaan.length;

  void _lanjut() {
    if (_isHalamanTerakhir) {
      final jumlahYa = _jawaban.where((j) => j == true).length;
      Navigator.pushReplacementNamed(
        context,
        '/hasil-assessment',
        arguments: jumlahYa,
      );
    } else {
      setState(() => _halaman++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress bar ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  r.w(24), r.h(16), r.w(24), r.h(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(r.r(8)),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: r.h(8),
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF769995)),
                ),
              ),
            ),

            // ── Daftar pertanyaan ─────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: r.w(16), vertical: r.h(8)),
                itemCount: _indeksHalamanIni.length,
                itemBuilder: (context, pos) {
                  final idx = _indeksHalamanIni[pos];
                  return Padding(
                    padding: EdgeInsets.only(bottom: r.h(12)),
                    child: _PertanyaanCard(
                      pertanyaan: _pertanyaan[idx],
                      jawaban: _jawaban[idx],
                      r: r,
                      onYa: () => setState(() => _jawaban[idx] = true),
                      onTidak: () =>
                          setState(() => _jawaban[idx] = false),
                    ),
                  );
                },
              ),
            ),

            // ── Tombol Lanjut / Selesai ───────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  r.w(24), r.h(8), r.w(24), r.h(24)),
              child: SizedBox(
                width: double.infinity,
                height: r.h(52),
                child: ElevatedButton(
                  onPressed: _halamanIniSelesai ? _lanjut : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF769995),
                    disabledBackgroundColor:
                        const Color(0xFF769995).withValues(alpha: 0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.r(12)),
                    ),
                  ),
                  child: Text(
                    _isHalamanTerakhir ? 'Selesai' : 'Lanjut',
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

// ─────────────────────────────────────────────────────────────────────────────
// Card satu pertanyaan
// ─────────────────────────────────────────────────────────────────────────────
class _PertanyaanCard extends StatelessWidget {
  const _PertanyaanCard({
    required this.pertanyaan,
    required this.jawaban,
    required this.r,
    required this.onYa,
    required this.onTidak,
  });

  final String pertanyaan;
  final bool? jawaban;
  final Responsive r;
  final VoidCallback onYa;
  final VoidCallback onTidak;

  // Default abu-abu, Ya = teal, Tidak = pink
  Color get _colorYa {
    if (jawaban == null) return const Color(0xFFD1D1D1);
    return jawaban == true
        ? const Color(0xFF769995)
        : const Color(0xFFD1D1D1);
  }

  Color get _colorTidak {
    if (jawaban == null) return const Color(0xFFD1D1D1);
    return jawaban == false
        ? const Color(0xFFF3A3A1)
        : const Color(0xFFD1D1D1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.r(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(r.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks pertanyaan
          Text(
            pertanyaan,
            style: GoogleFonts.quicksand(
              fontSize: r.sp(13),
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
          SizedBox(height: r.h(14)),
          // Tombol Ya & Tidak
          Row(
            children: [
              Expanded(
                child: _PilihanButton(
                  label: 'Ya',
                  color: _colorYa,
                  onTap: onYa,
                  r: r,
                ),
              ),
              SizedBox(width: r.w(12)),
              Expanded(
                child: _PilihanButton(
                  label: 'Tidak',
                  color: _colorTidak,
                  onTap: onTidak,
                  r: r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tombol pilihan Ya / Tidak
// ─────────────────────────────────────────────────────────────────────────────
class _PilihanButton extends StatelessWidget {
  const _PilihanButton({
    required this.label,
    required this.color,
    required this.onTap,
    required this.r,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: r.h(40),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(r.r(10)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: r.sp(13),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
