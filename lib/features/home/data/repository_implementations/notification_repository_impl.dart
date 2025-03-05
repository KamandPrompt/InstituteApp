import 'package:uhl_link/features/home/data/data_sources/notification_data_sources.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/domain/repositories/notification_repository.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
