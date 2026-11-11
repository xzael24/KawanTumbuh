/// Tipe notifikasi yang didukung aplikasi KawanTumbuh.
enum NotificationType { terapi, artikel }

/// Model satu entri notifikasi.
class NotificationModel {
  final String id;
  final String title;
  final String time; // format HH:mm
  final NotificationType type;
  final String? imagePath; // path asset gambar (opsional)
  final String? route; // route tujuan saat "Lihat" ditekan
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.time,
    required this.type,
    this.imagePath,
    this.route,
    this.isRead = false,
  });
}
