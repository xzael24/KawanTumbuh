import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Model satu soal asesmen diskalkulia
// ─────────────────────────────────────────────────────────────
class _Question {
  final String question;   // teks pertanyaan
  final String emoji;      // emoji yang ditampilkan di kartu
  final int emojiCount;    // jumlah emoji yang ditampilkan
  final List<String> options; // 4 pilihan jawaban
  final int correctIndex;  // index jawaban benar (untuk kebutuhan scoring nanti)

  const _Question({
    required this.question,
    required this.emoji,
    required this.emojiCount,
    required this.options,
    required this.correctIndex,
  });
}

// Data soal — sementara 1 soal
const List<_Question> _questions = [
  _Question(
    question: 'Ada berapa bola ini?',
    emoji: '⚽',
    emojiCount: 6,
    options: ['9', '2', '6', '4'],
    correctIndex: 2,
  ),
];

// Warna 4 tombol jawaban (searah jarum jam: kuning, pink, teal, kuning muda)
const List<Color> _buttonColors = [
  Color(0xFFF5C842), // kuning — kiri atas
  Color(0xFFFF8FAB), // pink   — kanan atas
  Color(0xFF4DC8B4), // teal   — kiri bawah
  Color(0xFFFFD580), // kuning muda — kanan bawah
];

// ─────────────────────────────────────────────────────────────
// Assessment Dyscalculia Screen
// ─────────────────────────────────────────────────────────────
class AssessmentDyscalculiaScreen extends StatefulWidget {
  const AssessmentDyscalculiaScreen({super.key});

  @override
  State<AssessmentDyscalculiaScreen> createState() =>
      _AssessmentDyscalculiaScreenState();
}

class _AssessmentDyscalculiaScreenState
    extends State<AssessmentDyscalculiaScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // Animasi slide masuk setiap soal baru
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.12, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeIn),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onAnswer(int optionIndex) {
    // TODO: simpan jawaban _questions[_currentIndex].options[optionIndex]

    if (_currentIndex < _questions.length - 1) {
      // Soal berikutnya
      setState(() => _currentIndex++);
      _slideController.forward(from: 0);
    } else {
      // Soal habis → navigasi ke halaman apresiasi
      Navigator.of(context).pushReplacementNamed('/apresiasi');
    }
  }

  _Question get _current => _questions[_currentIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),

              // ── Step Indicator ──────────────────────────────
              _StepIndicator(
                total: _questions.length,
                current: _currentIndex,
              ),

              const SizedBox(height: 36),

              // ── Konten soal (animasi slide+fade) ─────────────
              Expanded(
                child: AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Pertanyaan ────────────────────────────
                      Text(
                        _current.question,
                        style: GoogleFonts.quicksand(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          height: 1.35,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Kartu emoji ───────────────────────────
                      _EmojiCard(
                        emoji: _current.emoji,
                        count: _current.emojiCount,
                      ),

                      const Spacer(),

                      // ── Grid 4 tombol jawaban ─────────────────
                      _AnswerGrid(
                        options: _current.options,
                        onAnswer: _onAnswer,
                      ),

                      const SizedBox(height: 32),
                    ],
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
// Widget: Step Indicator (lingkaran bernomor)
// ─────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.total, required this.current});

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
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
              color: isActive
                  ? const Color(0xFF5F8F8A)
                  : Colors.white,
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

// ─────────────────────────────────────────────────────────────
// Widget: Kartu emoji (grid 3 kolom, baris secukupnya)
// ─────────────────────────────────────────────────────────────
class _EmojiCard extends StatelessWidget {
  const _EmojiCard({required this.emoji, required this.count});

  final String emoji;
  final int count;

  @override
  Widget build(BuildContext context) {
    const cols = 3;
    final rows = (count / cols).ceil();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
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
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (row) {
          final start = row * cols;
          final end = (start + cols).clamp(0, count);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(end - start, (col) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Grid 2x2 tombol jawaban
// ─────────────────────────────────────────────────────────────
class _AnswerGrid extends StatelessWidget {
  const _AnswerGrid({required this.options, required this.onAnswer});

  final List<String> options;
  final ValueChanged<int> onAnswer;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 2.4,
      children: List.generate(options.length, (i) {
        return _AnswerButton(
          label: options[i],
          color: _buttonColors[i % _buttonColors.length],
          onTap: () => onAnswer(i),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Satu tombol jawaban
// ─────────────────────────────────────────────────────────────
class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }
}
