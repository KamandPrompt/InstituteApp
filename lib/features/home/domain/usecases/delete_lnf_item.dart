import 'package:vertex/features/home/domain/repositories/lost_found_repository.dart';

class DeleteLnFItem {
  final LostFoundRepository repository;

  DeleteLnFItem(this.repository);

  Future<bool> execute(
    String id,
  ) {
    return repository.deleteLostFoundItem(id);
  }
}
