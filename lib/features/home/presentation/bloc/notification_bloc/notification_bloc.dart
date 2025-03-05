import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/domain/repositories/notification_repository.dart';
import '../../../domain/usecases/add_notification.dart';
import '../../../domain/usecases/get_notification.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  final AddNotification addNotification;

  NotificationBloc(
      {required this.getNotifications, required this.addNotification})
      : super(NotificationsInitial()) {
    on<GetNotificationsEvent>(onGetNotifications);
    on<AddNotificationEvent>(onAddNotification);
  }

  void onGetNotifications(
      GetNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationsLoading());
    try {
      final notifications = await getNotifications.execute();
      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  void onAddNotification(
      AddNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationAdding());
    try {
      final notification = await addNotification.execute(
          event.title, event.by, event.description, event.image);
      if (notification != null) {
        emit(NotificationAdded(notification: notification));
      } else {
        emit(NotificationAddingError(message: "Error adding notification."));
      }
    } catch (e) {
      emit(NotificationAddingError(message: "Error adding notification: $e"));
    }
  }
}
