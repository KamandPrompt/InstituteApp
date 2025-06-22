import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:vertex/features/home/data/models/lost_found_item_model.dart';
import 'package:vertex/utils/cloudinary_services.dart';

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
  Future<LostFoundItem?> addOrEditLostFoundItem(
      String? id,
      String from,
      String lostOrFound,
      String name,
      String description,
      FilePickerResult images,
      DateTime createdAt,
      DateTime updatedAt,
      String phoneNo) async {
      List<String> imagesList = await uploadImagesToLNF(images);
      if (id != null) {
        try {
          ObjectId objId = ObjectId.fromHexString(id);
          final success = await collection?.updateOne(
            where.eq('_id', objId),
            ModifierBuilder()
              ..set('from', from)
              ..set('lostOrFound', lostOrFound)
              ..set('name', name)
              ..set('description', description)
              ..set('images', imagesList)
              ..set('createdAt', createdAt)
              ..set('updatedAt', updatedAt)
              ..set('phoneNo', phoneNo),
          );
          if (success != null && success.isSuccess) {
            return LostFoundItem(
                id: id,
                from: from,
                lostOrFound: lostOrFound,
                name: name,
                description: description,
                images: imagesList,
                createdAt: createdAt,
                updatedAt: updatedAt,
                phoneNo: phoneNo);
          } else {
            return null;
          }
        } catch (e) {
          log(e.toString());
          return null;
        }
      }
    try {
      final itemValues = {
        '_id': ObjectId(),
        'from': from,
        'lostOrFound': lostOrFound,
        'name': name,
        'description': description,
        'images': imagesList,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
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

  // Delete Lost Found Item
  Future<bool> deleteLostFoundItem(String id) async {
    try {
      ObjectId objId = ObjectId.fromHexString(id);
      final result = await collection?.remove(where.eq('_id', objId));
      if (result != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Close Connection
  Future<void> close() async {
    await db?.close();
  }
}
