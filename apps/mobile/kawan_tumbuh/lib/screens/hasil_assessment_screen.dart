import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Hasil Assessment Screen
// Menampilkan ringkasan hasil keseluruhan 3 asesmen:
//   - Diseleksia, Diskalkulia, Disgrafia
// Setiap kartu bisa di-expand untuk lihat skor & deskripsi.
// ─────────────────────────────────────────────────────────────

// Model data untuk tiap hasil asesmen
class _AssessmentResult {
  final String label;       // "Aa", "123", icon
  final bool isIconText;    // true = text label, false = IconData
  final IconData? icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final int scorePercent;   // 0–100
  final String description;

  const _AssessmentResult({
    required this.label,
    required this.isIconText,
    this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.scorePercent,
    required this.description,
  });
}

class HasilAssessmentScreen extends StatefulWidget {
  const HasilAssessmentScreen({super.key});

  @override
  State<HasilAssessmentScreen> createState() => _HasilAssessmentScreenState();
}

class _HasilAssessmentScreenState extends State<HasilAssessmentScreen> {
  // Index kartu yang sedang di-expand (-1 = tidak ada)
  int _expandedIndex = 2; // default expand Disgrafia sesuai desain

  static const List<_AssessmentResult> _results = [
    _AssessmentResult(
      label: 'Aa',
      isIconText: true,
      iconBgColor: Color(0xFFF5C6B8),
      title: 'Diseleksia',
      subtitle: 'Membaca & Pemahaman Bahasa',
      badgeText: 'Potensi Rendah',
      badgeColor: Color(0xFFE8976A),
      badgeTextColor: Colors.white,
      scorePercent: 80,
      description:
          'Kemampuan membaca dan pemahaman bahasa anak berada dalam batas normal. Risiko atau potensi mengalami diseleksia sangat rendah.',
    ),
    _AssessmentResult(
      label: '123',
      isIconText: true,
      iconBgColor: Color(0xFFF5C6B8),
      title: 'Diskalkulia',
      subtitle: 'Angka & Logika Matematika',
      badgeText: 'Berpotensi',
      badgeColor: Color(0xFF7CBF7C),
      badgeTextColor: Colors.white,
      scorePercent: 55,
      description:
          'Anak menunjukkan beberapa tanda kesulitan dalam memahami konsep angka dan logika matematika. Disarankan untuk pendampingan lebih lanjut.',
    ),
    _AssessmentResult(
      label: '',
      isIconText: false,
      icon: Icons.edit_rounded,
      iconBgColor: Color(0xFFF5C6B8),
      title: 'Disgrafia',
      subtitle: 'Menulis & Motorik Halus',
      badgeText: 'Potensi Rendah',
      badgeColor: Color(0xFFE8976A),
      badgeTextColor: Colors.white,
      scorePercent: 65,
      description:
          'Kemampuan motorik halus dan menulis anak berada dalam batas normal. Risiko atau potensi mengalami disgrafia sangat rendah.',
    ),
  ];

  void _onLanjut() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            // ── Konten scrollable ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // ── Ilustrasi clipboard ────────────────────
                    Image.asset(
                      'assets/images/hasil_assessment.png',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) => const Icon(
                        Icons.assignment_turned_in_rounded,
                        size: 100,
                        color: Color(0xFF5F8F8A),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Judul ──────────────────────────────────
                    Text(
                      'Test Selesai!',
                      style: GoogleFonts.quicksand(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ── Subjudul ───────────────────────────────
                    Text(
                      'Hasil keseluruhan test anak.',
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A7A7A),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Chip nama anak ─────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEAE3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Dot online
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Bima (7 Thn)',
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Label section ──────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RINGKASAN PEMBELAJARAN',
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9A9A9A),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Kartu hasil tiap asesmen ───────────────
                    ...List.generate(_results.length, (i) {
                      return _ResultCard(
                        result: _results[i],
                        isExpanded: _expandedIndex == i,
                        onTap: () {
                          setState(() {
                            _expandedIndex = _expandedIndex == i ? -1 : i;
                          });
                        },
                      );
                    }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Tombol Lanjut (sticky bawah) ──────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onLanjut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F8F8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Lanjut',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
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

// ─────────────────────────────────────────────────────────────
// Widget: Kartu satu hasil asesmen (collapsible)
// ─────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.isExpanded,
    required this.onTap,
  });

  final _AssessmentResult result;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header row ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  // Icon/label bulat
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: result.iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: result.isIconText
                        ? Text(
                            result.label,
                            style: GoogleFonts.quicksand(
                              fontSize: result.label.length > 2 ? 11 : 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          )
                        : Icon(
                            result.icon,
                            size: 20,
                            color: const Color(0xFF1A1A1A),
                          ),
                  ),

                  const SizedBox(width: 12),

                  // Teks judul + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.title,
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          result.subtitle,
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A9A9A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: result.badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      result.badgeText,
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: result.badgeTextColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Chevron
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF9A9A9A),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // ── Expanded content ─────────────────────────────
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              firstCurve: Curves.easeIn,
              secondCurve: Curves.easeOut,
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                    const SizedBox(height: 12),

                    // Skor baris
                    Row(
                      children: [
                        Text(
                          'Skor Test : ',
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          '${result.scorePercent}%',
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD4A017),
                          ),
                        ),
                        Text(
                          ' /100%',
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9A9A9A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: result.scorePercent / 100,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFEEEEEE),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFD4A017),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Deskripsi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        result.description,
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF5A5A5A),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
