import 'package:vertex/features/home/data/data_sources/buy_sell_data_sources.dart';
import 'package:vertex/features/home/domain/entities/buy_sell_item_entity.dart';
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
          name: items[i].name,
          productDescription: items[i].productDescription,
          productImage: items[i].productImage,
          soldBy: items[i].soldBy,
          maxPrice: items[i].maxPrice,
          minPrice: items[i].minPrice,
          createdAt: items[i].createdAt,
          updatedAt: items[i].updatedAt,
          phoneNo: items[i].phoneNo,
        ));
      }
      return allItems;
    } else {
      return allItems;
    }
  }

  @override
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
    String phoneNo,
  ) async {
    final item = await buySellDatabase.addOrEditItem(
      id,
      name,
      productDescription,
      productImage,
      soldBy,
      maxPrice,
      minPrice,
      createdAt,
      updatedAt,
      phoneNo,
    );
    if (item != null) {
      return BuySellItemEntity(
        id: item.id,
        name: item.name,
        productDescription: item.productDescription,
        productImage: item.productImage,
        soldBy: item.soldBy,
        maxPrice: item.maxPrice,
        minPrice: item.minPrice,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        phoneNo: item.phoneNo,
      );
    } else {
      return null;
    }
  }

    @override
  Future<bool> deleteBuySellItem(String id) async {
    return await buySellDatabase.deleteBuySellItem(id);
  }
}
