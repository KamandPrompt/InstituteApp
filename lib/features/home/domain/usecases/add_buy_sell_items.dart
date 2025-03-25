import '../entities/buy_sell_item_entity.dart';
import '../repositories/buy_sell_repository.dart';
import 'package:file_picker/file_picker.dart';

class AddBuySellItem {
  final BuySellRepository repository;

  AddBuySellItem(this.repository);

  Future<BuySellItemEntity?> execute(
      String productName,
      String productDescription,
      FilePickerResult productImage,
      String soldBy,
      String maxPrice, 
      String minPrice, 
      DateTime addDate,
      String phoneNo) {
    return repository.addBuySellItem(
        productName, productDescription, productImage, soldBy, maxPrice, minPrice, addDate, phoneNo);
  }
}
