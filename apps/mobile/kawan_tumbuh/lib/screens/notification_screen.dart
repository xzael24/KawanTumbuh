import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/notification_model.dart';
import '../helpers/notification_data.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = NotificationData.getSampleNotifications();
  }

  void _markAsRead(NotificationModel notif) {
    setState(() => notif.isRead = true);
  }

  void _dismiss(NotificationModel notif) {
    setState(() {
      notif.isRead = true;
      _notifications.remove(notif);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      itemCount: _notifications.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildNotifCard(_notifications[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol kembali
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: Color(0xFF555555)),
                const SizedBox(width: 4),
                Text(
                  'Kembali',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Notifikasi Terbaru',
            style: GoogleFonts.quicksand(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── KARTU NOTIFIKASI ────────────────────────────────────────────────
  Widget _buildNotifCard(NotificationModel notif) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar / avatar notifikasi
            _buildNotifImage(notif),
            const SizedBox(width: 12),
            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Expanded(
                        child: Text(
                          notif.title,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Waktu
                      Text(
                        notif.time,
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Tombol aksi
                  Row(
                    children: [
                      // Tombol Lihat
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _markAsRead(notif);
                            if (notif.route != null) {
                              Navigator.pushNamed(context, notif.route!);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5F8F8A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Lihat',
                                style: GoogleFonts.quicksand(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tombol Abaikan
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _dismiss(notif),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Abaikan',
                                style: GoogleFonts.quicksand(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF888888),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── GAMBAR NOTIFIKASI ───────────────────────────────────────────────
  Widget _buildNotifImage(NotificationModel notif) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 54,
        height: 54,
        color: const Color(0xFFF0EDE8),
        child: notif.imagePath != null
            ? Image.asset(
                notif.imagePath!,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => _fallbackIcon(notif.type),
              )
            : _fallbackIcon(notif.type),
      ),
    );
  }

  Widget _fallbackIcon(NotificationType type) {
    return Center(
      child: Icon(
        type == NotificationType.terapi
            ? Icons.medical_services_rounded
            : Icons.article_rounded,
        color: const Color(0xFF5F8F8A),
        size: 28,
      ),
    );
  }

  // ── EMPTY STATE ─────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Belum ada notifikasi',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
