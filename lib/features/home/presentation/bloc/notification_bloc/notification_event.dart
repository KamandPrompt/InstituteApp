import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  const GetNotificationsEvent();
}

class AddNotificationEvent extends NotificationEvent { // ✅ Ensure this class exists
  final Map<String, dynamic> title;
  final Map<String, dynamic> by;
  final Map<String, dynamic> description;
  final Map<String, dynamic>? image;

  const AddNotificationEvent({
    required this.title,
    required this.by,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [title, by, description, image];
}
