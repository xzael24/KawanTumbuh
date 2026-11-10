import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ──────────────────────────────────────────────────────────────
// Assessment Overview Screen
// Menampilkan ringkasan sesi asesmen sebelum pengguna memulai.
// ──────────────────────────────────────────────────────────────
class AssessmentOverviewScreen extends StatefulWidget {
  const AssessmentOverviewScreen({super.key});

  @override
  State<AssessmentOverviewScreen> createState() =>
      _AssessmentOverviewScreenState();
}

class _AssessmentOverviewScreenState extends State<AssessmentOverviewScreen> {
  bool _agreeTerms = false;

  void _onMulai() {
    Navigator.of(context).pushNamed('/countdown');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            // ── Konten scrollable ────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // ── Logo ─────────────────────────────────────
                    _KawanTumbuhLogo(),

                    const SizedBox(height: 32),

                    // ── Ilustrasi ─────────────────────────────────
                    Center(
                      child: Image.asset(
                        'assets/images/assesment_ikhtisar.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) => const Icon(
                          Icons.assignment_rounded,
                          size: 120,
                          color: Color(0xFF5F8F8A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Judul ─────────────────────────────────────
                    Text(
                      'Ikhtisar Assesmen',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── Deskripsi ─────────────────────────────────
                    Text(
                      'Mari simak gambaran sesi asesmen si kecil. '
                      'Aktivitas interaktif ini dirancang untuk memetakan potensi belajarnya.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A7A7A),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Card: Persiapan & Metode ──────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _InfoCard(),
                    ),

                    const SizedBox(height: 28),

                    // ── Persetujuan Orang Tua ─────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _ConsentSection(
                        agreed: _agreeTerms,
                        onChanged: (val) => setState(() => _agreeTerms = val),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Tombol Mulai (sticky di bawah) ───────────────────
            _BottomButton(
              enabled: _agreeTerms,
              onPressed: _onMulai,
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
// Widget: Card Informasi (Persiapan & Metode)
// ─────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          _InfoRow(
            icon: Icons.edit_note_rounded,
            title: 'Persiapan',
            description: 'Sediakan kertas, pulpen, dan ruangan yang tenang',
            showDivider: true,
          ),
          _InfoRow(
            icon: Icons.quiz_rounded,
            title: 'Metode',
            description: 'Tes interaktif & kuesoner orang tua',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Satu baris dalam InfoCard
// ─────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.showDivider,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ikon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF5F8F8A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7A7A7A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEEEEEE),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Bagian Persetujuan Orang Tua
// ─────────────────────────────────────────────────────────────
class _ConsentSection extends StatelessWidget {
  const _ConsentSection({
    required this.agreed,
    required this.onChanged,
  });

  final bool agreed;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Persetujuan Orang Tua',
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            GestureDetector(
              onTap: () => onChanged(!agreed),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: agreed ? const Color(0xFF5F8F8A) : Colors.white,
                  border: Border.all(
                    color: agreed
                        ? const Color(0xFF5F8F8A)
                        : const Color(0xFFDDDDDD),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: agreed
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),

            // Teks dengan link
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7A7A7A),
                    height: 1.6,
                  ),
                  children: [
                    const TextSpan(text: 'Saya setuju dengan '),
                    _linkSpan('Syarat Layanan'),
                    const TextSpan(text: ', '),
                    _linkSpan('Kebijakan Privasi'),
                    const TextSpan(text: ', dan '),
                    _linkSpan('Pengaturan Notifikasi'),
                    const TextSpan(text: ' default kami'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextSpan _linkSpan(String label) {
    return TextSpan(
      text: label,
      style: GoogleFonts.quicksand(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2563EB),
        height: 1.6,
        decoration: TextDecoration.underline,
        decorationColor: const Color(0xFF2563EB),
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          // TODO: Navigasi ke halaman sesuai link
          debugPrint('Tapped: $label');
        },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Tombol Mulai (sticky di bagian bawah)
// ─────────────────────────────────────────────────────────────
class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5F8F8A),
            disabledBackgroundColor: const Color(0xFFA8C8C4),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Text(
            'Mulai',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
