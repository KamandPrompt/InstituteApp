import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository})
      : super(NotificationsInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<AddNotificationEvent>(_onAddNotification);
  }

  Future<void> _onGetNotifications(GetNotificationsEvent event,
      Emitter<NotificationState> emit) async {
    emit(NotificationsLoading());
    try {
      final notifications = await notificationRepository.getNotifications();
      print("Fetched Notifications: \$notifications"); // ✅ Debugging
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      print("Error Fetching Notifications: \$e"); // ✅ Debugging
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onAddNotification(
      AddNotificationEvent event,
      Emitter<NotificationState> emit
      ) async {
    try {
      print("Adding Notification: ${event.title}, ${event.by}, ${event.description}, ${event.image}");

      // Create notification with Map fields
      final notification = NotificationEntity(
        id: "", // MongoDB will generate this
        title: event.title,
        by: event.by,
        description: event.description,
        image: event.image,
      );

      await notificationRepository.addNotification(notification);
      print("Fetching updated notifications...");

      final notifications = await notificationRepository.getNotifications();
      emit(NotificationsLoaded(notifications));

    } catch (e, stackTrace) {
      print("Error adding notification: $e");
      print(stackTrace);
      emit(NotificationsError("Error adding notification: $e"));
    }
  }
}

