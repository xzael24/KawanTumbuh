import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Tiap elemen muncul berurutan dalam satu timeline
    _logoFade    = _interval(0.00, 0.40);
    _titleFade   = _interval(0.35, 0.70);
    _taglineFade = _interval(0.60, 0.90);

    _ctrl.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  Animation<double> _interval(double begin, double end) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(begin, end, curve: Curves.easeIn),
        ),
      );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _logoFade,
              child: RepaintBoundary(
                child: Image.asset(
                  'assets/images/logo_kawantumbuh.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
