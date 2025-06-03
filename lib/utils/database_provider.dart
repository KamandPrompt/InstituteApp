import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import '../features/authentication/data/data_sources/user_data_sources.dart'
    show UhlUsersDB;
import '../features/home/data/data_sources/feed_portal_data_sources.dart'
    show FeedDB;
import '../features/home/data/data_sources/notification_data_sources.dart'
    show NotificationsDB;
import '../features/home/data/data_sources/buy_sell_data_sources.dart'
    show BuySellDB;
import '../features/home/data/data_sources/job_portal_data_sources.dart'
    show JobPortalDB;
import '../features/home/data/data_sources/lost_found_data_sources.dart';

class DatabaseProvider with ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> connectToDB() async {
    try {
      await dotenv.load(fileName: "institute.env");
      await Future.wait([
        UhlUsersDB.connect(dotenv.env['DB_CONNECTION_URL']!),
        JobPortalDB.connect(dotenv.env['DB_CONNECTION_URL']!),
        LostFoundDB.connect(dotenv.env['DB_CONNECTION_URL']!),
        BuySellDB.connect(dotenv.env['DB_CONNECTION_URL']!),
        NotificationsDB.connect(dotenv.env['DB_CONNECTION_URL']!),
        FeedDB.connect(dotenv.env['DB_CONNECTION_URL']!),
      ]);
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      log('Error connecting to DB: $e');
    }
  }
}
