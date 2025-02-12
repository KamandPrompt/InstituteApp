import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  // Store password
  Future<void> storePassword(String key, String password) async {
    await _storage.write(key: key, value: password);
  }

  // Retrieve password
  Future<String?> getPassword(String key) async {
    return await _storage.read(key: key);
  }

  // Delete password
  Future<void> deletePassword(String key) async {
    await _storage.delete(key: key);
  }
}
import 'package:flutter/material.dart';
import 'services/secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PasswordScreen(),
    );
  }
}

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final SecureStorage _secureStorage = SecureStorage();
  final TextEditingController _passwordController = TextEditingController();
  String? _retrievedPassword;

  Future<void> _savePassword() async {
    await _secureStorage.storePassword('user_password', _passwordController.text);
    setState(() {
      _retrievedPassword = "Password saved!";
    });
  }

  Future<void> _loadPassword() async {
    final password = await _secureStorage.getPassword('user_password');
    setState(() {
      _retrievedPassword = password ?? "No password found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Password Storage")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Enter Password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _savePassword, child: const Text("Save Password")),
            ElevatedButton(onPressed: _loadPassword, child: const Text("Retrieve Password")),
            const SizedBox(height: 10),
            Text(_retrievedPassword ?? ""),
          ],
        ),
      ),
    );
  }
}

