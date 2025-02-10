import 'package:uhl_link/features/home/domain/entities/lost_found_item_entity.dart';

abstract class LostFoundRepository {
  Future<List<LostFoundItemEntity>> getLostFoundItems();
  Future<LostFoundItemEntity?> addLostFoundItem(
      String from,
      String lostOrFound,
      String name,
      String description,
      List<String> images,
      DateTime date,
      String phoneNo);
}
