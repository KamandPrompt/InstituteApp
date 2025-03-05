import '../entities/notifications_entity.dart';
import '../repositories/notification_repository.dart';

class AddNotification {
  final NotificationRepository repository;

  AddNotification(this.repository);

  Future<NotificationEntity?> execute(String title, String by, String description, String? image) {
    return repository.addNotification(title, by, description, image);
  }
}
