import 'package:uhl_link/features/home/data/data_sources/feed_portal_data_sources.dart';
import 'package:uhl_link/features/home/domain/entities/feed_entity.dart';
import '../../domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedDB feedDatabase;
  FeedRepositoryImpl(this.feedDatabase);

  @override
  Future<List<FeedItemEntity>> getFeedItems() async {
    List<FeedItemEntity> allItems = [];
    final items = await feedDatabase.getFeedItems();
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        allItems.add(FeedItemEntity(
            id: items[i].id,
            host: items[i].host,
            description: items[i].description,
            images: items[i].images,
            link: items[i].link,
            organiser: items[i].organiser));
      }
      return allItems;
    } else {
      return allItems;
    }
  }

  @override
  Future<FeedItemEntity?> addFeedItem(
      String host, String description, List<String> images, String link,String organiser) async {
    final item =
        await feedDatabase.addFeeditem(host, description, images, link,organiser);
    if (item != null) {
      return FeedItemEntity(
          id: item.id,
          host: item.host,
          description: item.description,
          images: item.images,
          link: item.link,
          organiser: item.organiser);
    } else {
      return null;
    }
  }
}