import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Assessment Dysgraphia Intro Screen
// Halaman pengantar sebelum sesi menulis (disgrafia).
// Menampilkan persiapan alat tulis + kalimat yang harus disalin.
// Tombol "Foto Tulisan" mengarahkan orang tua untuk mengambil foto.
// ─────────────────────────────────────────────────────────────
class AssessmentDysgraphiaIntroScreen extends StatelessWidget {
  const AssessmentDysgraphiaIntroScreen({super.key});

  // Kalimat yang harus disalin anak
  static const String _sentence = 'Ini Ibu Budi';

  void _onFotoTulisan(BuildContext context) {
    Navigator.of(context).pushNamed('/dysgraphia-camera');
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Logo KawanTumbuh ───────────────────────
                    _KawanTumbuhLogo(),

                    const SizedBox(height: 32),

                    // Ilustrasi clipboard ────────────────────
                    Image.asset(
                      'assets/images/assesment_ikhtisar.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) => Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2F1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 80,
                          color: Color(0xFF5F8F8A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Judul ──────────────────────────────────
                    Text(
                      'Sesi Menulis',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── Deskripsi ──────────────────────────────
                    Text(
                      'Tes ini membantu kami melihat kemampuan motorik halus. Yuk siapkan alatnya:',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7A7A7A),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Card: Daftar alat ──────────────────────
                    _PersiapanCard(),

                    const SizedBox(height: 24),

                    // ── Label kalimat ──────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Minta anak menyalin kalimat ini di kertas:',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A7A7A),
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Kartu kalimat ──────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _sentence,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Tombol Foto Tulisan (sticky bawah) ────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _onFotoTulisan(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F8F8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Text(
                    'Foto Tulisan',
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
// Widget: Logo KawanTumbuh
// ─────────────────────────────────────────────────────────────
class _KawanTumbuhLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo_kawantumbuh.png',
          height: 32,
          errorBuilder: (ctx, err, stack) => const Icon(
            Icons.eco,
            color: Color(0xFF5F8F8A),
            size: 32,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'KawanTumbuh',
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF5F8F8A),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Card daftar persiapan alat
// ─────────────────────────────────────────────────────────────
class _PersiapanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      'Kertas putih polos',
      'Pulpen hitam',
      'Ruangan dengan cahaya\nyang cukup',
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ikon clipboard checklist
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F2F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.assignment_turned_in_outlined,
                        color: Color(0xFF5F8F8A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        items[i],
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}
