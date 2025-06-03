import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:vertex/features/home/data/models/buy_sell_item_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vertex/utils/cloudinary_services.dart';

class BuySellDB {
  static Db? db;
  static DbCollection? collection;

  BuySellDB();

  // Connect to MongoDB
  static Future<void> connect(String connectionURL) async {
    db = await Db.create(connectionURL);
    await db?.open();
    inspect(db);
    collection = db?.collection('Buy Sell');
  }

  // Get All Buy & Sell Items
  Future<List<BuySellItem>> getBuySellItems() async {
    try {
      final items = await collection?.find().toList();
      if (items != null) {
        return items.map((item) => BuySellItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Error fetching buy & sell items: ${e.toString()}");
      return [];
    }
  }

  Future<BuySellItem?> postItem(
    String productName,
    String productDescription,
    FilePickerResult productImage,
    String soldBy,
    String maxPrice,
    String minPrice,
    DateTime addDate,
    String phoneNo,
  ) async {
    try {
      List<String> imagesList = await uploadImagesToBNS(productImage);

      final itemValues = {
        '_id': ObjectId(),
        'productName': productName,
        'productDescription': productDescription,
        'productImage': imagesList,
        'soldBy': soldBy,
        'maxPrice': maxPrice,
        'minPrice': minPrice,
        'addDate': addDate,
        'phoneNo': phoneNo,
      };
      final result = await collection?.insertOne(itemValues);
      if (result != null && result.document != null) {
        return BuySellItem.fromJson(result.document!);
      } else {
        return null;
      }
    } catch (e) {
      log("Error posting item: ${e.toString()}");
      return null;
    }
  }

  // Close Database Connection
  Future<void> close() async {
    await db?.close();
  }
}
