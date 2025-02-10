import 'package:uhl_link/features/home/data/data_sources/lost_found_data_sources.dart';
import 'package:uhl_link/features/home/domain/entities/lost_found_item_entity.dart';
import '../../domain/repositories/lost_found_repository.dart';

class LostFoundRepositoryImpl implements LostFoundRepository {
  final LostFoundDB lostFoundDatabase;
  LostFoundRepositoryImpl(this.lostFoundDatabase);

  @override
  Future<List<LostFoundItemEntity>> getLostFoundItems() async {
    List<LostFoundItemEntity> allItems = [];
    final items = await lostFoundDatabase.getLostFoundItems();
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        allItems.add(LostFoundItemEntity(
            id: items[i].id,
            from: items[i].from,
            lostOrFound: items[i].lostOrFound,
            name: items[i].name,
            description: items[i].description,
            images: items[i].images,
            date: items[i].date,
            phoneNo: items[i].phoneNo));
      }
      return allItems;
    } else {
      return allItems;
    }
  }

  @override
  Future<LostFoundItemEntity?> addLostFoundItem(String from, String lostOrFound, String name, String description, List<String> images, DateTime date, String phoneNo) async {
    final item = await lostFoundDatabase.addLostFoundItem(from, lostOrFound, name, description, images, date, phoneNo);
    if (item != null) {
      return LostFoundItemEntity(
        id: item.id,
        from: item.from,
        lostOrFound: item.lostOrFound,
        name: item.name,
        description: item.description,
        images: item.images,
        date: item.date,
        phoneNo: item.phoneNo
      );
    } else {
      return null;
    }
  }
}
