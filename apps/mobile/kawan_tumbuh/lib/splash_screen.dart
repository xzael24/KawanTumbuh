import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoFade;

  late AnimationController _titleController;
  late Animation<double> _titleFade;

  late AnimationController _taglineController;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeIn),
    );

    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // 1. Logo fade in
    await _logoController.forward();
    if (!mounted) return;

    // 2. Title fade in
    await _titleController.forward();
    if (!mounted) return;

    // 3. Tagline fade in
    await _taglineController.forward();
    if (!mounted) return;

    // 4. Tahan lalu navigate ke onboarding
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
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
      backgroundColor: const Color(0xFFF5F0E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            FadeTransition(
              opacity: _logoFade,
              child: Image.asset(
                'assets/images/logo_kawantumbuh.png',
                width: 120,
                height: 120,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            FadeTransition(
              opacity: _titleFade,
              child: Text(
                'KawanTumbuh',
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5F8F8A),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Tagline
            FadeTransition(
              opacity: _taglineFade,
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
