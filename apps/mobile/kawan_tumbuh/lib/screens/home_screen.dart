import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/notification_model.dart';
import '../helpers/notification_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Indeks tab aktif untuk layar ini. Tab lain dibuka dengan push di atas
  // Home, jadi nilainya tetap 0 — tab Home selalu menyala di layar ini.
  final int _selectedIndex = 0;

  // Data notifikasi — di-load ulang setiap kali kembali dari halaman notifikasi.
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = NotificationData.getSampleNotifications();
  }

  /// Hitung jumlah notifikasi yang belum dibaca untuk badge.
  int get _unreadCount => NotificationData.getUnreadCount(_notifications);

  /// Navigasi ke halaman notifikasi lalu refresh unread count saat kembali.
  void _openNotifications() async {
    await Navigator.pushNamed(context, '/notifikasi');
    // Setelah kembali, reload notifikasi agar badge diperbarui.
    if (mounted) {
      setState(() {
        _notifications = NotificationData.getSampleNotifications();
      });
    }
  }

  final List<Map<String, dynamic>> _therapyCards = [
    {
      'title': 'Diskalkulia',
      'subtitle': 'Treatment',
      'sessions': '7 Sesi',
      'image': 'assets/images/therapy_dyscalculia.png',
      'bgColor': const Color(0xFFF28B6E),
      'route': '/treatment-diskalkulia',
    },
    {
      'title': 'Disleksia',
      'subtitle': 'Treatment',
      'sessions': '7 Sesi',
      'image': 'assets/images/therapy_dyslexia.png',
      'bgColor': const Color(0xFF5F8F8A),
      'route': '/treatment',
    },
    // Disgrafia: belum ada screen treatment — sengaja tanpa 'route'
    // sehingga kartunya belum bisa diklik.
    {
      'title': 'Disgrafia',
      'subtitle': 'Treatment',
      'sessions': '7 Sesi',
      'image': 'assets/images/therapy_dysgraphia.png',
      'bgColor': const Color(0xFFF5E6C8),
    },
  ];

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
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildHeroBanner(),
                const SizedBox(height: 24),
                _buildSectionTitle('Rekomendasi Terapi', null),
                const SizedBox(height: 12),
                _buildTherapyCards(),
                const SizedBox(height: 24),
                _buildSectionTitle('Artikel Terbaru', 'Lihat Semua'),
                const SizedBox(height: 12),
                _buildArtikelBanner(),
                const SizedBox(height: 24),
                _buildSectionTitle('Aktivitas Terakhir', null),
                const SizedBox(height: 12),
                _buildAktivitasCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildChatbotFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, Mellisa!',
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Yuk, Temani Tumbuh Kembang Anak',
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF888888),
              ),
            ),
          ],
        ),
        // ── Icon Notifikasi dengan Badge ──────────────────────────
        GestureDetector(
          onTap: _openNotifications,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
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
                child: Center(
                  child: Image.asset(
                    'assets/images/ic_notification.png',
                    width: 22,
                    height: 22,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.notifications_outlined,
                      size: 22,
                      color: Color(0xFF5F8F8A),
                    ),
                  ),
                ),
              ),
              // Badge merah jumlah notifikasi belum dibaca
              if (_unreadCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _unreadCount > 9 ? '9+' : '$_unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ── HERO BANNER ───────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/banner_hero.png',
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A6FA5), Color(0xFF2D4E8A)],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/hasil-assessment'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Hasil Skrining',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── SECTION TITLE ─────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/artikel'),
            child: Text(
              actionText,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5F8F8A),
              ),
            ),
          ),
      ],
    );
  }

  // ── THERAPY CARDS ─────────────────────────────────────────────────────
  Widget _buildTherapyCards() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _therapyCards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = _therapyCards[index];
          final bool isDark =
              (card['bgColor'] as Color).computeLuminance() < 0.5;
          return _buildTherapyCard(card, isDark);
        },
      ),
    );
  }

  Widget _buildTherapyCard(Map<String, dynamic> card, bool isDark) {
    final String? route = card['route'] as String?;
    return GestureDetector(
      // Kartu tanpa route (Disgrafia) sengaja tidak bisa diklik
      // sampai screen treatment disgrafia tersedia.
      onTap: route == null ? null : () => Navigator.pushNamed(context, route),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: card['bgColor'] as Color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Image.asset(
                  card['image'] as String,
                  height: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['title'] as String,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    card['subtitle'] as String,
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.8)
                          : const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card['sessions'] as String,
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.9)
                          : const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── ARTIKEL BANNER ────────────────────────────────────────────────────
  Widget _buildArtikelBanner() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/artikel'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          'assets/images/artikel_banner_sld.png',
          width: double.infinity,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFFFFB347),
            ),
            child: Center(
              child: Text(
                'APA ITU SLD?\nMENGENAL DISLEKSIA, DISGRAFIA,\nDAN DISKALKULIA!',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── AKTIVITAS TERAKHIR ────────────────────────────────────────────────
  Widget _buildAktivitasCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/treatment-diskalkulia'),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/activity_dyscalculia.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF28B6E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calculate_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terapi Diskalkulia',
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Lihat Terapi',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── CHATBOT FAB ───────────────────────────────────────────────────────
  Widget _buildChatbotFAB() {
    return GestureDetector(
      onTap: () {
        // TODO: navigasi ke halaman chatbot
        _showComingSoonSnackBar('Chatbot segera hadir!');
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
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.chat_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  // ── COMING SOON SNACKBAR ───────────────────────────────────────────────
  void _showComingSoonSnackBar(String message) {
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
                  // _selectedIndex sengaja tidak diubah — layar lain
                  // dibuka di atas Home, dan tab Home tetap menyala
                  // saat kembali (lihat komentar pada deklarasi field).
                  if (index == 1) {
                    Navigator.pushNamed(context, '/treatment');
                  } else if (index == 2) {
                    Navigator.pushNamed(context, '/artikel');
                  } else if (index == 3) {
                    Navigator.pushNamed(context, '/profil');
                  }
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
