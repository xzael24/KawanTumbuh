
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingProfileScreen extends StatefulWidget {
  const LoadingProfileScreen({super.key});

  @override
  State<LoadingProfileScreen> createState() =>
      _LoadingProfileScreenState();
}

class _LoadingProfileScreenState extends State<LoadingProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressCtrl;
  late final Animation<double> _progressAnim;

  late final AnimationController _pulseCtrl;

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    // Progress animation
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _progressAnim = CurvedAnimation(
      parent: _progressCtrl,
      curve: Curves.easeInOut,
    );

    _progressCtrl.forward();

    // Pulse animation
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _startProgress();
  }

  /// Simulasi loading progress 0 → 100%
  /// lalu navigasi ke assessment overview.
  void _startProgress() async {
    const totalDuration = Duration(milliseconds: 3000);
    const tickInterval = Duration(milliseconds: 50);

    final totalTicks =
        totalDuration.inMilliseconds ~/ tickInterval.inMilliseconds;

    for (int i = 1; i <= totalTicks; i++) {
      await Future.delayed(tickInterval);

      if (!mounted) return;

      setState(() {
        _progress = i / totalTicks;
      });
    }

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      '/assessment-overview',
    );
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Animation<double> _waveScale(double start, double end) =>
      Tween<double>(begin: 1.0, end: end).animate(
        CurvedAnimation(
          parent: _pulseCtrl,
          curve: Interval(start, 1.0, curve: Curves.easeInOut),
        ),
      );

  Animation<double> _waveOpacity(double start, double maxOpacity) =>
      Tween<double>(begin: maxOpacity, end: 0.0).animate(
        CurvedAnimation(
          parent: _pulseCtrl,
          curve: Interval(start, 1.0, curve: Curves.easeInOut),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (context, _) {
                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _PulseRing(
                            size: 200,
                            scaleAnim: _waveScale(0.0, 1.55),
                            opacityAnim: _waveOpacity(0.0, 0.35),
                          ),
                          _PulseRing(
                            size: 160,
                            scaleAnim: _waveScale(0.15, 1.35),
                            opacityAnim: _waveOpacity(0.15, 0.25),
                          ),
                          _PulseRing(
                            size: 130,
                            scaleAnim: _waveScale(0.30, 1.20),
                            opacityAnim: _waveOpacity(0.30, 0.18),
                          ),
                          const _CoreIcon(),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

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

              AnimatedBuilder(
                animation: _progressAnim,
                builder: (context, _) {
                  final percent = (_progress * 100).round();

                  return Column(
                    children: [
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

                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFEEEEEE),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFCECD),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget kecil — tiap ring pulse
class _PulseRing extends StatelessWidget {
  const _PulseRing({
    required this.size,
    required this.scaleAnim,
    required this.opacityAnim,
  });

  final double size;
  final Animation<double> scaleAnim;
  final Animation<double> opacityAnim;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleAnim.value,
      child: Opacity(
        opacity: opacityAnim.value,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFCECD),
          ),
        ),
      ),
    );
  }
}

// Widget inti
class _CoreIcon extends StatelessWidget {
  const _CoreIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
