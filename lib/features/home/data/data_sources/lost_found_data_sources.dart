import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uhl_link/features/home/data/models/lost_found_item_model.dart';
import 'package:uhl_link/utils/cloudinary_services.dart';

class LostFoundDB {
  static Db? db;
  static DbCollection? collection;

  LostFoundDB();

  static Future<void> connect(String connectionURL) async {
    db = await Db.create(connectionURL);
    await db?.open();
    inspect(db);
    collection = db?.collection('Lost Found');
  }

  // Get All Data Method
  Future<List<LostFoundItem>> getLostFoundItems() async {
    try {
      final items = await collection?.find().toList();
      if (items != null) {
        // log(items.toString());
        return items.map((item) => LostFoundItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Add Lost Found Item
  Future<LostFoundItem?> addLostFoundItem(
      String from,
      String lostOrFound,
      String name,
      String description,
      FilePickerResult images,
      DateTime date,
      String phoneNo) async {
    try {
      List<String> imagesList = await uploadImagesToLNF(images);
      // log(imagesList.toString());
      final itemValues = {
        '_id': ObjectId(),
        'from': from,
        'lostOrFound': lostOrFound,
        'name': name,
        'description': description,
        'images': imagesList,
        'date': date,
        'phoneNo': phoneNo
      };
      final id = await collection?.insertOne(itemValues);
      if (id != null && id.document != null) {
        return LostFoundItem.fromJson(id.document!);
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Close Connection
  Future<void> close() async {
    await db?.close();
  }
}
