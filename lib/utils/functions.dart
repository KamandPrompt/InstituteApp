import 'dart:convert';
import 'dart:developer';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/authentication/data/data_sources/user_data_sources.dart'
    show UhlUsersDB;
import '../features/home/data/data_sources/post_portal_data_sources.dart'
    show PostDB;
import '../features/home/data/data_sources/notification_data_sources.dart'
    show NotificationsDB;
import '../features/home/data/data_sources/buy_sell_data_sources.dart'
    show BuySellDB;
import '../features/home/data/data_sources/job_portal_data_sources.dart'
    show JobPortalDB;
import '../features/home/data/data_sources/lost_found_data_sources.dart';
import '../features/authentication/domain/entities/user_entity.dart';

String getIdFromDriveLink(String url) {
  final RegExp regex =
      RegExp(r"https://drive\.google\.com/file/d/([^/]+)/view");
  final match = regex.firstMatch(url);
  if (match != null) {
    return match.group(1)!;
  } else {
    return "";
  }
}

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url.trim());
  log("$uri");
  try {
    await launchUrl(uri);
    log('Launched successfully');
  } catch (e) {
    log('Error occurred while launching: $e');
    throw 'Could not launch $url';
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<bool> checkUserLoggedIn() async {
  const storage = FlutterSecureStorage();

  final token = await storage.read(key: 'user');
  if (token != null) {
    return true;
  } else {
    return false;
  }
}

Future<UserEntity?> getUser() async {
  const storage = FlutterSecureStorage();

  final token = await storage.read(key: 'user');
  if (token != null) {
    return UserEntity.fromJson(jsonDecode(token));
  } else {
    return null;
  }
}

Future<Map<String, String>> loadEncryptedConfig() async {
  final bytes = await rootBundle.load('.enc');
  final data = bytes.buffer.asUint8List();

  final key = Key.fromUtf8('iioft_mandi_kamandprompt_sntc_pc');
  final iv = IV(data.sublist(0, 16));
  final encrypted = Encrypted(data.sublist(16));

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  final configLines = decrypted.split('\n');
  final config = <String, String>{};

  for (final line in configLines) {
    if (line.contains('=')) {
      final parts = line.split('=');
      config[parts[0].trim()] = parts[1].trim();
    }
  }

  return config;
}

Future<void> connectToDB() async {
  try {
    final config = await loadEncryptedConfig();
    await Future.wait([
      UhlUsersDB.connect(config['DB_CONNECTION_URL']!),
      JobPortalDB.connect(config['DB_CONNECTION_URL']!),
      LostFoundDB.connect(config['DB_CONNECTION_URL']!),
      BuySellDB.connect(config['DB_CONNECTION_URL']!),
      NotificationsDB.connect(config['DB_CONNECTION_URL']!),
      PostDB.connect(config['DB_CONNECTION_URL']!),
    ]);
  } catch (e) {
    log('Error connecting to DB: $e');
  }
}
