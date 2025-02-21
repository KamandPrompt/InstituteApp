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
  const NotificationsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationState {
  final String message;
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
