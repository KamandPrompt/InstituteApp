import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:vertex/features/home/data/models/post_model.dart';
import 'package:vertex/utils/cloudinary_services.dart';

class PostDB {
  static Db? db;
  static DbCollection? collection;

  PostDB();

  static Future<void> connect(String connectionURL) async {
    db = await Db.create(connectionURL);
    await db?.open();
    inspect(db);
    collection = db?.collection('Post');
  }

  // Get All Data Method
  Future<List<PostItem>> getPostItems() async {
    try {
      final items = await collection?.find().toList();
      if (items != null) {
        log("inside portal-${items.toString()}");
        return items.map((item) => PostItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Add Lost Found Item
  Future<PostItem?> addOrEditPostitem(
      String? id,
      String title,
      String description,
      FilePickerResult images,
      String link,
      String host,
      String type,
      String emailId,
      DateTime createdAt,
      DateTime updatedAt) async {
    List<String> imagesList = await uploadImagesToPosts(images);
    if (id != null) {
      try {
        ObjectId objId = ObjectId.fromHexString(id);
        final success = await collection?.updateOne(
            where.eq('_id', objId),
            ModifierBuilder()
              ..set('title', title)
              ..set('description', description)
              ..set('images', imagesList)
              ..set('link', link)
              ..set('host', host)
              ..set('type', type)
              ..set('emailId', emailId)
              ..set('createdAt', createdAt)
              ..set('updatedAt', updatedAt));
        if (success != null && success.isSuccess) {
          final updatedDoc = await collection?.findOne(where.eq('_id', objId));
          if (updatedDoc != null) {
            return PostItem.fromJson(updatedDoc);
          }
        }
        return null;
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
    final itemValues = {
      '_id': ObjectId(),
      'title': title,
      'description': description,
      'images': imagesList,
      'link': link,
      'host': host,
      'type': type,
      'emailId': emailId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
    try {
      final id = await collection?.insertOne(itemValues);
      if (id != null && id.document != null) {
        return PostItem.fromJson(id.document!);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Delete Post Item
  Future<bool> deletePostItem(String id) async {
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

  // Close Connection
  Future<void> close() async {
    await db?.close();
  }
}
