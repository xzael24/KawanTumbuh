import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Apresiasi Screen
// Ditampilkan setelah asesmen diskalkulia selesai.
// Tombol "Mulai Membaca" mengarahkan ke tes disleksia.
// ─────────────────────────────────────────────────────────────
class ApresiasiScreen extends StatelessWidget {
  const ApresiasiScreen({super.key});

  void _onMulaiMembaca(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/countdown',
      arguments: '/assessment-dyslexia',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            // ── Konten tengah ──────────────────────────────────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Ilustrasi ────────────────────────────────
                  Flexible(
                    child: Image.asset(
                      'assets/images/apresiasi_kids.png',
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) => const Icon(
                        Icons.emoji_events_rounded,
                        size: 120,
                        color: Color(0xFF5F8F8A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Judul ────────────────────────────────────
                  Text(
                    'Kerja Bagus!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Deskripsi ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Sekarang, yuk kita coba sesi membaca.\nSiapkan suaramu yang paling lantang, ya!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7A7A7A),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Tombol Mulai Membaca (sticky bawah) ───────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _onMulaiMembaca(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F8F8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Text(
                    'Mulai Membaca',
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
