import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  const GetNotificationsEvent();
}

class AddNotificationEvent extends NotificationEvent {
  final String title;
  final String by;
  final String description;
  final String? image;

  const AddNotificationEvent({
    required this.title,
    required this.by,
    required this.description,
    this.image,
  });
}
