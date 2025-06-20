import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/data/data_sources/post_portal_data_sources.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDB postDatabase;
  PostRepositoryImpl(this.postDatabase);

  @override
  Future<List<PostItemEntity>> getPostItems() async {
    List<PostItemEntity> allItems = [];
    final items = await postDatabase.getPostItems();
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        allItems.add(PostItemEntity(
          id: items[i].id,
          title: items[i].title,
          description: items[i].description,
          images: items[i].images,
          link: items[i].link,
          host: items[i].host,
          type: items[i].type,
          emailId: items[i].emailId,
          createdAt: items[i].createdAt,
          updatedAt: items[i].updatedAt,
        ));
      }
      return allItems;
    } else {
      return allItems;
    }
  }

  @override
  Future<PostItemEntity?> addOrEditPostItem(
      String? id,
      String host,
      String description,
      FilePickerResult images,
      String link,
      String organiser,
      String type,
      String emailId,
      DateTime createdAt,
      DateTime updatedAt) async {
    final item = await postDatabase.addOrEditPostitem(id, host, description,
        images, link, organiser, type, emailId, createdAt, updatedAt);
    if (item != null) {
      return PostItemEntity(
          id: item.id,
          title: item.title,
          description: item.description,
          images: item.images,
          link: item.link,
          host: item.host,
          type: item.type,
          emailId: item.emailId,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt);
    } else {
      return null;
    }
  }

  @override
  Future<bool> deletePostItem(String id) async {
    return await postDatabase.deletePostItem(id);
  }
}
