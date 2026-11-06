import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Countdown Screen
// Langsung hitung mundur 3 → 2 → 1 di tengah layar,
// lalu auto navigasi ke route tujuan.
//
// Cara pakai:
//   Navigator.of(context).pushNamed(
//     '/countdown',
//     arguments: '/assessment-dyscalculia', // route tujuan
//   );
//
// Kalau tidak ada arguments, default ke /assessment-dyscalculia
// ─────────────────────────────────────────────────────────────
class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with SingleTickerProviderStateMixin {
  int _count = 3;

  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scale = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _startCountdown();
  }

  Future<void> _startCountdown() async {
    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _count = i);
      _controller.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    if (!mounted) return;

    // Ambil route tujuan dari arguments, default ke dyscalculia
    final destination = ModalRoute.of(context)?.settings.arguments as String?
        ?? '/assessment-dyscalculia';

    Navigator.of(context).pushReplacementNamed(destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      body: SafeArea(
        child: Column(
          children: [
            // ── Angka di tengah layar ──────────────────────────
            Expanded(
              flex: 2,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _opacity.value,
                      child: Transform.scale(
                        scale: _scale.value,
                        child: Text(
                          '$_count',
                          style: GoogleFonts.quicksand(
                            fontSize: 100,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2A2A2A),
                            height: 1.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Teks bawah ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Text(
                'Ayo siap-siap ya!',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
