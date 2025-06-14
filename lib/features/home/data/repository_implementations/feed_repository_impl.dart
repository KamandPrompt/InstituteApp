import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/data/data_sources/feed_portal_data_sources.dart';
import 'package:vertex/features/home/domain/entities/feed_entity.dart';
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
            title: items[i].title,
            description: items[i].description,
            images: items[i].images,
            link: items[i].link,
            host: items[i].host,
            type: items[i].type,
            emailId: items[i].emailId));
      }
      return allItems;
    } else {
      return allItems;
    }
  }

  @override
  Future<FeedItemEntity?> addFeedItem(
      String host,
      String description,
      FilePickerResult images,
      String link,
      String organiser,
      String type,
      String emailId) async {
    final item = await feedDatabase.addFeeditem(
        host, description, images, link, organiser, type, emailId);
    if (item != null) {
      return FeedItemEntity(
          id: item.id,
          title: item.title,
          description: item.description,
          images: item.images,
          link: item.link,
          host: item.host,
          type: item.type,
          emailId: item.emailId);
    } else {
      return null;
    }
  }
}
