import '../entities/feed_entity.dart';
import '../repositories/feed_repository.dart';

class AddFeedItem {
  final FeedRepository repository;

  AddFeedItem(this.repository);

  Future<FeedItemEntity?> execute(
      String host,
      String description,
      List<String> images,
      String link,
      String organiser) {
    return repository.addFeedItem(
        host, description, images,link,organiser);
  }
}