import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    _checkUserLoggedIn();
    super.initState();
  }

  Future<void> _checkUserLoggedIn() async {
    // Check if a user token exists
    final token = await _storage.read(key: 'user');
    if (!mounted) return;
    // Navigate based on the token presence
    if (token != null) {
      GoRouter.of(context).goNamed(UhlLinkRoutesNames.home,
          pathParameters: {'isGuest': jsonEncode(false), 'user': token});
    } else {
      GoRouter.of(context).goNamed(UhlLinkRoutesNames.chooseAuth);
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
