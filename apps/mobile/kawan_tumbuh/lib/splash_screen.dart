import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controller untuk logo (scale + fade)
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnim;
  late Animation<double> _logoFadeAnim;

  // Controller untuk teks "KawanTumbuh" (fade + slide up)
  late AnimationController _titleController;
  late Animation<double> _titleFadeAnim;
  late Animation<Offset> _titleSlideAnim;

  // Controller untuk tagline (fade)
  late AnimationController _taglineController;
  late Animation<double> _taglineFadeAnim;

  @override
  void initState() {
    super.initState();

    // --- Animasi Logo ---
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    // --- Animasi Title ---
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeIn),
    );

    _titleSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );

    // --- Animasi Tagline ---
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _taglineFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    // Urutan animasi: logo → title → tagline → navigate
    _runAnimationSequence();
  }

  Future<void> _runAnimationSequence() async {
    // Sedikit delay awal agar layar render dulu
    await Future.delayed(const Duration(milliseconds: 300));

    // 1. Logo muncul
    await _logoController.forward();

    // 2. Title muncul
    await Future.delayed(const Duration(milliseconds: 100));
    await _titleController.forward();

    // 3. Tagline muncul
    await Future.delayed(const Duration(milliseconds: 80));
    await _taglineController.forward();

    // 4. Tahan sebentar lalu navigasi ke halaman berikutnya
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Ganti '/home' dengan route halaman utama kamu
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8), // warna krem dari desain
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Logo ---
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _logoFadeAnim,
                  child: ScaleTransition(
                    scale: _logoScaleAnim,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/logo_kawantumbuh.png',
                width: 120,
                height: 120,
              ),
            ),

            const SizedBox(height: 24),

            // --- Teks "KawanTumbuh" ---
            AnimatedBuilder(
              animation: _titleController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _titleFadeAnim,
                  child: SlideTransition(
                    position: _titleSlideAnim,
                    child: child,
                  ),
                );
              },
              child: Text(
                'KawanTumbuh',
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5F8F8A), // warna hijau toska desain
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // --- Tagline ---
            AnimatedBuilder(
              animation: _taglineController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _taglineFadeAnim,
                  child: child,
                );
              },
              child: Text(
                'Teman Tumbuh Si Kecil',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5F8F8A),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
