import '../entities/feed_entity.dart';
import '../repositories/feed_repository.dart';

class GetFeedItem {
  final FeedRepository repository;

  GetFeedItem(this.repository);

  Future<List<FeedItemEntity>> execute() {
    return repository.getFeedItems();
  }
}