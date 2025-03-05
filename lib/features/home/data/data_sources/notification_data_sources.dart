import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:uhl_link/features/home/data/models/lost_found_item_model.dart';
import 'package:uhl_link/features/home/data/models/notification_model.dart';

import '../../../../utils/cloudinary_services.dart';

class NotificationsDB {
  static Db? db;
  static DbCollection? collection;

  NotificationsDB();

  static Future<void> connect(String connectionURL) async {
    db = await Db.create(connectionURL);
    await db?.open();
    inspect(db);
    collection = db?.collection('Notifications');
  }

  // Get All Notifications Method
  Future<List<Notification>> getNotifications() async {
    try {
      final items = await collection?.find().toList();
      if (items != null) {
        return items.map((item) => Notification.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // log(e.toString());
      return [];
    }
  }

  // Add Notification
  Future<Notification?> addNotifications(
    String title,
    String by,
    String description,
    String? image,
  ) async {
    if (image != null) {
      image = await uploadImageToNotifications(image);
    }
    final itemValues = {
      '_id': ObjectId(),
      'title': title,
      'by': by,
      'description': description,
      'image': image ?? ""
    };

    try {
      final id = await collection?.insertOne(itemValues);
      if (id != null && id.document != null) {
        return Notification.fromJson(id.document!);
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
