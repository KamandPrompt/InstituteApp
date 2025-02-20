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
  final String host;
  final String description;
  final List<String> images;
  final String link;

  const AddFeedItemEvent(
      {required this.host,
      required this.description,
      required this.images,
      required this.link});
}
