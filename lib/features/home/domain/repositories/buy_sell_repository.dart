import 'package:uhl_link/features/home/domain/entities/buy_sell_item_entity.dart';

abstract class BuySellRepository {
  Future<List<BuySellItemEntity>> getBuySellItems();

  Future<BuySellItemEntity?> addBuySellItem(
      String productName,
      String productDescription,
      List<String> productImage,
      String soldBy,
      int maxPrice, 
      int minPrice, 
      DateTime addDate,
      String phoneNo);
}
