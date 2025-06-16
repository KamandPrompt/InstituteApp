import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/domain/entities/feed_entity.dart';

abstract class FeedRepository {
  Future<List<FeedItemEntity>> getFeedItems();
  Future<FeedItemEntity?> addFeedItem(
      String title,
      String description,
      FilePickerResult images,
      String link,
      String host,
      String type,
      String emailId,
      DateTime createdAt);
}
