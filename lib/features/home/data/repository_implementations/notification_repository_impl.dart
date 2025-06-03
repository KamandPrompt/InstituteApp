import 'package:vertex/features/home/data/data_sources/notification_data_sources.dart';
import 'package:vertex/features/home/domain/entities/notifications_entity.dart';
import 'package:vertex/features/home/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsDB notificationsDB;
  NotificationRepositoryImpl(this.notificationsDB);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    List<NotificationEntity> allNotifications = [];
    final notifications = await notificationsDB.getNotifications();
    if (notifications.isNotEmpty) {
      for (int i = 0; i < notifications.length; i++) {
        allNotifications.add(NotificationEntity(
            id: notifications[i].id,
            title: notifications[i].title,
            by: notifications[i].by,
            description: notifications[i].description,
            image: notifications[i].image));
      }
      return allNotifications;
    } else {
      return allNotifications;
    }
  }

  @override
  Future<NotificationEntity?> addNotification(
      String title, String by, String description, String? image) async {
    final notification =
        await notificationsDB.addNotifications(title, by, description, image);
    if (notification != null) {
      return NotificationEntity(
          id: notification.id,
          title: notification.title,
          by: notification.by,
          description: notification.description);
    } else {
      return null;
    }
  }
}
