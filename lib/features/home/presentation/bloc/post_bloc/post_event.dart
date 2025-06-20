part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

//GetPostItemsEvent
class GetPostItemsEvent extends PostEvent {
  const GetPostItemsEvent();
}

class AddorEditPostItemEvent extends PostEvent {
  final String? id;
  final String title;
  final String description;
  final FilePickerResult images;
  final String link;
  final String host;
  final String type;
  final String emailId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddorEditPostItemEvent(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.link,
      required this.host,
      required this.type,
      required this.emailId,
      required this.createdAt,
      required this.updatedAt});
}

class DeletePostItemEvent extends PostEvent {
  final String id;

  const DeletePostItemEvent({required this.id});
}
