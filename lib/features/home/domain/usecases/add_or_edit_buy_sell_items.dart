import '../entities/buy_sell_item_entity.dart';
import '../repositories/buy_sell_repository.dart';
import 'package:file_picker/file_picker.dart';

class AddOrEditBuySellItem {
  final BuySellRepository repository;

  AddOrEditBuySellItem(this.repository);

  Future<BuySellItemEntity?> execute(
      String? id,
      String productName,
      String productDescription,
      FilePickerResult productImage,
      String soldBy,
      String maxPrice,
      String minPrice,
      DateTime createdAt,
      DateTime updatedAt,
      String phoneNo) {
    return repository.addOrEditBuySellItem(id, productName, productDescription,
        productImage, soldBy, maxPrice, minPrice, createdAt, updatedAt, phoneNo);
  }
}
