import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TreatmentDyscalculiaScreen extends StatelessWidget {
  const TreatmentDyscalculiaScreen({super.key});

  // Data 7 sesi terapi diskalkulia
  static const List<Map<String, dynamic>> _sessions = [
    {
      'title': 'Sesi 1: Mengenal Angka',
      'image': 'assets/images/session_dyscalculia_1.png',
      'isUnlocked': true,
      'isCompleted': true,
      'stars': 3,
    },
    {
      'title': 'Sesi 2: Memahami Jumlah',
      'image': 'assets/images/session_dyscalculia_2.png',
      'isUnlocked': true,
      'isCompleted': false,
      'stars': 0,
    },
    {
      'title': 'Sesi 3: Mengenal Pola Bilangan',
      'image': 'assets/images/session_dyscalculia_3.png',
      'isUnlocked': false,
      'isCompleted': false,
      'stars': 0,
    },
    {
      'title': 'Sesi 4: Belajar Penjumlahan',
      'image': 'assets/images/session_dyscalculia_4.png',
      'isUnlocked': false,
      'isCompleted': false,
      'stars': 0,
    },
    {
      'title': 'Sesi 5: Mengenal Bentuk dan Ukuran',
      'image': 'assets/images/session_dyscalculia_5.png',
      'isUnlocked': false,
      'isCompleted': false,
      'stars': 0,
    },
    {
      'title': 'Sesi 6: Mengurutkan dan Membandingkan',
      'image': 'assets/images/session_dyscalculia_6.png',
      'isUnlocked': false,
      'isCompleted': false,
      'stars': 0,
    },
    {
      'title': 'Sesi 7: Tantangan Berhitung',
      'image': 'assets/images/session_dyscalculia_7.png',
      'isUnlocked': false,
      'isCompleted': false,
      'stars': 0,
    },
  ];

  static const int _completedSessions = 2;
  static const int _totalSessions = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            // ── APP BAR ──────────────────────────────────────────────
            _buildAppBar(context),

            // ── SCROLLABLE CONTENT ───────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Pilih Gejala
                    Text(
                      'Pilih Gejala',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGejalaSelector(context),
                    const SizedBox(height: 24),

                    // Progres
                    Text(
                      'Progres Terapi Diskalkulia',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildProgressCard(),
                    const SizedBox(height: 12),
                    _buildEvaluasiCard(),
                    const SizedBox(height: 24),

                    // Sesi Terapi
                    Text(
                      'Sesi Terapi',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSessionList(context),
                    const SizedBox(height: 24),

                    // Unduh Laporan
                    _buildUnduhLaporanButton(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: _buildChatbotFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ── APP BAR ──────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol kembali
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF1A1A1A),
                ),
                const SizedBox(width: 6),
                Text(
                  'Kembali',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),

          // Judul
          Text(
            'Terapi Aca',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),

          // Tombol Laporan
          GestureDetector(
            onTap: () {
              // TODO: navigasi ke halaman laporan
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF28B6E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Laporan',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── PILIH GEJALA ─────────────────────────────────────────────────────
  Widget _buildGejalaSelector(BuildContext context) {
    final gejalaItems = [
      {
        'label': 'Diskalkulia',
        'sublabel': '',
        'image': 'assets/images/therapy_dyscalculia.png',
        'isSelected': true,
      },
      {
        'label': 'Disleksia',
        'sublabel': '',
        'image': 'assets/images/therapy_dyslexia.png',
        'isSelected': false,
      },
      {
        'label': 'Disgrafia',
        'sublabel': '',
        'image': 'assets/images/therapy_dysgraphia.png',
        'isSelected': false,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: gejalaItems.map((item) {
        final isSelected = item['isSelected'] as bool;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              // TODO: ganti ke treatment page yang sesuai
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 90,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF28B6E)
                    : const Color(0xFFFFEBE9),
                borderRadius: BorderRadius.circular(14),
                border: isSelected
                    ? Border.all(color: const Color(0xFFE8928A), width: 2)
                    : Border.all(color: Colors.transparent, width: 2),
              ),
              child: Column(
                children: [
                  // Placeholder gambar — ganti dengan image sesungguhnya
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => Icon(
                          Icons.calculate_rounded,
                          size: 32,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFF28B6E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['label'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if ((item['sublabel'] as String).isNotEmpty) ...[
                    Text(
                      item['sublabel'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.85)
                            : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── KARTU PROGRES ─────────────────────────────────────────────────────
  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB3AE), Color(0xFFFDD5D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Ilustrasi — ganti dengan gambar yang kamu inginkan
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/progress_dyscalculia.png',
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) => const Icon(
                  Icons.emoji_events_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hebat!',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aca Berhasil Menyelesaikan\n$_completedSessions dari $_totalSessions Sesi Hingga ini',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── KARTU EVALUASI AKHIR ──────────────────────────────────────────────
  Widget _buildEvaluasiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCECD), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skrining Evaluasi Akhir',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selesaikan Semua Sesi Untuk\nMembuka Skrining Evaluasi',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF888888),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Ilustrasi evaluasi — ganti dengan gambar yang kamu inginkan
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBE9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/evaluasi_dyscalculia.png',
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) => const Icon(
                  Icons.assignment_rounded,
                  size: 32,
                  color: Color(0xFFF28B6E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TOMBOL SELESAIKAN SESI ────────────────────────────────────────────
  Widget _buildSelesaikanButton() {
    return GestureDetector(
      onTap: () {
        // TODO: aksi selesaikan sesi
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF28B6E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_rounded, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              'Selesaikan 7 Sesi',
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── DAFTAR SESI ───────────────────────────────────────────────────────
  Widget _buildSessionList(BuildContext context) {
    return Column(
      children: List.generate(_sessions.length, (index) {
        final session = _sessions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSessionCard(context, session, index),
        );
      }),
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    Map<String, dynamic> session,
    int index,
  ) {
    final isUnlocked = session['isUnlocked'] as bool;
    final isCompleted = session['isCompleted'] as bool;
    final stars = session['stars'] as int;

    // Sesi 2 yang sedang aktif (unlocked tapi belum selesai)
    final isActive = isUnlocked && !isCompleted;

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              // TODO: navigasi ke halaman sesi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Membuka ${session['title']}...',
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: const Color(0xFF5F8F8A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isActive
              ? Border.all(color: const Color(0xFFF28B6E), width: 2)
              : Border.all(color: const Color(0xFFEEEEEE), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ikon / Gambar sesi
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? const Color(0xFFFFEBE9)
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isUnlocked
                    ? Image.asset(
                        session['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => Icon(
                          Icons.calculate_rounded,
                          size: 28,
                          color: const Color(0xFFF28B6E),
                        ),
                      )
                    : const Icon(
                        Icons.lock_rounded,
                        size: 28,
                        color: Color(0xFFCCCCCC),
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Judul sesi
            Expanded(
              child: Text(
                session['title'] as String,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isUnlocked
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFAAAAAA),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Status: bintang / lanjut / terkunci
            if (isCompleted && stars > 0)
              Row(
                children: List.generate(
                  3,
                  (i) => Icon(
                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: const Color(0xFFFFC107),
                    size: 20,
                  ),
                ),
              )
            else if (isActive)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF28B6E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Lanjut',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            else
              Row(
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    size: 14,
                    color: Color(0xFFCCCCCC),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Terkunci',
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFCCCCCC),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ── UNDUH LAPORAN ─────────────────────────────────────────────────────
  Widget _buildUnduhLaporanButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: aksi unduh laporan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Fitur unduh laporan segera hadir!',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xFF5F8F8A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF28B6E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          'Unduh Laporan',
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ── CHATBOT FAB ───────────────────────────────────────────────────────
  Widget _buildChatbotFAB(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigasi ke halaman chatbot
      },
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFF28B6E),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF28B6E).withValues(alpha: 0.45),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/ic_chatbot.png',
            width: 28,
            height: 28,
            color: Colors.white,
            errorBuilder: (ctx, _, __) => const Icon(
              Icons.chat_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  // ── BOTTOM NAV BAR ────────────────────────────────────────────────────
  Widget _buildBottomNavBar(BuildContext context) {
    final items = [
      {'icon': 'assets/images/ic_home.png', 'label': 'Home'},
      {'icon': 'assets/images/ic_treatment.png', 'label': 'Treatment'},
      {'icon': 'assets/images/ic_artikel.png', 'label': 'Artikel'},
      {'icon': 'assets/images/ic_profile.png', 'label': 'Profil'},
    ];

    // Index 1 (Treatment) selalu aktif di halaman ini
    const selectedIndex = 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  } else if (index == 2) {
                    Navigator.pushNamed(context, '/artikel');
                  }
                  // index 1 = halaman ini, index 3 = TODO profil
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        items[index]['icon']!,
                        width: 24,
                        height: 24,
                        color: isSelected
                            ? const Color(0xFFF88D95)
                            : const Color(0xFFAAAAAA),
                        errorBuilder: (ctx, _, __) => Icon(
                          _fallbackIcon(index),
                          size: 24,
                          color: isSelected
                              ? const Color(0xFFF88D95)
                              : const Color(0xFFAAAAAA),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index]['label']!,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFFF88D95)
                              : const Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _fallbackIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.medical_services_rounded;
      case 2:
        return Icons.article_rounded;
      case 3:
        return Icons.person_rounded;
      default:
        return Icons.circle;
    }
  }
}
