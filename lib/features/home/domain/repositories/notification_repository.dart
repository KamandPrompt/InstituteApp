import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<NotificationEntity?> addNotification(
      String title, String by, String description, String? image);
}
