import 'package:equatable/equatable.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationState {}

class NotificationsLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationsLoaded({required this.notifications});
}

class NotificationsError extends NotificationState {
  final String message;

  const NotificationsError({required this.message});
}

class NotificationAdding extends NotificationState {}

class NotificationAdded extends NotificationState {
  final NotificationEntity notification;

  const NotificationAdded({required this.notification});
}

class NotificationAddingError extends NotificationState {
  final String message;

  const NotificationAddingError({required this.message});
}