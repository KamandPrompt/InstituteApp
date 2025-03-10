import '../entities/buy_sell_item_entity.dart';
import '../repositories/buy_sell_repository.dart';

class AddBuySellItem {
  final BuySellRepository repository;

  AddBuySellItem(this.repository);

  Future<BuySellItemEntity?> execute(
      String productName,
      String productDescription,
      List<String> productImage,
      String soldBy,
      int maxPrice, 
      int minPrice, 
      DateTime addDate,
      String phoneNo) {
    return repository.addBuySellItem(
        productName, productDescription, productImage, soldBy, maxPrice, minPrice, addDate, phoneNo);
  }
}
