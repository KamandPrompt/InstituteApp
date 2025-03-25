import 'package:uhl_link/features/home/data/data_sources/buy_sell_data_sources.dart';
import 'package:uhl_link/features/home/domain/entities/buy_sell_item_entity.dart';
import '../../domain/repositories/buy_sell_repository.dart';
import 'package:file_picker/file_picker.dart';

class BuySellRepositoryImpl implements BuySellRepository {
  final BuySellDB buySellDatabase;
  BuySellRepositoryImpl(this.buySellDatabase);

  @override
  Future<List<BuySellItemEntity>> getBuySellItems() async {
    List<BuySellItemEntity> allItems = [];
    final items = await buySellDatabase.getBuySellItems();
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        allItems.add(BuySellItemEntity(
            id: items[i].id,
            productName: items[i].productName,
            productDescription: items[i].productDescription,
            productImage: items[i].productImage,
            soldBy: items[i].soldBy,
            maxPrice: items[i].maxPrice,
            minPrice: items[i].minPrice,
            addDate: items[i].addDate,
            phoneNo: items[i].phoneNo,
        ));
      }
      return allItems;
    } else {
      return allItems;
    }
  }

  @override
  Future<BuySellItemEntity?> addBuySellItem(
      String productName,
      String productDescription,
      FilePickerResult productImage,
      String soldBy,
      String maxPrice, // ✅ Add maxPrice parameter
      String minPrice,
      DateTime addDate,
      String phoneNo,
       
  ) async {
    final item = await buySellDatabase.postItem(
         productName,
        productDescription,
       productImage,
        soldBy,
       maxPrice, // ✅ Pass maxPrice to database
         minPrice,
        addDate,
         phoneNo,
          
    );
    if (item != null) {
      return BuySellItemEntity(
          id: item.id,
          productName: item.productName,
          productDescription: item.productDescription,
          productImage: item.productImage,
          soldBy: item.soldBy,
          maxPrice: item.maxPrice, // ✅ Add maxPrice
          minPrice: item.minPrice,
          addDate: item.addDate,
          phoneNo: item.phoneNo,
           
      );
    } else {
      return null;
    }
  }
}
