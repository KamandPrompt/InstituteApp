import 'package:uhl_link/features/home/domain/entities/feed_entity.dart';

abstract class FeedRepository {
  Future<List<FeedItemEntity>> getFeedItems();
  Future<FeedItemEntity?> addFeedItem(
      String host, String description, List<String> images, String link);
}
