import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingProfileScreen extends StatefulWidget {
  const LoadingProfileScreen({super.key});

  @override
  State<LoadingProfileScreen> createState() => _LoadingProfileScreenState();
}

class _LoadingProfileScreenState extends State<LoadingProfileScreen>
    with TickerProviderStateMixin {
  // ── Progress simulasi ──────────────────────────────────────────────────────
  double _progress = 0.0;

  // ── Pulse animation: 3 lingkaran melebar & memudar ────────────────────────
  late final AnimationController _pulseController;
  late final Animation<double> _pulse1Scale;
  late final Animation<double> _pulse1Opacity;
  late final Animation<double> _pulse2Scale;
  late final Animation<double> _pulse2Opacity;
  late final Animation<double> _pulse3Scale;
  late final Animation<double> _pulse3Opacity;

  @override
  void initState() {
    super.initState();

    // Pulse — loop terus-menerus, 3 gelombang dengan delay
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _pulse1Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.55), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.55, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _pulse1Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.35, end: 0.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.35), weight: 50),
    ]).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _pulse2Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: const Interval(0.15, 1.0, curve: Curves.easeInOut),
    ));

    _pulse2Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.25, end: 0.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.25), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: const Interval(0.15, 1.0, curve: Curves.easeInOut),
    ));

    _pulse3Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    _pulse3Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.18, end: 0.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.18), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    _startProgress();
  }

  /// Simulasi loading progress 0 → 100% dalam ~3 detik,
  /// lalu navigasi ke /home.
  void _startProgress() async {
    const totalDuration = Duration(milliseconds: 3000);
    const tickInterval = Duration(milliseconds: 50);
    final totalTicks = totalDuration.inMilliseconds ~/ tickInterval.inMilliseconds;

    for (int i = 1; i <= totalTicks; i++) {
      await Future.delayed(tickInterval);
      if (!mounted) return;
      setState(() {
        _progress = i / totalTicks;
      });
    }

    // Selesai → navigasi ke home
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int percent = (_progress * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ── Ikon dengan efek pulse ─────────────────────────────
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran pulse terluar
                        Transform.scale(
                          scale: _pulse1Scale.value,
                          child: Opacity(
                            opacity: _pulse1Opacity.value,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFCECD),
                              ),
                            ),
                          ),
                        ),
                        // Lingkaran pulse tengah
                        Transform.scale(
                          scale: _pulse2Scale.value,
                          child: Opacity(
                            opacity: _pulse2Opacity.value,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFCECD),
                              ),
                            ),
                          ),
                        ),
                        // Lingkaran pulse dalam
                        Transform.scale(
                          scale: _pulse3Scale.value,
                          child: Opacity(
                            opacity: _pulse3Opacity.value,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFCECD),
                              ),
                            ),
                          ),
                        ),
                        // Lingkaran inti (solid, tidak beranimasi)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFCECD),
                          ),
                          child: const Icon(
                            Icons.people_rounded,
                            color: Color(0xFFE8928A),
                            size: 48,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // ── Judul ──────────────────────────────────────────────
              Text(
                'Menyiapkan Ruang\nTumbuh Terbaik...',
                textAlign: TextAlign.center,
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 14),

              // ── Subjudul ───────────────────────────────────────────
              Text(
                'Menyesuaikan materi asesmen dan panduan\nstimulasi belajar sesuai usia Si Kecil',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7A7A7A),
                  height: 1.6,
                ),
              ),

              const Spacer(flex: 3),

              // ── Label + Persentase ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MEMPROSES PROFIL',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7A7A7A),
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4A90D9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Progress Bar ───────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFEEEEEE),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFCECD),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
