import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:uhl_link/features/home/data/models/feed_model.dart';

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
  Future<List<Feeditem>> getFeedItems() async {
    try {
      final items = await collection?.find().toList();
      if (items != null) {
        log("inside portal-${items.toString()}");
        return items.map((item) => Feeditem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Add Lost Found Item
  Future<Feeditem?> addFeeditem(
      String host, String description, List<String> images, String link) async {
    final itemValues = {
      '_id': ObjectId(),
      'host': host,
      'description': description,
      'images': images,
      'link': link
    };
    try {
      final id = await collection?.insertOne(itemValues);
      if (id != null && id.document != null) {
        return Feeditem.fromJson(id.document!);
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
    print('Connection to MongoDB closed');
  }
}