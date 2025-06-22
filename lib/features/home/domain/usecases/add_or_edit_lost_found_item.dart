import 'package:file_picker/file_picker.dart';

import '../entities/lost_found_item_entity.dart';
import '../repositories/lost_found_repository.dart';

class AddOrEditLostFoundItem {
  final LostFoundRepository repository;

  AddOrEditLostFoundItem(this.repository);

  Future<LostFoundItemEntity?> execute(
      String? id,
      String from,
      String lostOrFound,
      String name,
      String description,
      FilePickerResult images,
      DateTime createdAt,
      DateTime updatedAt,
      String phoneNo) {
    return repository.addOrEditLostFoundItem(id, from, lostOrFound, name,
        description, images, createdAt, updatedAt, phoneNo);
  }
}
