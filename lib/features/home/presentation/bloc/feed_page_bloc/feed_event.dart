part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

//GetFeedItemsEvent
class GetFeedItemsEvent extends FeedEvent {
  const GetFeedItemsEvent();
}

class AddFeedItemEvent extends FeedEvent {
  final String title;
  final String description;
  final FilePickerResult images;
  final String link;
  final String host;

  const AddFeedItemEvent(
      {required this.title,
      required this.description,
      required this.images,
      required this.link,
      required this.host
      });
}