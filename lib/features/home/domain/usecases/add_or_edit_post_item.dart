import 'package:file_picker/file_picker.dart';

import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class AddOrEditPostItem {
  final PostRepository repository;

  AddOrEditPostItem(this.repository);

  Future<PostItemEntity?> execute(
      String? id,
      String title,
      String description,
      FilePickerResult images,
      String link,
      String host,
      String type,
      String emailId,
      DateTime createdAt,
      DateTime updatedAt) {
    return repository.addOrEditPostItem(id, title, description, images, link,
        host, type, emailId, createdAt, updatedAt);
  }
}
