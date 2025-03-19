import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uhl_link/features/home/data/models/feed_model.dart';
import 'package:uhl_link/utils/cloudinary_services.dart';

class FeedDB {
  static Db? db;
  static DbCollection? collection;

  FeedDB();

  static Future<void> connect(String connectionURL) async {
    db = await Db.create(connectionURL);
    await db?.open();
    inspect(db);
    collection = db?.collection('Feed');
  }

  // Get All Data Method
  Future<List<FeedItem>> getFeedItems() async {
    try {
      final items = await collection?.find().toList();
      if (items != null) {
        // log("inside portal-${items.toString()}");
        return items.map((item) => FeedItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Add Lost Found Item
  Future<FeedItem?> addFeeditem(
      String title, String description, FilePickerResult images, String link, String host) async {
    List<String> imagesList = await uploadImagesToFeeds(images);
    final itemValues = {
      '_id': ObjectId(),
      'title': title,
      'description': description,
      'images': imagesList,
      'link': link,
      'host': host,
    };
    try {
      final id = await collection?.insertOne(itemValues);
      if (id != null && id.document != null) {
        return FeedItem.fromJson(id.document!);
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