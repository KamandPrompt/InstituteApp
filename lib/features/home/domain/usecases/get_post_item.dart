import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostItem {
  final PostRepository repository;

  GetPostItem(this.repository);

  Future<List<PostItemEntity>> execute() {
    return repository.getPostItems();
  }
}
