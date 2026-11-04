import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Data satu soal tes disleksia
// ─────────────────────────────────────────────────────────────
class _DyslexiaQuestion {
  final String sentence; // kalimat yang harus diucapkan

  const _DyslexiaQuestion({required this.sentence});
}

// Soal sementara — 1 soal
const List<_DyslexiaQuestion> _questions = [
  _DyslexiaQuestion(sentence: 'Ini Ibu Budi'),
];

// ─────────────────────────────────────────────────────────────
// Assessment Dyslexia Screen
// Step indicator + kartu kalimat + waveform perekam animasi
// ─────────────────────────────────────────────────────────────
class AssessmentDyslexiaScreen extends StatefulWidget {
  const AssessmentDyslexiaScreen({super.key});

  @override
  State<AssessmentDyslexiaScreen> createState() =>
      _AssessmentDyslexiaScreenState();
}

class _AssessmentDyslexiaScreenState extends State<AssessmentDyslexiaScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // State rekaman
  bool _isRecording = false;
  Timer? _recordingTimer;

  // Animasi waveform — bar-bar naik turun acak
  late final AnimationController _waveController;

  // Animasi kedip titik merah "Sedang Mendengar..."
  late final AnimationController _dotController;
  late final Animation<double> _dotOpacity;

  // Tinggi tiap bar waveform (18 bar)
  static const int _barCount = 18;
  final List<double> _barHeights = List.filled(_barCount, 0.3);
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Waveform — update tiap 120ms, tidak langsung jalan
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    )..addListener(_updateBars);

    // Titik merah kedip
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _dotOpacity = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeInOut),
    );

    // Mulai rekaman otomatis saat halaman dibuka
    _startRecording();
  }

  void _startRecording() {
    setState(() => _isRecording = true);
    _waveController.repeat();

    // Berhenti otomatis setelah 5 detik
    _recordingTimer = Timer(const Duration(seconds: 5), _stopRecording);
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    _waveController.stop();
    // Reset semua bar ke tinggi minimum
    setState(() {
      _isRecording = false;
      for (int i = 0; i < _barCount; i++) {
        _barHeights[i] = 0.15;
      }
    });
  }

  void _updateBars() {
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < _barCount; i++) {
        // Geser bar ke kiri, tambah bar baru di kanan
        if (i < _barCount - 1) {
          _barHeights[i] = _barHeights[i + 1];
        } else {
          // Bar paling kanan — nilai acak antara 0.15 hingga 1.0
          _barHeights[i] = 0.15 + _random.nextDouble() * 0.85;
        }
      }
    });
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _waveController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
      _startRecording(); // mulai rekaman untuk soal berikutnya
    } else {
      Navigator.of(context).pushReplacementNamed('/apresiasi-dyslexia');
    }
  }

  _DyslexiaQuestion get _current => _questions[_currentIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),

              // ── Step Indicator ──────────────────────────────
              _StepIndicator(
                total: _questions.length,
                current: _currentIndex,
              ),

              const SizedBox(height: 36),

              // ── Pertanyaan ──────────────────────────────────
              Text(
                'Jawab dan ucapkan\nkalimat ini!',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // ── Kartu kalimat ───────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
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
                  _current.sentence,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(),

              // ── Label STATUS MEREKAM ────────────────────────
              Text(
                _isRecording ? 'STATUS MEREKAM' : 'REKAMAN SELESAI',
                style: GoogleFonts.quicksand(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _isRecording
                      ? const Color(0xFF7A7A7A)
                      : const Color(0xFF5F8F8A),
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 10),

              // ── Kartu waveform ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Baris status ──────────────────────────
                    Row(
                      children: [
                        // Titik kedip (merah saat rekam, hijau saat selesai)
                        AnimatedBuilder(
                          animation: _dotOpacity,
                          builder: (context, _) {
                            return Opacity(
                              opacity: _isRecording ? _dotOpacity.value : 1.0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isRecording
                                      ? const Color(0xFFE53935)
                                      : const Color(0xFF5F8F8A),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isRecording
                              ? 'Sedang Mendengar...'
                              : 'Rekaman Selesai',
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF3A3A3A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Waveform bar ─────────────────────────
                    SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(_barCount, (i) {
                          final h = _barHeights[i];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: 5,
                            height: 56 * h,
                            decoration: BoxDecoration(
                              color: _isRecording
                                  ? const Color(0xFF2A2A2A)
                                  : const Color(0xFF5F8F8A),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Tombol Lanjut (muncul setelah rekaman selesai) ──
              AnimatedOpacity(
                opacity: _isRecording ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 400),
                child: IgnorePointer(
                  ignoring: _isRecording,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F8F8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Lanjut',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Step Indicator
// ─────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.total, required this.current});

  final int total;
  final int current;

  // Tampilkan minimal 5 lingkaran agar konsisten dengan desain
  int get _displayTotal => total < 5 ? 5 : total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_displayTotal, (i) {
        final isActive = i == current;
        final isDone   = i < current;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFF5F8F8A) : Colors.white,
              border: Border.all(
                color: isActive || isDone
                    ? const Color(0xFF5F8F8A)
                    : const Color(0xFFCCCCCC),
                width: 1.5,
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Color(0xFF5F8F8A),
                    )
                  : Text(
                      '${i + 1}',
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFFAAAAAA),
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}
