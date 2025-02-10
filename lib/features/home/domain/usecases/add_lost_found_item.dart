import '../entities/lost_found_item_entity.dart';
import '../repositories/lost_found_repository.dart';

class AddLostFoundItem {
  final LostFoundRepository repository;

  AddLostFoundItem(this.repository);

  Future<LostFoundItemEntity?> execute(
      String from,
      String lostOrFound,
      String name,
      String description,
      List<String> images,
      DateTime date,
      String phoneNo) {
    return repository.addLostFoundItem(
        from, lostOrFound, name, description, images, date, phoneNo);
  }
}
