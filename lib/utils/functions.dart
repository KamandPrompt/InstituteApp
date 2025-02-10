import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uhl_link/features/authentication/domain/entities/user_entity.dart';
import 'package:url_launcher/url_launcher.dart';

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