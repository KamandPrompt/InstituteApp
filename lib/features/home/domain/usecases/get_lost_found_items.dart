import '../entities/lost_found_item_entity.dart';
import '../repositories/lost_found_repository.dart';

class GetLostFoundItems {
  final LostFoundRepository repository;

  GetLostFoundItems(this.repository);

  Future<List<LostFoundItemEntity>> execute() {
    return repository.getLostFoundItems();
  }
}
