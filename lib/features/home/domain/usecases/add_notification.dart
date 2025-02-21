import '../entities/notifications_entity.dart';
import '../repositories/notification_repository.dart';

class AddNotification {
  final NotificationRepository repository;

  AddNotification(this.repository);

  Future<void> execute(NotificationEntity notification) {
    return repository.addNotification(notification);
  }
}
