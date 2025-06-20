import '../repositories/post_repository.dart';

class DeletePostItem {
  final PostRepository repository;

  DeletePostItem(this.repository);

  Future<bool> execute(
    String id,
  ) {
    return repository.deletePostItem(id);
  }
}
