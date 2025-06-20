import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostItemEntity>> getPostItems();
  Future<PostItemEntity?> addOrEditPostItem(
      String? id,
      String title,
      String description,
      FilePickerResult images,
      String link,
      String host,
      String type,
      String emailId,
      DateTime createdAt,
      DateTime updatedAt);
  Future<bool> deletePostItem(String id);
}
