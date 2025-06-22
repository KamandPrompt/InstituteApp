import 'package:vertex/features/home/domain/entities/buy_sell_item_entity.dart';
import 'package:file_picker/file_picker.dart';

abstract class BuySellRepository {
  Future<List<BuySellItemEntity>> getBuySellItems();

  Future<BuySellItemEntity?> addOrEditBuySellItem(
      String? id,
      String name,
      String productDescription,
      FilePickerResult productImage,
      String soldBy,
      String maxPrice,
      String minPrice,
      DateTime createdAt,
      DateTime updatedAt,
      String phoneNo);

  Future<bool> deleteBuySellItem(String id);
}
