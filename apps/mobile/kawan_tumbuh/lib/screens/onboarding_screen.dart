import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data tiap halaman onboarding
  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/ob1_illustration.png',
      'title': 'Tumbuh Bersama\ndi Setiap Langkahnya',
      'subtitle': 'Kenali potensi dan stimulasi tumbuh\nkembangnya sejak dini',
    },
    {
      'image': 'assets/images/ob1_illustration.png',
      'title': 'Pantau Perkembangan\nLewat Bermain',
      'subtitle': 'Kenali gaya belajar si kecil lewat\npermainan interaktif',
    },
    {
      'image': 'assets/images/ob1_illustration.png',
      'title': 'Dampingi Si Kecil Tumbuh\nPercaya Diri',
      'subtitle': 'Dapatkan panduan stimulasi harian\nsesuai kebutuhan unik si kecil',
    },
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToHome();
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToHome() {
    Navigator.of(context).pushReplacementNamed('/register');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFirst = _currentPage == 0;
    final bool isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFFFCECD),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: tombol back (hanya OB 2 & 3) ─────────────────
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerLeft,
                child: isFirst
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: _onBack,
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 28,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
              ),
            ),

            // ── PageView ──────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    imagePath: _pages[index]['image']!,
                    title: _pages[index]['title']!,
                    subtitle: _pages[index]['subtitle']!,
                  );
                },
              ),
            ),

            // ── Dot Indicator ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _DotIndicator(isActive: index == _currentPage),
                ),
              ),
            ),

            // ── Bottom Nav: Lewati / Lanjut|Mulai ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Lewati — area klik diperbesar pakai TextButton
                  TextButton(
                    onPressed: _goToHome,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      minimumSize: const Size(80, 48),
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    child: Text(
                      'Lewati',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4A4A4A),
                      ),
                    ),
                  ),

                  // Lanjut → / Mulai → — area klik diperbesar
                  TextButton(
                    onPressed: _onNext,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      minimumSize: const Size(80, 48),
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLast ? 'Mulai' : 'Lanjut',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Color(0xFF4A4A4A),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget: satu halaman onboarding
// ─────────────────────────────────────────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Ilustrasi — pakai Flexible agar menyusut di layar kecil
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Judul
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D2D2D),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),

          // Subjudul
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7A7A7A),
              height: 1.6,
            ),
          ),

          const Flexible(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget: titik indikator halaman
// ─────────────────────────────────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF2D2D2D)
            : const Color(0xFFBBBBBB),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}




