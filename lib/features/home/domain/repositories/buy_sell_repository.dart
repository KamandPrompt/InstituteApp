import 'package:vertex/features/home/domain/entities/buy_sell_item_entity.dart';
import 'package:file_picker/file_picker.dart';

abstract class BuySellRepository {
  Future<List<BuySellItemEntity>> getBuySellItems();

  Future<BuySellItemEntity?> addBuySellItem(
      String productName,
      String productDescription,
      FilePickerResult productImage,
      String soldBy,
      String maxPrice,
      String minPrice,
      DateTime addDate,
      String phoneNo);
}
