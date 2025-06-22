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

  Future<BuySellItem?> addOrEditItem(
    String? id,
    String productName,
    String productDescription,
    FilePickerResult productImage,
    String soldBy,
    String maxPrice,
    String minPrice,
    DateTime createdAt,
    DateTime updatedAt,
    String phoneNo,
  ) async {
    List<String> imagesList = await uploadImagesToBNS(productImage);
    if (id != null) {
      try {
        ObjectId objId = ObjectId.fromHexString(id);
        final success = await collection?.updateOne(
          where.eq('_id', objId),
          ModifierBuilder()
            ..set('productName', productName)
            ..set('productDescription', productDescription)
            ..set('productImage', imagesList)
            ..set('soldBy', soldBy)
            ..set('maxPrice', maxPrice)
            ..set('minPrice', minPrice)
            ..set('createdAt', createdAt)
            ..set('updatedAt', updatedAt)
            ..set('phoneNo', phoneNo),
        );
        if (success != null && success.isSuccess) {
          final updatedDoc = await collection?.findOne(where.eq('_id', objId));
          if (updatedDoc != null) {
            return BuySellItem.fromJson(updatedDoc);
          }
        }
        return null;
      } catch (e) {
        print("Error updating item: ${e.toString()}");
        return null;
      }
    }
    try {
      final itemValues = {
        '_id': ObjectId(),
        'productName': productName,
        'productDescription': productDescription,
        'productImage': imagesList,
        'soldBy': soldBy,
        'maxPrice': maxPrice,
        'minPrice': minPrice,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
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

    // Delete BuySell Item
  Future<bool> deleteBuySellItem(String id) async {
    try {
      ObjectId objId = ObjectId.fromHexString(id);
      final result = await collection?.remove(where.eq('_id', objId));
      if (result != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Close Database Connection
  Future<void> close() async {
    await db?.close();
  }
}
