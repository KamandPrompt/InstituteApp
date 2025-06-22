import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/domain/entities/lost_found_item_entity.dart';

abstract class LostFoundRepository {
  Future<List<LostFoundItemEntity>> getLostFoundItems();
  Future<LostFoundItemEntity?> addOrEditLostFoundItem(
      String? id,
      String from,
      String lostOrFound,
      String name,
      String description,
      FilePickerResult images,
      DateTime createdAt,
      DateTime updatedAt,
      String phoneNo);
  Future<bool> deleteLostFoundItem(String id);
}
