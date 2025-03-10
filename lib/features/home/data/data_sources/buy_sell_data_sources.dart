import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uhl_link/features/home/data/models/buy_sell_item_model.dart';

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

  // Post a Buy or Sell Item
  Future<BuySellItem?> postItem({
    required String productName,
    required String productDescription,
    required List<String> productImage,
    required String soldBy, 
    required int maxPrice,  // ✅ Added maxPrice
    required int minPrice,  // ✅ Added minPrice// User ID who is selling the item
    required DateTime addDate,
    required String phoneNo, // WhatsApp number
   
  }) async {
    final itemValues = {
      '_id': ObjectId(),
      'productName': productName,
      'productDescription': productDescription,
      'productImage': productImage,
      'soldBy': soldBy,
      'maxPrice': maxPrice, // ✅ Included maxPrice
      'minPrice': minPrice, // ✅ Included minPrice
      'addDate': addDate,
      'phoneNo': phoneNo,
      
    };
    try {
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
