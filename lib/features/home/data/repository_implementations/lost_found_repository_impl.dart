import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/data/data_sources/lost_found_data_sources.dart';
import 'package:vertex/features/home/domain/entities/lost_found_item_entity.dart';
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
            createdAt: items[i].createdAt,
            updatedAt: items[i].updatedAt,
            phoneNo: items[i].phoneNo));
      }
      return allItems;
    } else {
      return allItems;
    }
  }

  @override
  Future<LostFoundItemEntity?> addOrEditLostFoundItem(
      String? id,
      String from,
      String lostOrFound,
      String name,
      String description,
      FilePickerResult images,
      DateTime createdAt,
      DateTime updatedAt,
      String phoneNo) async {
    final item = await lostFoundDatabase.addOrEditLostFoundItem(id, from,
        lostOrFound, name, description, images, createdAt, updatedAt, phoneNo);
    if (item != null) {
      return LostFoundItemEntity(
          id: item.id,
          from: item.from,
          lostOrFound: item.lostOrFound,
          name: item.name,
          description: item.description,
          images: item.images,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
          phoneNo: item.phoneNo);
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteLostFoundItem(String id) async {
    final result = await lostFoundDatabase.deleteLostFoundItem(id);
    return result;
  }
}
