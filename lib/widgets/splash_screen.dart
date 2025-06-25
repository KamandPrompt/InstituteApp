import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';

import '../utils/functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    final dbConnection = connectToDB();

    _checkUserLoggedIn(dbConnection);
  }

  Future<void> _checkUserLoggedIn(Future<void> dbConnection) async {
    try {
      // Check if a user token exists
      final token = await _storage.read(key: 'user');

      // Wait for the database connection to complete
      await dbConnection;

      // Navigate based on the token presence
      if (token != null) {
        GoRouter.of(context).goNamed(UhlLinkRoutesNames.home, extra: {
          'isGuest': false,
          'user': UserEntity.fromJson(jsonDecode(token))
        });
      } else {
        GoRouter.of(context).goNamed(UhlLinkRoutesNames.chooseAuth);
      }
    } catch (e) {
      await _storage.deleteAll();
      GoRouter.of(context).goNamed(UhlLinkRoutesNames.chooseAuth);
      debugPrint('Error during splash screen initialization: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
