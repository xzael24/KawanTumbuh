import '../models/notification_model.dart';

/// Helper yang menyediakan data dummy notifikasi.
/// Nantinya bisa diganti dengan pemanggilan API.
class NotificationData {
  NotificationData._();

  static List<NotificationModel> getSampleNotifications() {
    return [
      NotificationModel(
        id: 'notif_1',
        title: 'Terapi Disgrafia Aca\nSesi 4',
        time: '10:23',
        type: NotificationType.terapi,
        imagePath: 'assets/images/therapy_dysgraphia.png',
        route: '/treatment',
      ),
      NotificationModel(
        id: 'notif_2',
        title: 'Terapi Disleksia Aca\nSesi 7',
        time: '10:11',
        type: NotificationType.terapi,
        imagePath: 'assets/images/therapy_dyslexia.png',
        route: '/treatment',
      ),
      NotificationModel(
        id: 'notif_3',
        title: 'Artikel Terbaru\nDiskalkulia',
        time: '18:19',
        type: NotificationType.artikel,
        imagePath: 'assets/images/artikel_dyscalculia.png',
        route: '/artikel',
      ),
    ];
  }

  /// Jumlah notifikasi yang belum dibaca.
  static int getUnreadCount(List<NotificationModel> notifications) {
    return notifications.where((n) => !n.isRead).length;
  }
}
