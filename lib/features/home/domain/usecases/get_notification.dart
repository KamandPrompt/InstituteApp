import '../entities/notifications_entity.dart';
import '../repositories/notification_repository.dart';

class GetLostFoundItems {
  final NotificationRepository repository;

  GetLostFoundItems(this.repository);

  Future<List<NotificationEntity>> execute() {
    return repository.getNotifications();
  }
}