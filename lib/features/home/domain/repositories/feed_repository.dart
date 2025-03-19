import 'package:file_picker/file_picker.dart';
import 'package:uhl_link/features/home/domain/entities/feed_entity.dart';

abstract class FeedRepository {
  Future<List<FeedItemEntity>> getFeedItems();
  Future<FeedItemEntity?> addFeedItem(String title, String description,
      FilePickerResult images, String link, String host);
}
