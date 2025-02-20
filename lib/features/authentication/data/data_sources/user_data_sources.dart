import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:uhl_link/utils/password_functions.dart';

import '../models/user_model.dart';

class UhlUsersDB {
  static Db? db;
  static DbCollection? collection;

  UhlUsersDB();

  static Future<void> connect(String connectionURL) async {
    db = await Db.create(connectionURL);
    await db?.open();
    inspect(db);
    collection = db?.collection('Users');
  }

  // Get All Data
  Future<List<Object>?> getData() async {
    try {
      final users = await collection?.find().toList();
      return users;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Get All Users Method
  Future<List<User>?> getUsers() async {
    try {
      final users = await collection?.find().toList();
      return users?.map((user) => User.fromJson(user)).toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // create
  Future<User?> createUser(
      String name, String email, String password, String? image) async {
    final userValues = {
      '_id': ObjectId(),
      'name': name,
      'email': email,
      'password': hashPassword(password),
      'image': image ?? ""
    };
    try {
      final id = await collection?.insertOne(userValues);
      if (id != null && id.document != null) {
        // log(id.document.toString());
        return User.fromJson(id.document!);
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Update
  Future<bool?> updatePassword(String email, String password) async {
    try {
      // log(id);
      // ObjectId objId = ObjectId.fromHexString(id);
      final success = await collection?.updateOne(
          where.eq('email', email), ModifierBuilder()..set('password', hashPassword(password)));
      return success?.isSuccess;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool?> updateImage(String id, String image) async {
    try {
      // log(id);
      ObjectId objId = ObjectId.fromHexString(id);
      final success = await collection?.updateOne(
          where.eq('_id', objId), ModifierBuilder()..set('image', image));
      return success?.isSuccess;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Get By XYZ Methods
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    try {
      final users = await collection
          ?.find(where.eq('email', email))
          .toList();
      if (users?.length != 1) {
        return null;
      } else {
        if (validatePassword(password, users!.first['password'])) {
          log("message");
          return User.fromJson(users.first);
        } else {
          log("messagaae");
          return null;
        }
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<User>> getUserByEmail(String email) async {
    try {
      final users = await collection?.find(where.eq('email', email)).toList();
      if (users!.isNotEmpty) {
        return users.map((user) => User.fromJson(user)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<User>> getUserById(String id) async {
    try {
      ObjectId objId = ObjectId.fromHexString(id);
      final users = await collection?.find(where.eq('_id', objId)).toList();
      if (users!.isNotEmpty) {
        return users.map((user) => User.fromJson(user)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Close Connection
  Future<void> close() async {
    await db?.close();
    log('Connection to MongoDB closed');
  }
}
