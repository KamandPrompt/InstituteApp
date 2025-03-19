import 'package:file_picker/file_picker.dart';

import '../entities/feed_entity.dart';
import '../repositories/feed_repository.dart';

class AddFeedItem {
  final FeedRepository repository;

  AddFeedItem(this.repository);

  Future<FeedItemEntity?> execute(
      String title,
      String description,
      FilePickerResult images,
      String link,
      String host) {
    return repository.addFeedItem(
        title, description, images, link, host);
  }
}