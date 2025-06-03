import 'dart:developer';
import 'package:vertex/utils/functions.dart';
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
      final config = await loadEncryptedConfig();
      await Future.wait([
        UhlUsersDB.connect(config['DB_CONNECTION_URL']!),
        JobPortalDB.connect(config['DB_CONNECTION_URL']!),
        LostFoundDB.connect(config['DB_CONNECTION_URL']!),
        BuySellDB.connect(config['DB_CONNECTION_URL']!),
        NotificationsDB.connect(config['DB_CONNECTION_URL']!),
        FeedDB.connect(config['DB_CONNECTION_URL']!),
      ]);
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      log('Error connecting to DB: $e');
    }
  }
}
