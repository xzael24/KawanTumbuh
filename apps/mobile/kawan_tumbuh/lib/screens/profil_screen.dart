import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // Indeks tab aktif — tab Profil (index 3) selalu aktif di layar ini
  final int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildTopBar(),
                const SizedBox(height: 20),
                _buildPageTitle(),
                const SizedBox(height: 16),
                _buildOrangTuaCard(),
                const SizedBox(height: 12),
                _buildAnakCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Informasi Anak'),
                const SizedBox(height: 12),
                _buildInfoAnakRow(),
                const SizedBox(height: 20),
                _buildMenuButton(
                  label: 'Riwayat Aktivitas',
                  onTap: () {
                    // TODO: navigasi ke riwayat aktivitas
                    _showComingSoon('Riwayat Aktivitas segera hadir!');
                  },
                ),
                const SizedBox(height: 10),
                _buildMenuButton(
                  label: 'Tentang Aplikasi',
                  onTap: () {
                    // TODO: navigasi ke tentang aplikasi
                    _showComingSoon('Tentang Aplikasi segera hadir!');
                  },
                ),
                const SizedBox(height: 32),
                _buildKeluarAkunButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ── TOP BAR ───────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
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
        // Tombol settings
        GestureDetector(
          onTap: () {
            // TODO: navigasi ke halaman pengaturan
            _showComingSoon('Pengaturan segera hadir!');
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.settings_rounded,
                size: 20,
                color: Color(0xFF5F8F8A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── PAGE TITLE ────────────────────────────────────────────────────────
  Widget _buildPageTitle() {
    return Text(
      'Profil',
      style: GoogleFonts.quicksand(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  // ── KARTU ORANG TUA ───────────────────────────────────────────────────
  Widget _buildOrangTuaCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar orang tua (placeholder rekayasa)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFD4EBE9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const Icon(
                  Icons.person_rounded,
                  size: 32,
                  color: Color(0xFF5F8F8A),
                ),
            ),
          ),
          const SizedBox(width: 14),
          // Info orang tua
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Andri Pratama',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 13,
                      color: Color(0xFF888888),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Andripratama@Gmail.Com',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Badge role
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF7F6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF5F8F8A).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        size: 12,
                        color: Color(0xFF5F8F8A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Orang Tua/Wali',
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5F8F8A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── KARTU ANAK ────────────────────────────────────────────────────────
  Widget _buildAnakCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar anak (placeholder rekayasa)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const Icon(
                  Icons.face_rounded,
                  size: 32,
                  color: Color(0xFFF28B6E),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info anak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aca Azzahra',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '8 Tahun · Perempuan',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 6),
                // Badge role anak
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0EF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFF28B6E).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: Color(0xFFF28B6E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Anak',
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF28B6E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION TITLE ─────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.quicksand(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  // ── INFO ANAK ROW ─────────────────────────────────────────────────────
  Widget _buildInfoAnakRow() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoAnakItem(
            icon: Icons.bar_chart_rounded,
            iconColor: const Color(0xFF5F8F8A),
            label: 'Progress Terapi',
            value: '75 %',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInfoAnakItem(
            icon: Icons.emoji_events_rounded,
            iconColor: const Color(0xFFF5B942),
            label: 'Sesi Selesai',
            value: '12 Dari 21',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInfoAnakItem(
            icon: Icons.calendar_month_rounded,
            iconColor: const Color(0xFF5F8F8A),
            label: 'Terakhir Terapi',
            value: '10 Nov 2026',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoAnakItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  // ── MENU BUTTON ───────────────────────────────────────────────────────
  Widget _buildMenuButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFFAAAAAA),
            ),
          ],
        ),
      ),
    );
  }

  // ── KELUAR AKUN BUTTON ────────────────────────────────────────────────
  Widget _buildKeluarAkunButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => _showKeluarAkunDialog(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFCECD),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 20,
                color: Color(0xFFD94040),
              ),
              const SizedBox(width: 8),
              Text(
                'Keluar Akun',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD94040),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── DIALOG KONFIRMASI KELUAR ───────────────────────────────────────────
  void _showKeluarAkunDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keluar Akun',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin keluar dari akun ini?',
          style: GoogleFonts.quicksand(
            fontSize: 13,
            color: const Color(0xFF888888),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5F8F8A),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: lakukan proses logout (clear session, navigasi ke login)
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: Text(
              'Keluar',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD94040),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── COMING SOON SNACKBAR ───────────────────────────────────────────────
  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
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

  // ── BOTTOM NAV BAR ────────────────────────────────────────────────────
  Widget _buildBottomNavBar() {
    final items = [
      {'icon': 'assets/images/ic_home.png', 'label': 'Home'},
      {'icon': 'assets/images/ic_treatment.png', 'label': 'Treatment'},
      {'icon': 'assets/images/ic_artikel.png', 'label': 'Artikel'},
      {'icon': 'assets/images/ic_profile.png', 'label': 'Profil'},
    ];

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
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  } else if (index == 1) {
                    Navigator.pushNamed(context, '/treatment');
                  } else if (index == 2) {
                    Navigator.pushNamed(context, '/artikel');
                  }
                  // index == 3 sudah di halaman ini
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        errorBuilder: (context, error, stackTrace) => Icon(
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
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
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
