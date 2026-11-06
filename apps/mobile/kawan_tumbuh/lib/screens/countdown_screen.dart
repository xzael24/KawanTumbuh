import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Countdown Screen
// Alur:
//   1. Jam muncul (slide + fade in dari bawah)
//   2. Jam getar kanan-kiri (shake)
//   3. Jam hilang (fade out)
//   4. Angka 3 → 2 → 1 muncul di posisi tengah (tempat jam)
//   5. Auto navigasi ke route tujuan
// ─────────────────────────────────────────────────────────────
class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with TickerProviderStateMixin {

  // Phase: 0=jam masuk, 1=jam getar, 2=jam hilang, 3=angka
  int _phase = 0;
  int _count = 0;

  // ── Entry: jam slide + fade in ─────────────────────────────
  late final AnimationController _entryCtrl;
  late final Animation<double>   _entryOpacity;
  late final Animation<Offset>   _entrySlide;

  // ── Exit: jam fade out ────────────────────────────────────
  late final AnimationController _exitCtrl;
  late final Animation<double>   _exitOpacity;

  // ── Shake ─────────────────────────────────────────────────
  late final AnimationController _shakeCtrl;
  late final Animation<double>   _shakeOffset;

  // ── Angka pop in ──────────────────────────────────────────
  late final AnimationController _numberCtrl;
  late final Animation<double>   _numberScale;
  late final Animation<double>   _numberOpacity;

  @override
  void initState() {
    super.initState();

    // Entry
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entryOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    // Exit
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    // Shake
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _shakeOffset = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut),
    );

    // Number
    _numberCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _numberScale = Tween<double>(begin: 1.6, end: 1.0).animate(
      CurvedAnimation(parent: _numberCtrl, curve: Curves.easeOutBack),
    );
    _numberOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _numberCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // ── FASE 0: Jam masuk ─────────────────────────────────
    setState(() => _phase = 0);
    _entryCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 700));

    // ── FASE 1: Jam getar ─────────────────────────────────
    if (!mounted) return;
    setState(() => _phase = 1);
    for (int i = 0; i < 8; i++) {
      if (!mounted) return;
      await _shakeCtrl.forward(from: 0);
      if (!mounted) return;
      await _shakeCtrl.reverse();
    }
    await Future.delayed(const Duration(milliseconds: 150));

    // ── FASE 2: Jam hilang ────────────────────────────────
    if (!mounted) return;
    setState(() => _phase = 2);
    _exitCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 350));

    // ── FASE 3: Angka 3 → 2 → 1 ──────────────────────────
    if (!mounted) return;
    setState(() => _phase = 3);

    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _count = i);
      _numberCtrl.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 900));
    }

    if (!mounted) return;

    final destination = ModalRoute.of(context)?.settings.arguments as String?
        ?? '/assessment-dyscalculia';

    Navigator.of(context).pushReplacementNamed(destination);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _exitCtrl.dispose();
    _shakeCtrl.dispose();
    _numberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            // ── Area tengah ────────────────────────────────────
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ── Jam (fase 0, 1, 2) ─────────────────────
                    if (_phase < 3)
                      FadeTransition(
                        opacity: _phase == 2 ? _exitOpacity : _entryOpacity,
                        child: SlideTransition(
                          position: _entrySlide,
                          child: AnimatedBuilder(
                            animation: _shakeCtrl,
                            builder: (context, child) {
                              final dx = _phase == 1
                                  ? _shakeOffset.value * 16.0
                                  : 0.0;
                              return Transform.translate(
                                offset: Offset(dx, 0),
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/images/alarm_clock.png',
                              width: 300,
                              height: 300,
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) {
                                return Container(
                                  width: 300,
                                  height: 300,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F2F1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.alarm_rounded,
                                    size: 150,
                                    color: Color(0xFF5F8F8A),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    // ── Angka (fase 3) ─────────────────────────
                    if (_phase == 3)
                      AnimatedBuilder(
                        animation: _numberCtrl,
                        builder: (context, _) {
                          return Opacity(
                            opacity: _numberOpacity.value,
                            child: Transform.scale(
                              scale: _numberScale.value,
                              child: Text(
                                _count > 0 ? '$_count' : '',
                                style: GoogleFonts.quicksand(
                                  fontSize: 120,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2A2A2A),
                                  height: 1.0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // ── Teks bawah ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 52),
              child: Text(
                'Ayo siap-siap ya!',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2A2A2A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
